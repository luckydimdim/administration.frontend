import 'dart:async';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:auth/auth_service.dart';
import '../users_service/users_service.dart';
import '../simple_user_model.dart';

@Component(
    selector: 'user-list',
    templateUrl: 'user_list_component.html',
    directives: const [RouterLink])
class UserListComponent implements AfterViewInit {
  final Router _router;
  final UsersService _usersService;

  final AuthorizationService _authorizationService;
  static const DisplayName = const {'displayName': 'Список пользователей'};

  bool readOnly = true;

  List<Map> users = new List<Map>();

  UserListComponent(this._router, this._authorizationService, this._usersService);

  createUser() {
    _router.navigate(['UserCreate']);
  }

  @override
  ngAfterViewInit() async {
    List<SimpleUserModel> userList = await _usersService.getUsers();

    for (SimpleUserModel user in userList) {
      users.add(user.toMap());
    }

    return;
  }

}
