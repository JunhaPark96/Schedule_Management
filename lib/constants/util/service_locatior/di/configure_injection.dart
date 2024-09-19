import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:oneline2/constants/util/service_locatior/di/configure_injection.config.dart';
import 'package:oneline2/admin_list/feature/page8_Calendar/repos/calendar_repos.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureInjection() async {
  getIt.registerLazySingleton<CalendarRepository>(() => CalendarRepository());
  getIt.init(environment: Environment.prod);
}
