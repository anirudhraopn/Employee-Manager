import '../../../models/employee.dart';

sealed class HomeState {}

class LoadingData extends HomeState {}

class EmployeesListSuccess extends HomeState {
  final List<Employee> employeeList;

  EmployeesListSuccess({required this.employeeList});
}

class EmployeesListEmpty extends HomeState {}

class EmployeesListFailure extends HomeState {}

class SoftDeletedSuccessfully extends HomeState {
  final Employee employee;

  SoftDeletedSuccessfully(this.employee);
}

class RestoreSuccessful extends HomeState {
  final Employee employee;

  RestoreSuccessful(this.employee);
}

class HardDeletedEmployee extends HomeState {
  final Employee employee;

  HardDeletedEmployee({required this.employee});
}

class AutoDeleteSuccessful extends HomeState {}
