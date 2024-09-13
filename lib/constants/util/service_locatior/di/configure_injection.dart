import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:oneline2/constants/util/service_locatior/di/configure_injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureInjection() async {
  getIt.init(environment: Environment.prod);
}
