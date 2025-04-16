import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:service_container/service_container.dart';

/// use [DeveloperLogPrinter] for service container logging.
void useDeveloperLogPrinter() {
  $logPrinter = ServiceDescriptor.singleton((p) => DeveloperLogPrinter());
}

class DeveloperLogPrinter implements LogPrinter {
  @override
  void printLog(LogRecord record) {
    // use `dumpErrorToConsole` for severe messages to ensure that severe
    // exceptions are formatted consistently with other Flutter examples and
    // avoids printing duplicate exceptions
    if (record.level >= Level.SEVERE) {
      final Object? error = record.error;
      FlutterError.dumpErrorToConsole(
        FlutterErrorDetails(
          exception: error is Exception ? error : Exception(error),
          stack: record.stackTrace,
          library: record.loggerName,
          context: ErrorDescription(record.message),
        ),
      );
    } else {
      developer.log(
        record.message,
        time: record.time,
        sequenceNumber: record.sequenceNumber,
        level: record.level.value,
        name: record.loggerName,
        zone: record.zone,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    }
  }
}
