import 'package:logging/logging.dart';

class ScopeHelloService {
  final Logger _logger;

  const ScopeHelloService({required Logger logger}) : _logger = logger;

  String greeting(String name) {
    final message = "Greetings, $name. From $ScopeHelloService";
    _logger.info(message);
    return message;
  }
}
