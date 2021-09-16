import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_todos/blocs/tab/tab.dart';
import 'package:flutter_todos/models/models.dart';

///TabBloc is setting the initial state to the todos tab and
///handling the TabUpdated event by yielding a new AppTab instance.
class TabBloc extends Bloc<TabEvent, AppTab> {
  TabBloc() : super(AppTab.todos);

  @override
  Stream<AppTab> mapEventToState(
    TabEvent event,
  ) async* {
    if (event is TabUpdated) {
      yield event.tab;
    }
  }
}
