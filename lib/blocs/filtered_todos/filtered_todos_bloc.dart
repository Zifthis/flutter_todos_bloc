import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_todos/blocs/filtered_todos/filtered_todos.dart';
import 'package:flutter_todos/blocs/todos/todos.dart';
import 'package:flutter_todos/models/models.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final TodosBloc todosBloc;

  ///We create a StreamSubscription  for the stream of TodosStates so
  ///that we can listen to the state changes in the TodosBloc.
  ///We override the bloc's close method and cancel the subscription
  ///so that we can clean up after the bloc is closed.
  StreamSubscription todosSubscription;

  ///ur FilteredTodosBloc will be similar to our TodosBloc;
  ///however, instead of having a dependency on the TodosRepository,
  ///it will have a dependency on the TodosBloc itself.
  ///This will allow the FilteredTodosBloc to update its state
  ///in response to state changes in the TodosBloc.
  FilteredTodosBloc({@required this.todosBloc})
      : super(
    todosBloc.state is TodosLoadSuccess
        ? FilteredTodosLoadSuccess(
      (todosBloc.state as TodosLoadSuccess).todos,
      VisibilityFilter.all,
    )
        : FilteredTodosLoadInProgress(),
  ) {
    todosSubscription = todosBloc.stream.listen((state) {
      if (state is TodosLoadSuccess) {
        add(TodosUpdated((todosBloc.state as TodosLoadSuccess).todos));
      }
    });
  }

  @override
  Stream<FilteredTodosState> mapEventToState(
    FilteredTodosEvent event,
  ) async* {
    if (event is FilterUpdated) {
      yield* _mapFilterUpdatedToState(event);
    } else if (event is TodosUpdated) {
      yield* _mapTodosUpdatedToState(event);
    }
  }

  Stream<FilteredTodosState> _mapFilterUpdatedToState(
      FilterUpdated event,
      ) async* {
    if (todosBloc.state is TodosLoadSuccess) {
      yield FilteredTodosLoadSuccess(
        _mapTodosToFilteredTodos(
          (todosBloc.state as TodosLoadSuccess).todos,
          event.filter,
        ),
        event.filter,
      );
    }
  }

  Stream<FilteredTodosState> _mapTodosUpdatedToState(
      TodosUpdated event,
      ) async* {
    final visibilityFilter = state is FilteredTodosLoadSuccess
        ? (state as FilteredTodosLoadSuccess).activeFilter
        : VisibilityFilter.all;
    yield FilteredTodosLoadSuccess(
      _mapTodosToFilteredTodos(
        (todosBloc.state as TodosLoadSuccess).todos,
        visibilityFilter,
      ),
      visibilityFilter,
    );
  }

  List<Todo> _mapTodosToFilteredTodos(
      List<Todo> todos, VisibilityFilter filter) {
    return todos.where((todo) {
      if (filter == VisibilityFilter.all) {
        return true;
      } else if (filter == VisibilityFilter.active) {
        return !todo.complete;
      } else {
        return todo.complete;
      }
    }).toList();
  }

  @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }
}


