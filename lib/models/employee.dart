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
  @HiveField(4)
  final bool isDeleted;

  Employee({
    required this.name,
    required this.role,
    required this.startDate,
    required this.endDate,
    this.isDeleted = false,
  });

  Employee copyWith({
    String? name,
    String? role,
    DateTime? startDate,
    DateTime? endDate,
    bool? isDeleted,
  }) {
    return Employee(
      name: name ?? this.name,
      role: role ?? this.role,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

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
