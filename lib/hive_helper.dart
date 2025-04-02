import 'dart:math';

import 'package:employee_manager/constants/hive_constants.dart';
import 'package:employee_manager/models/employee.dart';
import 'package:employee_manager/utils/app_error_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static late final Box<Employee> employeeBox;

  static Future<void> openBox() async {
    employeeBox = await Hive.openBox(HiveContastants.employeeBox);
  }

  static Future<void> addEmployee(Employee employee) async {
    try {
      await employeeBox.add(employee);
    } catch (e, s) {
      AppErrorHandler.onError(e, s, 'addEmployee');
    }
  }

  static Future<void> updateEmployee(dynamic key, Employee employee) async {
    final index = employeeBox.values.toList().indexWhere(
      (element) {
        return key == element.key;
      },
    );
    if (index == -1) {
      return;
    }
    // await employeeBox.deleteAt(index);
    await employeeBox.putAt(max(index, 0), employee);
  }

static Future<void> deleteEmployee(dynamic key) async {
    final index = employeeBox.values.toList().indexWhere(
      (element) {
        return key == element.key;
      },
    );
    if (index == -1) {
      return;
    }
    // await employeeBox.deleteAt(index);
    await employeeBox.deleteAt(max(index, 0));
  }
}
