import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:async_locks/async_locks.dart';
import 'package:flutter/foundation.dart';

class LogMessage {
  final String type;
  final String message;

  const LogMessage({required this.type, required this.message});

  Map<String, String> toMap() {
    return {"type": type, "message": message};
  }

  factory LogMessage.fromMap(Map<String, String> map) {
    return LogMessage(type: map["type"] ?? "", message: map["message"] ?? "");
  }

  String _formatDateTime(DateTime dt) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${twoDigits(dt.day)}-${twoDigits(dt.month)} '
        '${twoDigits(dt.hour)}:${twoDigits(dt.minute)}:${twoDigits(dt.second)}';
  }

  @override
  String toString() {
    return "[${_formatDateTime(DateTime.now())}] [$type] $message";
  }
}

class Logger {
  static final _lock = Lock();
  static String _fileName = "";

  static void initialize(String fileName) {
    _fileName = fileName;

    final loggingPort = ReceivePort();

    loggingPort.listen((msg) => _handleLogMessage(msg));

    IsolateNameServer.registerPortWithName(loggingPort.sendPort, "mako_logging_port");

    final logFile = File("$fileName.log");
    logFile.writeAsStringSync("");
  }

  static void info(String message) {
    _sendLog("I", message);
  }

  static void warn(String message) {
    _sendLog("W", message);
  }

  static void error(String message) {
    _sendLog("E", message);
  }

  static void debug(String message) {
    if (!kDebugMode) {
      return;
    }

    _sendLog("D", message);
  }

  static void _sendLog(String type, String message) {
    final port = _getSendPort();
    final logMessage = LogMessage(type: type.toUpperCase(), message: message);

    port.send(jsonEncode(logMessage.toMap()));
  }

  static SendPort _getSendPort() {
    return IsolateNameServer.lookupPortByName("mako_logging_port")!;
  }

  static void _handleLogMessage(String? message) async {
    if (message == null) {
      return;
    }

    var messageMap = {};

    try {
      messageMap = jsonDecode(message) as Map;
    } catch (_) {
      return;
    }

    await _lock.acquire();

    try {
      final logMessage = LogMessage.fromMap(messageMap.cast<String, String>());

      if (kDebugMode) {
        print(logMessage);
      }

      final logFile = File("$_fileName.log");
      logFile.writeAsStringSync("${logMessage.toString()}\n", mode: FileMode.append);
    } finally {
      _lock.release();
    }
  }
}
