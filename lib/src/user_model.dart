import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';
import 'package:intl/intl.dart';

@reflectable
/**
 * Модель представления договора
 */
class UserModel extends Object with JsonConverter, MapConverter {
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
