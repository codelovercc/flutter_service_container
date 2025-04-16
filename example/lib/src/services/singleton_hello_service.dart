import 'package:logging/logging.dart';

class SingletonHelloService {
  final Logger _logger;

  const SingletonHelloService({required Logger logger}) : _logger = logger;

  String greeting(String name) {
    final message = "Greetings, $name. From $SingletonHelloService";
    _logger.info(message);
    return message;
  }
}
