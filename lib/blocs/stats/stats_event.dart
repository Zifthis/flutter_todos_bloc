import 'package:equatable/equatable.dart';
import 'package:flutter_todos/models/models.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();
}

///there will be just a single event our StatsBloc will respond to:
///StatsUpdated - This event will be added whenever the TodosBloc stats
///changes so that our StatsBloc can recalculate the new statistics.

class StatsUpdated extends StatsEvent {
  final List<Todo> todos;

  const StatsUpdated(this.todos);

  @override
  List<Object> get props => [todos];

  @override
  String toString() {
    // TODO: implement toString
    return 'StatsUpdated { todos: $todos }';
  }
}