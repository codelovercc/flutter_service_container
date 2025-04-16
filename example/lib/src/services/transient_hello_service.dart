import 'package:logging/logging.dart';

class TransientHelloService {
  final Logger _logger;

  const TransientHelloService({required Logger logger}) : _logger = logger;

  String greeting(String name) {
    final message = "Greetings, $name. From $TransientHelloService";
    _logger.info(message);
    return message;
  }
}
