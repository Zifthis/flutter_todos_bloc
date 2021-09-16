import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_todos/blocs/todos/todos.dart';
import 'package:flutter_todos/models/models.dart';
import 'package:todos_repository_simple/todos_repository_simple.dart';


class TodosBloc extends Bloc<TodosEvent, TodosState> {
  /// TodosBloc will have a dependency  on the TodosRepository so that it can
  /// load and save todos.
  /// It will have an initial state of TodosLoadingInProgress and defines the
  /// private handlers for each of the events. Whenever the TodosBloc change
  /// the list of todos it calls the saveTodos method in the TodosRepository
  /// in order to keep everything persisted locally.
  final TodosRepositoryFlutter todosRepository;

  TodosBloc({@required this.todosRepository}) : super(TodosLoadInProgress());

  ///When we yield a state in the private mapEventToState handlers,
  ///we're always yielding a new state instead of mutating the state.
  ///This is because every time we yield, bloc will compare the state to
  ///the nextState and will only trigger a state change(transition) if the
  ///two states are not equal. if we just mutate and yield the same instance of
  ///state, then state == nextState would evaluated to true and no state change
  ///would occur.

  @override
  Stream<TodosState> mapEventToState(
    TodosEvent event,
  ) async* {
    if (event is TodosLoaded) {
      yield* _mapTodosLoadedToState();
    } else if (event is TodoAdded) {
      yield* _mapTodoAddedToState(event);
    } else if (event is TodoUpdated) {
      yield* _mapTodoUpdatedToState(event);
    } else if (event is TodoDeleted) {
      yield* _mapTodoDeletedToState(event);
    } else if (event is ToggleAll) {
      yield* _mapToggleAllToState();
    } else if (event is ClearCompleted) {
      yield* _mapClearCompletedToState();
    }
  }

  Stream<TodosState> _mapTodosLoadedToState() async* {
    try {
      final todos = await this.todosRepository.loadTodos();
      yield TodosLoadSuccess(
        todos.map(Todo.fromEntity).toList(),
      );
    } catch (_) {
      yield TodosLoadFailure();
    }
  }

  Stream<TodosState> _mapTodoAddedToState(TodoAdded event) async* {
    if (state is TodosLoadSuccess) {
      final List<Todo> updateTodos =
          List.from((state as TodosLoadSuccess).todos)..add(event.todo);
      yield TodosLoadSuccess(updateTodos);
      _saveTodos(updateTodos);
    }
  }

  Stream<TodosState> _mapTodoUpdatedToState(TodoUpdated event) async* {
    if (state is TodosLoadSuccess) {
      final List<Todo> updatedTodos =
          (state as TodosLoadSuccess).todos.map((todo) {
        return todo.id == event.todo.id ? event.todo : todo;
      }).toList();
      yield TodosLoadSuccess(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Stream<TodosState> _mapToggleAllToState() async* {
    if (state is TodosLoadSuccess) {
      final allComplete =
          (state as TodosLoadSuccess).todos.every((todo) => todo.complete);
      final List<Todo> updatedTodos = (state as TodosLoadSuccess)
          .todos
          .map((todo) => todo.copyWith(complete: !allComplete))
          .toList();
      yield TodosLoadSuccess(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Stream<TodosState> _mapClearCompletedToState() async* {
    if (state is TodosLoadSuccess) {
      final List<Todo> updatedTodos = (state as TodosLoadSuccess)
          .todos
          .where((todo) => !todo.complete)
          .toList();
      yield TodosLoadSuccess(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Stream<TodosState> _mapTodoDeletedToState(TodoDeleted event) async* {
    if (state is TodosLoadSuccess) {
      final updatedTodos = (state as TodosLoadSuccess)
          .todos
          .where((todo) => todo.id != event.todo.id)
          .toList();
      yield TodosLoadSuccess(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Future _saveTodos(List<Todo> todos) {
    return todosRepository.saveTodos(
      todos.map((todo) => todo.toEntity()).toList(),
    );
  }
}
