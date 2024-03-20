import 'package:get_it/get_it.dart';
import 'package:internet_checker/src/presentation/bloc/connectivity_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(
    () => ConnectivityBloc(),
  );
}
