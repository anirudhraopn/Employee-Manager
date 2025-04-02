import 'package:employee_manager/constants/app_colors.dart';
import 'package:employee_manager/models/employee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'list_item.dart';

class EmployeeList extends StatelessWidget {
  const EmployeeList(
      {super.key, required this.title, required this.employeeList});

  final String title;
  final List<Employee> employeeList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppColors.bgColor,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: employeeList.length,
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemBuilder: (context, index) {
              final employee = employeeList[index];
              return ListItem(employee: employee);
            },
          ),
        ),
      ],
    );
  }
}
