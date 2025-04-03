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

class HardDeleteEmployee extends HomeEvents {
  final dynamic key;

  HardDeleteEmployee(
    this.key,
  );
}

class SoftDeleteEmployee extends HomeEvents {
  final dynamic key;

  SoftDeleteEmployee({required this.key});
}

class UndoDelete extends HomeEvents {
  final dynamic key;

  UndoDelete({required this.key});
}

class AutoDeleteDeletedEmployees extends HomeEvents{}
