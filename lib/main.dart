import 'package:employee_manager/constants/app_colors.dart';
import 'package:employee_manager/hive_helper.dart';
import 'package:employee_manager/models/employee.dart';
import 'package:employee_manager/screens/home/bloc/home_bloc.dart';
import 'package:employee_manager/screens/home/bloc/home_state.dart';
import 'package:employee_manager/screens/home/home_screen.dart';
import 'package:employee_manager/widgets/app_text_field.dart';
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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryColor,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: AppTextField.border,
            enabledBorder: AppTextField.border,
            focusedBorder: AppTextField.border,
            prefixIconColor: AppColors.primaryColor,
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
