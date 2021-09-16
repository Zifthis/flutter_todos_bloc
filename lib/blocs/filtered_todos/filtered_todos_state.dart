
import 'package:equatable/equatable.dart';
import 'package:flutter_todos/models/models.dart';

abstract class FilteredTodosState extends Equatable {

  const FilteredTodosState();

  @override
  List<Object> get props => [];

}

///We only have two states:
///1. FilteredTodosLoadInProgress - the state while we are fetching todos
///2. FilteredTodosLoadSuccess  - the state when we're no longer fetching todos
class FilteredTodosLoadInProgress extends FilteredTodosState {}

///NOTE: FilteredTodosLoadSuccess state contains the list of filtered todos
///as well as the active visibility filter.
class FilteredTodosLoadSuccess extends FilteredTodosState {
  final List<Todo> filteredTodos;
  final VisibilityFilter activeFilter;

  FilteredTodosLoadSuccess(this.filteredTodos, this.activeFilter);

  @override
  List<Object> get props => [filteredTodos, activeFilter];

  @override
  String toString() {
    // TODO: implement toString
    return 'FilteredTodosLoadSuccess { filteredTodos: $filteredTodos, activeFilter: $activeFilter }';
  }
}