import 'dart:async';
import 'dart:html';
import 'package:angular2/angular2.dart';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular_utils/directives.dart';

import '../users_service/users_service.dart';
import '../detailed_user_model.dart';
import 'package:auth/auth_service.dart';

@Component(selector: 'user', templateUrl: 'user_component.html',   directives: const [
  CmRouterLink
])
class UserComponent implements OnInit {
  static const DisplayName = const {'displayName': 'Пользователь'};

  final UsersService _userService;
  final AuthenticationService _authService;
  final Router _router;

  bool creatingMode = false;

  List<dynamic> availableRoles = null;

  DetailedUserModel model = null;

  String actMail = '';
  bool showActControls = false;

  UserComponent(this._userService, this._router, this._authService);

  String userId = '';

  @override
  ngOnInit() async {
    Instruction ci = _router.parent.currentInstruction;
    userId = ci.component.params['id'];

    await _loadData();

  }

  _loadData() async {
    model = await _userService.getUser(userId);

    availableRoles = [
      {'name':'Подрядчик', 'value':'Contractor', 'checked':model.roles.contains('CONTRACTOR')},
      {'name':'Заказчик', 'value':'Customer', 'checked':model.roles.contains('CUSTOMER')},
      {'name':'Администратор', 'value':'Administrator', 'checked':model.roles.contains('ADMINISTRATOR')}
    ];

    showActControls = false;

  }

  Map<String, bool> controlStateClasses(NgControl control) => {
    'ng-dirty': control.dirty ?? false,
    'ng-pristine': control.pristine ?? false,
    'ng-touched': control.touched ?? false,
    'ng-untouched': control.untouched ?? false,
    'ng-valid': control.valid ?? false,
    'ng-invalid': control.valid == false
  };

  sendActivationLink() async {
   if ( await _authService.sendActivationLink(model.login, actMail)) {
     window.alert('Ссылка на активацию успешно отправлена');
   }
   else {
     window.alert('При отправке ссылки произошла ошибка');
   }

   await _loadData();
  }

}