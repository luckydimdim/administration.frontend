import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'user_list/user_list_component.dart';
import './users_service/users_service.dart';

@Component(
    selector: 'administration',
    templateUrl: 'administration_component.html',
    directives: const [RouterLink, RouterOutlet],
    providers: const [RouteParams, UsersService]
)
@RouteConfig(const [
  const Route(
      path: '',
      component: UserListComponent,
      name: 'UserList',
      useAsDefault: true,
      data: UserListComponent.DisplayName),
])
class AdministrationComponent {
  static const DisplayName = const {'displayName': 'Настройка системы'};
}
