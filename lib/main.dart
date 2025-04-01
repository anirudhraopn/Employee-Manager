import 'package:employee_manager/hive_helper.dart';
import 'package:employee_manager/models/employee.dart';
import 'package:employee_manager/screens/home/bloc/home_bloc.dart';
import 'package:employee_manager/screens/home/bloc/home_state.dart';
import 'package:employee_manager/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());
  await HiveHelper.openBox();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(EmployeesListEmpty()),
      child: MaterialApp(
        title: 'Employee Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
