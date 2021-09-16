import 'package:equatable/equatable.dart';
import 'package:flutter_todos/models/models.dart';

abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

///3 state will be implemented:

///1.TodosLoadInProgress - the state while our application is fetching
///todos from the repository.

///2.TodosLoadSuccess - the state of our application after the
///todos have successfully been loaded.

///3.TodosLoadFailure - the state of our application if the
///todos were not successfully loaded.

class TodosLoadInProgress extends TodosState {}

class TodosLoadSuccess extends TodosState {
  final List<Todo> todos;

  const TodosLoadSuccess([this.todos = const []]);

  @override
  List<Object> get props => [todos];

  @override
  String toString() {
    return 'TodosLoadSuccess { todos: $todos }';
  }
}

class TodosLoadFailure extends TodosState {}
