import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_todos/blocs/blocs.dart';

///StatsBloc will have a dependency on the TodosBloc itself which will
///allow it to update its state in response to state changes in the TodosBloc.
class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final TodosBloc todosBloc;
  StreamSubscription todosSubscription;

  StatsBloc({@required this.todosBloc}) : super(StatsLoadInProgress()) {
    void onTodosStateChanged(state) {
      if (state is TodosLoadSuccess) {
        add(StatsUpdated(state.todos));
      }
    }

    onTodosStateChanged(todosBloc.state);
    todosSubscription = todosBloc.stream.listen(onTodosStateChanged);
  }

  @override
  Stream<StatsState> mapEventToState(
    StatsEvent event,
  ) async* {
    if (event is StatsUpdated) {
      final numActive =
          event.todos.where((todo) => !todo.complete).toList().length;
      final numCompleted =
          event.todos.where((todo) => todo.complete).toList().length;
      yield StatsLoadSuccess(numActive, numCompleted);
    }
  }

  @override
  Future<Function> close() {
    todosSubscription.cancel();
    return super.close();
  }

  ///That's all there is to it, StatsBloc recalculates its state which contains
  ///the number of active todos and the number of completed todos on each
  ///state change of our TodosBloc.

}
