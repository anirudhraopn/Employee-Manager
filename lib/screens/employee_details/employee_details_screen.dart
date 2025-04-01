import 'dart:math';

import 'package:employee_manager/constants/role.dart';
import 'package:employee_manager/main.dart';
import 'package:employee_manager/models/employee.dart';
import 'package:employee_manager/screens/home/bloc/home_bloc.dart';
import 'package:employee_manager/screens/home/bloc/home_events.dart';
import 'package:employee_manager/utils/app_date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  const EmployeeDetailsScreen({super.key, this.employee});
  final Employee? employee;

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final ValueNotifier<String?> selectedRoleNotifier = ValueNotifier(null);
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  bool isEditing = false;
  DateTime? startDate, endDate;
  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      isEditing = true;
      final employee = widget.employee;
      nameController.text = employee!.name;
      selectedRoleNotifier.value = employee.role;
      startDate = employee.startDate;
      endDate = employee.endDate;
      startDateController.text =
          ApPDateUtils.getFormatedDateForList(startDate!);
      endDateController.text =
          endDate == null ? '' : ApPDateUtils.getFormatedDateForList(endDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(!isEditing ? 'Add Employee Details' : 'Edit Employee Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                    ),
                    DropdownButtonFormField(
                      value: selectedRoleNotifier.value,
                      icon: Transform.rotate(
                          angle: pi / 2, child: Icon(Icons.play_arrow_rounded)),
                      items: roles
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        selectedRoleNotifier.value = value ?? '';
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: startDateController,
                            onTap: () async {
                              startDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2050),
                                currentDate: DateTime.now(),
                              );
                              if (startDate != null) {
                                startDateController.text =
                                    ApPDateUtils.getFormatedDateForList(
                                        startDate!);
                              }
                            },
                          ),
                        ),
                        Icon(
                          Icons.arrow_right_alt_sharp,
                          color: Theme.of(context).primaryColor,
                        ),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: endDateController,
                            onTap: () async {
                              endDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2050),
                                currentDate: DateTime.now(),
                              );
                              if (endDate != null) {
                                endDateController.text =
                                    ApPDateUtils.getFormatedDateForList(
                                        endDate!);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.2),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final employee = Employee(
                    name: nameController.text,
                    role: selectedRoleNotifier.value!,
                    startDate: startDate!,
                    endDate: endDate,
                  );
                  context.read<HomeBloc>().add(isEditing
                      ? EditEmployee(widget.employee!.key, employee: employee)
                      : AddEmployee(employee: employee));
                },
                child: Text(
                  'Save',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
