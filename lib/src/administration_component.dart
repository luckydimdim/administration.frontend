import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

@Component(
    selector: 'administration',
    templateUrl: 'administration_component.html',
    directives: const [RouterLink, RouterOutlet]
class AdministrationComponent {
  static const DisplayName = const {'displayName': 'Настройка системы'};
}
