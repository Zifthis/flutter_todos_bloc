import 'package:equatable/equatable.dart';
import 'package:flutter_todos/models/models.dart';

abstract class TabEvent extends Equatable {
  const TabEvent();
}

///TabUpdated - notifies the bloc that the active tab has updated
class TabUpdated extends TabEvent {
  final AppTab tab;

  const TabUpdated(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() {
    // TODO: implement toString
    return 'TabUpdated { tab: $tab }';
  }
}
