import 'package:service_container/service_container.dart';

import 'logging.dart';

extension FlutterContainerConfigure on ContainerConfigure {
  /// use [DeveloperLogPrinter] for service container logging.
  ///
  /// Notes that dart:developer is not available in tests, do not use this in tests.
  void useDeveloperLogPrinter() {
    $LogPrinter = ServiceDescriptor.singleton((p) => const DeveloperLogPrinter());
  }
}
