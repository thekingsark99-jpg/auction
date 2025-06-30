import 'dart:async';

enum CustomMessages {
  scrollHomeToTop,
  incrementUnreadNotifications,
  settingsInitialized
}

class EventManager {
  static final EventManager _instance = EventManager._internal();

  factory EventManager() {
    return _instance;
  }

  EventManager._internal();

  final StreamController<CustomBiddoEvent> _eventController =
      StreamController<CustomBiddoEvent>.broadcast();

  Stream<CustomBiddoEvent> get eventStream => _eventController.stream;

  void sendEvent(CustomBiddoEvent event) {
    _eventController.sink.add(event);
  }

  void dispose() {
    _eventController.close();
  }
}

class CustomBiddoEvent {
  final CustomMessages type;
  final dynamic message;

  CustomBiddoEvent(
    this.type,
    this.message,
  );
}
