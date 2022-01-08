part of 'currencies_bloc.dart';

@immutable
abstract class CurrencyEvent {}

class GetCurrency extends CurrencyEvent {}

class LoadCurrencies extends CurrencyEvent {}

class ChangeCurrency extends CurrencyEvent {
  final currency;

  ChangeCurrency(this.currency);
}
