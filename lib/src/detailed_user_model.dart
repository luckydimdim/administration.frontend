import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';
import 'package:intl/intl.dart';

import 'package:auth/auth_service.dart';

@reflectable
/**
 * Модель представления пользователя
 */
class DetailedUserModel extends Object with JsonConverter, MapConverter {
  // Внутренний идентификатор
  String id = '';

  // Логин
  String login = '';

  // Наименование
  String name = '';

  // Активирован
  bool isActivated = false;

  // Активирован
  bool isActivating = false;

  // роли
  List<String> roles = new List<String>();  // FIXME: заменить на enum, парсить

}
