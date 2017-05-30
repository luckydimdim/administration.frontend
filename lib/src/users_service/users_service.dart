import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_wrapper/http_wrapper.dart';
import 'package:angular2/core.dart';

import 'package:config/config_service.dart';
import 'package:logger/logger_service.dart';

import '../simple_user_model.dart';
import '../detailed_user_model.dart';

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
  Future<List<SimpleUserModel>> getUsers() async {
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

    var result = new List<SimpleUserModel>();

    var list = JSON.decode(response.body);

    for (var json in list) {
      result.add(new SimpleUserModel().fromJson(json));
    }

    return result;
  }

  /**
   * Получение списка пользователей
   */
  Future<DetailedUserModel> getUser(String userId) async {
    _logger
        .trace('Requesting user id: $userId. Url: ${ _config.helper.usersUrl }/$userId');

    Response response = null;

    try {
      response = await _http.get(_config.helper.usersUrl + '/$userId',
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      _logger.error('Failed to get users: $e');

      rethrow;
    }

    _logger.trace('user requested: $response.');

    dynamic json = JSON.decode(response.body);

    var model = new DetailedUserModel().fromJson(json);

    return model;
  }

  /**
   * Изменение данных пользователя
   */
  Future updateUser(DetailedUserModel model) async {
    String jsonString = model.toJsonString();

    _logger.trace('Updating user $jsonString');

    try {
      await _http.put('${_config.helper.usersUrl}/${model.id}',
          headers: {'Content-Type': 'application/json'}, body: jsonString);
      _logger.trace('user successfuly updated');
    } catch (e) {
      _logger.error('Failed to update user: $e');

      rethrow;
    }
  }

  /**
   * Создание пользователя
   */
  Future<String> createUser(DetailedUserModel model) async {
    String jsonString = model.toJsonString();

    _logger.trace('Creating user $jsonString');

    Response response = null;
    try {
      response =  await _http.post('${_config.helper.usersUrl}',
          headers: {'Content-Type': 'application/json'}, body: jsonString);
      _logger.trace('user successfuly created');
    } catch (e) {
      _logger.error('Failed to create user: $e');

      rethrow;
    }

    _logger.trace('user created: $response.');

    return response.body;
  }

  /**
   * Создание пользователя
   */
  Future<bool> checkUserExisting(String login) async {

    Response response = null;
    try {
      response =  await _http.get('${_config.helper.usersUrl}'+ '/is-user-exist/$login',
          headers: {'Content-Type': 'application/json'});

      _logger.trace('user existing successfuly checked');
    } catch (e) {
      _logger.error('Failed to check user existing: $e');

      rethrow;
    }

    _logger.trace('check user existing: $response.');

    return response.body.toLowerCase() == 'true';
  }

}
