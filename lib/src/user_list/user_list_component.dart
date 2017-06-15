import 'dart:async';
import 'dart:html';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:grid/grid.dart';
import 'package:auth/auth_service.dart';
import 'package:angular_utils/cm_format_role_pipe.dart';
import '../users_service/users_service.dart';
import '../simple_user_model.dart';

@Component(
    selector: 'user-list',
    templateUrl: 'user_list_component.html',
    directives: const [
      RouterLink,
      GridComponent,
      GridTemplateDirective,
      ColumnComponent
    ],
    pipes: const [
      CmFormatRolePipe
    ])
class UserListComponent implements AfterViewInit {
  final Router _router;
  final UsersService _usersService;

  final AuthorizationService _authorizationService;
  static const DisplayName = const {'displayName': 'Список пользователей'};

  bool readOnly = true;

  DataSource usersDataSource;

  UserListComponent(
      this._router, this._authorizationService, this._usersService);

  // создать пользователя
  createUser() {
    _router.navigate(['UserCreate']);
  }

  // удалить пользователя
  deleteUser(String id) async {
    if (!window.confirm('Удалить пользователя?')) return;

    await _usersService.deleteUser(id);

    usersDataSource.data.removeWhere((item) => item['id'] == id);
  }

  @override
  ngAfterViewInit() async {
    List<Map> users = new List<Map>();

    List<SimpleUserModel> userList = await _usersService.getUsers();

    for (SimpleUserModel user in userList) {
      users.add(user.toMap());
    }

    usersDataSource = new DataSource(data: users)..primaryField = 'id';

    return;
  }
}
