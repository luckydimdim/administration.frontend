import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';
import 'package:intl/intl.dart';

@reflectable
/**
 * Модель представления пользователя
 */
class SimpleUserModel extends Object with JsonConverter, MapConverter {
  // Внутренний идентификатор
  String id = '';

  // Логин
  String login = '';

  // Наименование
  String name = '';

  // Активирован
  bool isActivated = false;

  // роли
  List<String> roles;
}
