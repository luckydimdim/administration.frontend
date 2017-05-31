import 'dart:async';
import 'dart:html';
import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular_utils/directives.dart';

import '../users_service/users_service.dart';
import '../detailed_user_model.dart';
import 'package:auth/auth_service.dart';
import 'package:master_layout/breadcrumb_service.dart';

@Component(
    selector: 'user',
    templateUrl: 'user_component.html',
    directives: const [CmRouterLink])
class UserComponent implements OnInit {
  static const DisplayName = 'Пользователь';

  final UsersService _userService;
  final AuthenticationService _authService;
  final Router _router;
  final BreadcrumbService _breadcrumbService;

  bool creatingMode = false;

  List<dynamic> availableRoles = null;

  DetailedUserModel model = null;

  String actMail = '';
  bool showActControls = true;

  UserComponent(this._userService, this._router, this._authService,
      this._breadcrumbService, RouteData routeData) {

    if (routeData.get('creatingMode') == true)
      creatingMode = true;
    else
      creatingMode = false;

  }

  String userId = '';

  @override
  ngOnInit() async {
    Instruction ci = _router.parent.currentInstruction;
    userId = ci.component.params['id'];

    if (userId == null) {
      model = new DetailedUserModel();
      _breadcrumbService.changeDisplayName(
          this.runtimeType, 'Создание пользователя');
    } else {
      await _loadData();
      _breadcrumbService.changeDisplayName(
          this.runtimeType, 'Пользователь ${model.login}');
    }

    createaAailableRoles(model.roles);
  }

  // загрузка данных о пользователе
  _loadData() async {
    model = await _userService.getUser(userId);
    if (model.isActivating) showActControls = false;
  }

  // создать список ролей и заполнить их из модели
  createaAailableRoles(List<String> roles) {
    availableRoles = [
      {
        'name': 'Подрядчик',
        'value': 'Contractor',
        'checked': roles.contains('CONTRACTOR')
      },
      {
        'name': 'Заказчик',
        'value': 'Customer',
        'checked': roles.contains('CUSTOMER')
      },
      {
        'name': 'Администратор',
        'value': 'Administrator',
        'checked': roles.contains('ADMINISTRATOR')
      }
    ];
  }

  Map<String, bool> controlStateClasses(NgControl control) => {
        'ng-dirty': control.dirty ?? false,
        'ng-pristine': control.pristine ?? false,
        'ng-touched': control.touched ?? false,
        'ng-untouched': control.untouched ?? false,
        'ng-valid': control.valid ?? false,
        'ng-invalid': control.valid == false
      };

  // отправить ссылку для активации
  sendActivationLink() async {
    if (await _authService.sendActivationLink(model.login, actMail)) {
      window.alert('Ссылка на активацию успешно отправлена');
    } else {
      window.alert('При отправке ссылки произошла ошибка');
    }

    await _loadData();
  }

  // сохранить/создать
  save() async {
    model.roles = availableRoles
        .where((e) => e['checked'] == true)
        .map((f) => f['value'].toString())
        .toList();

    if (creatingMode) {
      var exist = await _userService.checkUserExisting(model.login);

      if (exist) {
        window.alert('Пользователь с данным логином уже существует');
        return;
      }

      userId = await _userService.createUser(model);

      _router.navigate([
        'User',
        {'id': userId}
      ]);
    } else {
      await _userService.updateUser(model);

      _router.navigate(['../UserList']);
    }
  }

  // удалить пользователя
  deleteUser() async {
    if (!window.confirm('Удалить пользователя?')) return;

    await _userService.deleteUser(userId);

    _router.navigate(['../UserList']);
  }
}
