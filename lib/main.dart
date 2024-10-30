import 'package:flutter/material.dart';
import 'package:todo_app/repository/local_repo.dart';
import 'package:todo_app/ui/home/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/ui/home/home_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<TodoBloc>(
          create: (context) => TodoBloc()..add(OnGetTodos()), child: Home()),
    );
  }
}
