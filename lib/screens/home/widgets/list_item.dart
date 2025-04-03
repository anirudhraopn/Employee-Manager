import 'package:employee_manager/constants/app_colors.dart';
import 'package:employee_manager/constants/app_text_styles.dart';
import 'package:employee_manager/models/employee.dart';
import 'package:employee_manager/screens/employee_details/employee_details_screen.dart';
import 'package:employee_manager/screens/home/bloc/home_bloc.dart';
import 'package:employee_manager/screens/home/bloc/home_events.dart';
import 'package:employee_manager/utils/app_date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.employee});
  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => EmployeeDetailsScreen(
                  employee: employee,
                ),
              ));
        },
      child: Dismissible(
        key: Key(employee.key.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                CupertinoIcons.delete,
                color: Colors.white,
              ),
            ],
          ),
        ),
        onDismissed: (direction) {
          context.read<HomeBloc>().add(SoftDeleteEmployee(key:employee.key));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                employee.name,
                style:  AppTextStyles.headingStyle,
              ),
              Text(
                employee.role.isEmpty ? '' : employee.role,
                style: const TextStyle(
                  color: AppColors.textGrey,
                ),
              ),
              Text(
                AppDateUtils.getFormatedDateForList(
                  employee.startDate,
                  endDate: employee.endDate,
                ),
                style: const TextStyle(
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
