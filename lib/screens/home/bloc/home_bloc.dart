import 'package:employee_manager/hive_helper.dart';
import 'package:employee_manager/screens/home/bloc/home_events.dart';
import 'package:employee_manager/screens/home/bloc/home_state.dart';
import 'package:employee_manager/utils/app_error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/employee.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  HomeBloc(super.initialState) {
    on(registerHandler);
  }

  void registerHandler(HomeEvents event, Emitter<HomeState> emit) async {
    emit(LoadingData());
    switch (event) {
      case FetchEmployees():
        fetchEmployees(emit);
        break;
      case AddEmployee():
        await addEmployee(event, emit);
        break;
      case EditEmployee():
       await editEmployee(event, emit);
        break;
      default:
        emit(EmployeesListFailure());
    }
  }

  void fetchEmployees(Emitter<HomeState> emit) {
    try {
      final list = getEmployees();
      if (list.isEmpty) {
        emit(EmployeesListEmpty());
      } else {
        emit(EmployeesListSuccess(employeeList: list));
      }
    } catch (e, s) {
      AppErrorHandler.onError(e, s, 'fetchEmployees');
    }
  }

  Future<void> addEmployee(AddEmployee event, Emitter<HomeState> emit) async {
    await HiveHelper.addEmployee(event.employee);
    emit(EmployeesListSuccess(employeeList: getEmployees()));
  }

  Future<void> editEmployee(EditEmployee event, Emitter<HomeState> emit) async {
    try {
      await HiveHelper.updateEmployee(event.key, event.employee);
      emit(EmployeesListSuccess(employeeList: getEmployees()));
    } catch (e, s) {
      AppErrorHandler.onError(e, s, 'editEmployee');
    }
  }

  List<Employee> getEmployees() {
    final list = HiveHelper.employeeBox.values.toList();
    return list;
  }
}
