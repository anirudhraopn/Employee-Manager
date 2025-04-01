import 'package:employee_manager/models/employee.dart';
import 'package:employee_manager/screens/employee_details/employee_details_screen.dart';
import 'package:employee_manager/screens/home/bloc/home_bloc.dart';
import 'package:employee_manager/screens/home/bloc/home_events.dart';
import 'package:employee_manager/screens/home/bloc/home_state.dart';
import 'package:employee_manager/utils/app_images.dart';
import 'package:employee_manager/utils/app_date_utils.dart';
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
    context.read<HomeBloc>().add(FetchEmployees());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
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
                (element) => element.endDate != null,
              )
              .toList();
          currentEmployees = employeeList
              .where(
                (element) => element.endDate == null,
              )
              .toList();

          return Column(
            children: [
              Text('Current Employees'),
              Expanded(
                child: ListView.builder(
                  itemCount: currentEmployees.length,
                  itemBuilder: (context, index) {
                    final employee = currentEmployees[index];
                    return ListItem(employee: employee);
                  },
                ),
              ),
              pastEmployees.isEmpty
                  ? SizedBox()
                  : Expanded(
                      child: Column(
                      children: [
                        Text('Past Employees'),
                        Expanded(
                          child: ListView.builder(
                            itemCount: pastEmployees.length,
                            itemBuilder: (context, index) {
                              final employee = pastEmployees[index];
                              return ListItem(employee: employee);
                            },
                          ),
                        ),
                      ],
                    ))
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeDetailsScreen(),
              ));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.add),
      ),
    );
  }
}

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
              builder: (context) => EmployeeDetailsScreen(
                employee: employee,
              ),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(employee.name),
            Text(employee.role.isEmpty ? 'ssd' : employee.role),
            Text(
              ApPDateUtils.getFormatedDateForList(
                employee.startDate,
                endDate: employee.endDate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
