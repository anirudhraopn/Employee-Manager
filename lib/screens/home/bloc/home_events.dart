import 'package:employee_manager/models/employee.dart';

sealed class HomeEvents {}

class FetchEmployees extends HomeEvents {}

class AddEmployee extends HomeEvents {
  final Employee employee;

  AddEmployee({required this.employee});
}

class EditEmployee extends HomeEvents {
  final Employee employee;
  final dynamic key;

  EditEmployee(this.key, {required this.employee});
}

class DeleteEmployee extends HomeEvents {
  final dynamic key;

  DeleteEmployee(
    this.key,
  );
}
