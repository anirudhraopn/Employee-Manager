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
        _fetchEmployees(emit);
        break;
      case AddEmployee():
        await _addEmployee(event, emit);
        break;
      case EditEmployee():
        await _editEmployee(event, emit);
        break;
      case DeleteEmployee():
        await _deleteEmployee(event, emit);
        break;
      default:
        emit(EmployeesListFailure());
    }
  }

  void _fetchEmployees(Emitter<HomeState> emit) {
    try {
      final list = _getEmployees();
      if (list.isEmpty) {
        emit(EmployeesListEmpty());
      } else {
        emit(EmployeesListSuccess(employeeList: list));
      }
    } catch (e, s) {
      AppErrorHandler.onError(e, s, '_fetchEmployees');
    }
  }

  Future<void> _addEmployee(AddEmployee event, Emitter<HomeState> emit) async {
    await HiveHelper.addEmployee(event.employee);
    _fetchEmployees(emit);
  }

  Future<void> _editEmployee(
      EditEmployee event, Emitter<HomeState> emit) async {
    try {
      await HiveHelper.updateEmployee(event.key, event.employee);
      _fetchEmployees(emit);
    } catch (e, s) {
      AppErrorHandler.onError(e, s, '_editEmployee');
    }
  }

  List<Employee> _getEmployees() {
    final list = HiveHelper.employeeBox.values.toList();
    return list;
  }

  Future<void> _deleteEmployee(
      DeleteEmployee event, Emitter<HomeState> emit) async {
    await HiveHelper.deleteEmployee(event.key);
    _fetchEmployees(emit);
  }
}
