import 'dart:developer';

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
    log(event.toString());
    if (![AutoDeleteDeletedEmployees, HardDeleteEmployee]
        .contains(event.runtimeType)) {
      emit(LoadingData());
    }
    try {
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
        case HardDeleteEmployee():
          await _deleteEmployee(event, emit);
          break;
        case SoftDeleteEmployee():
          await _softDeleteEmployee(event, emit);
          break;
        case UndoDelete():
          await _restoreEmployee(event, emit);
        case AutoDeleteDeletedEmployees():
          await _autoDeleteDeletedEmployees(event, emit);
      }
    } catch (e, s) {
      AppErrorHandler.onError(e, s, 'registerHandler');
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
    final list = HiveHelper.employeeBox.values
        .where(
          (element) => !element.isDeleted,
        )
        .toList();
    return list;
  }

  Future<void> _deleteEmployee(
      HardDeleteEmployee event, Emitter<HomeState> emit) async {
    final employeeIndex = HiveHelper.getEmployeeIndex(event.key);
    Employee? employee;
    if (employeeIndex != null) {
      employee = HiveHelper.employeeBox.values.toList()[employeeIndex];
    }
    await HiveHelper.deleteEmployee(event.key);
    emit(HardDeletedEmployee(employee: employee!));
  }

  Future<void> _restoreEmployee(
      UndoDelete event, Emitter<HomeState> emit) async {
    final employee = HiveHelper.employeeBox.get(event.key);
    final newEmployee = employee!.copyWith(isDeleted: false);
    await HiveHelper.updateEmployee(event.key, newEmployee);
    emit(RestoreSuccessful(newEmployee));
    _fetchEmployees(emit);
  }

  Future<void> _softDeleteEmployee(
      SoftDeleteEmployee event, Emitter<HomeState> emit) async {
    final employee = HiveHelper.employeeBox.get(event.key);
    final newEmployee = employee!.copyWith(isDeleted: true);
    await HiveHelper.updateEmployee(event.key, newEmployee);
    emit(SoftDeletedSuccessfully(newEmployee));
    _fetchEmployees(emit);
  }

  Future<void> _autoDeleteDeletedEmployees(
      HomeEvents event, Emitter<HomeState> emit) async {
    final list = HiveHelper.employeeBox.values
        .where(
          (element) => element.isDeleted,
        )
        .toList();
    await HiveHelper.deleteEmployees(list);
    _fetchEmployees(emit);
  }
}
