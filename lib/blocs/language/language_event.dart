part of 'language_bloc.dart';

@immutable
abstract class LanguageEvent {}

class GetLanguage extends LanguageEvent {}
class LoadLanguages extends LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final Locale locale;

  ChangeLanguage(this.locale);
}
