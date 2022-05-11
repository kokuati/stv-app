abstract class Errors {}

class TerminalError extends Errors {
  final int statusCode;
  TerminalError({
    required this.statusCode,
  });
}

class ContentsError extends Errors {
  final int statusCode;
  ContentsError({
    required this.statusCode,
  });
}

class TerminalEmpty extends Errors {}

class SaveError extends Errors {}

class WeatherError extends Errors {}
