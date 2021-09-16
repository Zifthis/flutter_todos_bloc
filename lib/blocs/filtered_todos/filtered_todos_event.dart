import 'package:equatable/equatable.dart';
import 'package:flutter_todos/models/models.dart';

abstract class FilteredTodosEvent extends Equatable {

  const FilteredTodosEvent();
}

///we're going implement two events for FilteredTodosBloc
///1. FilterUpdated - which notifies the bloc that
///the visibility filter has change

/// 2. TodosUpdated - which notifies the bloc that
/// the list of todos has changed

class FilterUpdated extends FilteredTodosEvent {
  final VisibilityFilter filter;

  const FilterUpdated(this.filter);

  @override
  List<Object> get props => [filter];

  @override
  String toString() {
    // TODO: implement toString
    return 'FilterUpdated { filter: $filter }';
  }
}

class TodosUpdated extends FilteredTodosEvent {
  final List<Todo> todos;

  const TodosUpdated(this.todos);

  @override
  List<Object> get props => [todos];

  @override
  String toString() {
    // TODO: implement toString
    return 'TodosUpdated { todos: $todos }';
  }
}