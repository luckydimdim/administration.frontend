import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_wrapper/http_wrapper.dart';
import 'package:angular2/core.dart';

import 'package:config/config_service.dart';
import 'package:logger/logger_service.dart';

import '../user_model.dart';

/**
 * Работа с web-сервисом. Раздел "Пользователи"
 */
@Injectable()
class UsersService {
  final ConfigService _config;
  LoggerService _logger;
  final HttpWrapper _http;

  UsersService(this._http, this._config) {
    _logger = new LoggerService(_config);
  }

  /**
   * Получение списка пользователей
   */
  Future<List<UserModel>> getUsers() async {
    _logger
        .trace('Requesting users. Url: ${ _config.helper.usersUrl }');

    Response response = null;

    try {
      response = await _http.get(_config.helper.usersUrl,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to get users: $e');

      rethrow;
    }

    _logger.trace('users requested: $response.');

    var result = new List<UserModel>();

    var list = JSON.decode(response.body);

    for (var json in list) {
      result.add(new UserModel().fromJson(json));
    }

    return result;
  }


}
