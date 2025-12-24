import 'package:logger/logger.dart';

class LoggerUtils {
  LoggerUtils._();

  static late Logger logger;

  static void init() {
    logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: Level.debug,
    );
  }
}