import 'dart:math';

import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:employee_manager/constants/app_colors.dart';
import 'package:employee_manager/constants/app_constants.dart';
import 'package:employee_manager/main.dart';
import 'package:employee_manager/models/employee.dart';
import 'package:employee_manager/screens/home/bloc/home_bloc.dart';
import 'package:employee_manager/screens/home/bloc/home_events.dart';
import 'package:employee_manager/utils/app_date_utils.dart';
import 'package:employee_manager/utils/app_icons.dart';
import 'package:employee_manager/widgets/app_button.dart';
import 'package:employee_manager/widgets/app_text_field.dart';
import 'package:employee_manager/widgets/my_date_picker.dart';
import 'package:employee_manager/widgets/save_cancel_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  const EmployeeDetailsScreen({super.key, this.employee});
  final Employee? employee;

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final TextEditingController selectedRoleController = TextEditingController();
  final TextEditingController startDateController =
      TextEditingController(text: 'Today');
  final TextEditingController endDateController =
      TextEditingController(text: 'No date');
  bool isEditing = false;
  DateTime? startDate = DateTime.now(), endDate;
  String? selectedRole;
  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      isEditing = true;
      final employee = widget.employee;
      nameController.text = employee!.name;
      selectedRoleController.text = employee.role;
      startDate = employee.startDate;
      endDate = employee.endDate;
      startDateController.text = getStringFromDate(startDate);
      endDateController.text = getStringFromDate(endDate);
    }
  }

  static String getStringFromDate(DateTime? date) {
    if (date == null) {
      return 'No date';
    }
    return AppDateUtils.isToday(date)
        ? 'Today'
        : AppDateUtils.getFormatedDateForList(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Text(!isEditing ? 'Add Employee Details' : 'Edit Employee Details'),
        actions: [
          isEditing
              ? IconButton(
                  onPressed: () {
                    context
                        .read<HomeBloc>()
                        .add(DeleteEmployee(widget.employee!.key));
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    CupertinoIcons.trash,
                  ),
                )
              : SizedBox(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppTextField(
                        controller: nameController,
                        hintText: 'Employee Name',
                        prefixIcon: AppIcons.person,
                      ),
                      AppTextField(
                        controller: selectedRoleController,
                        prefixIcon: AppIcons.role,
                        hintText: 'Select role',
                        onTap: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final role = await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  AppConstants.roles.length,
                                  (index) {
                                    final role = AppConstants.roles[index];
                                    return ListTile(
                                      onTap: () {
                                        Navigator.pop(context, role);
                                      },
                                      title: Text(
                                        role,
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                          selectedRole = role;
                          selectedRoleController.text = role;
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              readOnly: true,
                              controller: startDateController,
                              hintText: 'Start Date',
                              prefixIcon: AppIcons.calendar,
                              onTap: () async {
                                startDate = await showCustomDatePicker(
                                    context: context,
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime(2050),
                                    initialDate: DateTime.now(),
                                    quickButtonList: [
                                      QuickButton(
                                        text: 'Today',
                                        onTap: (currentDateNotifier) {
                                          final date = DateTime.now();
                                          currentDateNotifier.value = date;
                                        },
                                      ),
                                      QuickButton(
                                        text: 'Next Monday',
                                        onTap: (currentDateNotifier) {
                                          final date =
                                              AppDateUtils.getDateForDay(
                                                  1, DateTime.now());
                                          currentDateNotifier.value = date;
                                        },
                                      ),
                                      QuickButton(
                                        text: 'Next Tuesday',
                                        onTap: (currentDateNotifier) {
                                          final date =
                                              AppDateUtils.getDateForDay(
                                                  2, DateTime.now());
                                          currentDateNotifier.value = date;
                                        },
                                      ),
                                      QuickButton(
                                        text: 'After 1 week',
                                        onTap: (currentDateNotifier) {
                                          final nextWeek = DateTime.now()
                                              .add(Duration(days: 7));
                                          currentDateNotifier.value = nextWeek;
                                        },
                                      ),
                                    ]);
                                if (startDate != null) {
                                  startDateController.text =
                                      AppDateUtils.getFormatedDateForList(
                                          startDate!);
                                }
                              },
                            ),
                          ),
                          Container(
                              width: 50,
                              alignment: Alignment.center,
                              child: SvgPicture.asset(AppIcons.arrow)),
                          Expanded(
                            child: AppTextField(
                              readOnly: true,
                              controller: endDateController,
                              hintText: 'End date',
                              prefixIcon: AppIcons.calendar,
                              onTap: () async {
                                endDate = await showCustomDatePicker(
                                    context: context,
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime(2050),
                                    initialDate: DateTime.now(),
                                    quickButtonList: [
                                      QuickButton(
                                        text: 'No date',
                                        onTap: (currentDate) {
                                          currentDate.value = null;
                                        },
                                      ),
                                      QuickButton(
                                        text: 'Today',
                                        onTap: (currentDate) {
                                          currentDate.value = DateTime.now();
                                        },
                                      ),
                                    ]);
                                if (endDate != null) {
                                  endDateController.text =
                                      AppDateUtils.getFormatedDateForList(
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
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: SaveCancelRow(
                onCancel: () {
                  Navigator.pop(context);
                },
                onSave: () {
                  final employee = Employee(
                    name: nameController.text,
                    role: selectedRoleController.text,
                    startDate: startDate!,
                    endDate: endDate,
                  );
                  context.read<HomeBloc>().add(isEditing
                      ? EditEmployee(widget.employee!.key, employee: employee)
                      : AddEmployee(employee: employee));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  List<QuickButton> quickButtonList = const [],
}) async {
  final result = await showDialog(
    context: context,
    builder: (context) {
      return MyDatePicker(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          quickButtonList: quickButtonList);
    },
  );
  return result;
}
