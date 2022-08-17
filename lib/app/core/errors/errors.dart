abstract class Errors {}

class HttpError extends Errors {
  final int statusCode;
  HttpError({
    required this.statusCode,
  });
}

class UserError extends Errors {
  final String message;
  UserError({
    required this.message,
  });
}

class TerminalError extends Errors {
  final String message;
  TerminalError({
    required this.message,
  });
}

class ContentError extends Errors {
  final String message;
  ContentError({
    required this.message,
  });
}

class Empty extends Errors {
  String message;
  Empty({
    this.message = '',
  });
}

class SaveError extends Errors {}

class WeatherError extends Errors {}
