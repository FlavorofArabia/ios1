part of 'currencies_bloc.dart';

@immutable
abstract class CurrencyState {}

class CurrencyInitial extends CurrencyState {}

class CurrencyUpdating extends CurrencyState {}

class CurrencyUpdated extends CurrencyState {
  final currency;
  CurrencyUpdated(this.currency);
}
