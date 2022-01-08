part of 'sliders_bloc.dart';

@immutable
abstract class SlidersState {}

class SlidersInitial extends SlidersState {}

class GettingSliders extends SlidersState {}

class GettingSlidersDone extends SlidersState {
  final List<Slider> sliders;
  GettingSlidersDone(this.sliders);
}

class GettingSlidersFailed extends SlidersState {
  final String message;
  GettingSlidersFailed(this.message);
}
