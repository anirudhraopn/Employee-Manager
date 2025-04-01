import '../../../models/employee.dart';

sealed class HomeState {}

class LoadingData extends HomeState {}

class EmployeesListSuccess extends HomeState {
  final List<Employee> employeeList;

  EmployeesListSuccess({required this.employeeList});
}

class EmployeesListEmpty extends HomeState {}

class EmployeesListFailure extends HomeState {}
