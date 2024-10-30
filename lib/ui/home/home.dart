import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/ui/home/home_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final todoBloc = BlocProvider.of<TodoBloc>(context)..add(OnGetTodos());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
      ),
      body: BlocConsumer(
        listener: (context, state) {
          if (state is TodoListState && state.showDialog) {
            _showAddTodoDialog(context, todoBloc);
          }
          if (state is HideDialogState) {
            Navigator.of(context).pop();
          }
        },
        bloc: todoBloc,
        builder: (context, state) {
          if (state is TodoListState) {
            return ListView.builder(
              itemCount: state.todoList.length,
              itemBuilder: (context, index) {
                final todo = state.todoList[index];
                return ListTile(
                    title: Text(todo.title ?? ''),
                    subtitle: Text(todo.description ?? ''),
                    trailing: Checkbox(
                      value: todo.is_done,
                      onChanged: (value) {
                        todoBloc.add(OnTogglePress(Todo(
                            id: todo.id,
                            description: todo.description,
                            title: todo.title,
                            is_done: value!)));
                      },
                    ),
                    onLongPress: () => BlocProvider.of<TodoBloc>(context)
                        .add(OnDeleteTodo(index)));
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          todoBloc.add(ShowAddTodoDialog());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void _showAddTodoDialog(BuildContext context, TodoBloc todoBloc) {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add New Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final description = descriptionController.text.trim();

              if (title.isNotEmpty) {}
              final newTodo = Todo(
                title: title,
                description: description,
              );
              todoBloc.add(OnAddTodo(newTodo));
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}
