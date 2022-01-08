import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../api/restful_api/sliders_api.dart';
import '../../models/slider.dart';

part 'sliders_event.dart';
part 'sliders_state.dart';

class SlidersBloc extends Bloc<SlidersEvent, SlidersState> {
  SlidersBloc() : super(SlidersInitial());

  @override
  Stream<SlidersState> mapEventToState(
    SlidersEvent event,
  ) async* {
    if (event is GetSliders) {
      try {
        yield GettingSliders();
        final List<Slider> sliders = [];
        final res = await SlidersApi.getAll();
        if (res['data'] != null) {
          for (var i = 0; i < res['data'].length; i++) {
            sliders.add(Slider.fromMap(res['data'][i]));
          }

          yield GettingSlidersDone(sliders);
        } else {
          yield GettingSlidersFailed(res['message']);
        }
      } catch (err) {
        yield SlidersInitial();
      }
    }
  }
}
