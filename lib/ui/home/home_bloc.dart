import 'package:todo_app/model/todo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/local_repo.dart';

//events

abstract class TodoEvent {}

class ShowAddTodoDialog extends TodoEvent {}

class OnAddTodo extends TodoEvent {
  Todo todo;
  OnAddTodo(this.todo);
}

class OnDeleteTodo extends TodoEvent {
  final int index;
  OnDeleteTodo(this.index);
}

class OnUpdateTodo extends TodoEvent {
  int index;
  Todo todo;
  OnUpdateTodo(this.index, this.todo);
}

class OnGetTodos extends TodoEvent {}

class LoadTodos extends TodoEvent {}

class OnTogglePress extends TodoEvent {
  Todo updatedTodo;
  OnTogglePress(this.updatedTodo);
}

//states

abstract class TodoStates {}

class OnLoading extends TodoStates {}

class ShowDialogState extends TodoStates {}

class HideDialogState extends TodoStates {}

class TodoListState extends TodoStates {
  List<Todo> todoList = [];
  final bool showDialog;
  TodoListState(this.todoList, {this.showDialog = false});
}

//bloc

class TodoBloc extends Bloc<TodoEvent, TodoStates> {
  List<Todo> _todoList = [];
  TodoBloc() : super(TodoListState([])) {
    on<OnAddTodo>(
      (event, emit) async {
        int id = await DatabaseHelper.instance.insertDb(event.todo.toMap());
        final todoWithId = event.todo.copyWith(id: id);
        _todoList.add(todoWithId);
        emit(HideDialogState());
        emit(TodoListState(List.from(_todoList)));
      },
    );
    on<OnGetTodos>((event, emit) async {
      emit(OnLoading());
      _todoList = await DatabaseHelper.instance.readDb();
      emit(TodoListState(_todoList));
    });
    on<OnUpdateTodo>((event, emit) async {
      _todoList[event.index] = event.todo;
      await DatabaseHelper.instance.updateDb(event.todo);
      emit(TodoListState(List.from(_todoList)));
    });
    on<OnTogglePress>((event, emit) async {
      final updatedTodo = _todoList[event.updatedTodo.id!].copyWith(
        is_done: event.updatedTodo.is_done,
      );
      _todoList[event.updatedTodo.id!] = updatedTodo;
      await DatabaseHelper.instance.updateDb(updatedTodo);
      emit(TodoListState(List.from(_todoList)));
    });
    on<OnDeleteTodo>(
      (event, emit) async {},
    );
    on<ShowAddTodoDialog>(
      (event, emit) async {
        if (state is TodoListState) {
          final todos = (state as TodoListState).todoList;
          emit(TodoListState(todos, showDialog: true));
        }
        // await DatabaseHelper.instance.checkSchema();
      },
    );
  }
  Future<List<Todo>> updatedData() async {
    final todosData = await DatabaseHelper.instance.readDb();
    return todosData;
    // return todos;todosData.map((e) => Todo.fromMap(e)).toList();
  }
}
