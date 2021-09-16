import 'package:equatable/equatable.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object> get props => [];
}

///StatsBloc will have two states:
///1. StatsLoadInProgress - the state when the statistics
/// have not yet been calculated.
///2. StatsLoadSuccess - the state when the statistics have been calculated.

class StatsLoadInProgress extends StatsState {}

class StatsLoadSuccess extends StatsState {
  final int numActive;
  final int numCompleted;

  const StatsLoadSuccess(this.numActive, this.numCompleted);

  @override
  List<Object> get props => [numActive, numCompleted];

  @override
  String toString() {
    return 'StatsLoadSuccess { numActive: $numActive, numCompleted: $numCompleted }';
  }
}
