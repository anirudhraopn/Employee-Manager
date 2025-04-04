import 'dart:developer';

import 'package:employee_manager/constants/app_colors.dart';
import 'package:employee_manager/models/employee.dart';
import 'package:employee_manager/screens/employee_details/employee_details_screen.dart';
import 'package:employee_manager/screens/home/bloc/home_bloc.dart';
import 'package:employee_manager/screens/home/bloc/home_events.dart';
import 'package:employee_manager/screens/home/bloc/home_state.dart';
import 'package:employee_manager/screens/home/widgets/employee_list.dart';
import 'package:employee_manager/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(AutoDeleteDeletedEmployees());
    // context.read<HomeBloc>().add(FetchEmployees());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) async {
        log(state.runtimeType.toString());
        if (state is SoftDeletedSuccessfully) {
          final controller = ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Employee data has been deleted'),
              action: SnackBarAction(
                onPressed: () {
                  context
                      .read<HomeBloc>()
                      .add(UndoDelete(key: state.employee.key));
                },
                label: 'Undo',
              ),
            ),
          );
          final reason = await controller.closed;
          if (reason != SnackBarClosedReason.action && context.mounted) {
            context
                .read<HomeBloc>()
                .add(HardDeleteEmployee(state.employee.key));
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Employee List'),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) =>
              current.runtimeType != HardDeletedEmployee &&
              current.runtimeType != AutoDeleteSuccessful &&
              current.runtimeType != SoftDeletedSuccessfully,
          builder: (context, state) {
            if (state is LoadingData) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (state is EmployeesListEmpty || state is EmployeesListFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AppImages.noEmployees),
                    const Text('No employee records found'),
                  ],
                ),
              );
            }
            final employeeList = (state as EmployeesListSuccess).employeeList;
            List<Employee> currentEmployees = [];
            List<Employee> pastEmployees = [];

            pastEmployees = employeeList
                .where(
                  (element) =>
                      element.endDate != null &&
                      element.endDate!.isBefore(DateTime.now()),
                )
                .toList();
            currentEmployees = employeeList
                .where(
                  (element) =>
                      element.endDate == null ||
                      element.endDate!.isAfter(
                        DateTime.now(),
                      ),
                )
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                currentEmployees.isEmpty
                    ? const SizedBox()
                    : Expanded(
                        child: EmployeeList(
                            title: 'Current employees',
                            employeeList: currentEmployees)),
                pastEmployees.isEmpty
                    ? const SizedBox()
                    : Expanded(
                        child: EmployeeList(
                          title: 'Past employees',
                          employeeList: pastEmployees,
                        ),
                      ),
                Container(
                  color: AppColors.bgColor,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: const Text(
                    'Swipe left to delete',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                )
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmployeeDetailsScreen(),
                ));
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
