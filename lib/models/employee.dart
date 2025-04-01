import 'dart:developer';

import 'package:hive_flutter/adapters.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String role;
  @HiveField(2)
  final DateTime startDate;
  @HiveField(3)
  final DateTime? endDate;

  Employee({
    required this.name,
    required this.role,
    required this.startDate,
    required this.endDate,
  });

  @override
  Future<void> save() {
    log('Saving $name data');
    return super.save();
  }

  @override
  Future<void> delete() {
    log('Deleting $name data');
    return super.save();
  }
}
