library;

import 'package:logging/logging.dart';
import 'package:service_container/service_container.dart';

import 'services.dart';

export 'scope_hello_service.dart';
export 'singleton_hello_service.dart';
export 'transient_hello_service.dart';

ServiceDescriptor<Logger> $exampleLogger = ServiceDescriptor.singleton((p) => Logger("Example"));

ServiceDescriptor<SingletonHelloService> $singletonHelloService =
    ServiceDescriptor.singleton((p) => SingletonHelloService(logger: p.getService($exampleLogger)));
ServiceDescriptor<ScopeHelloService> $scopeHelloService =
    ServiceDescriptor.scoped((p) => ScopeHelloService(logger: p.getService($exampleLogger)));
ServiceDescriptor<TransientHelloService> $transientHelloService =
    ServiceDescriptor.transient((p) => TransientHelloService(logger: p.getService($exampleLogger)));
