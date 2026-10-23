import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
import 'features/news/data/datasources/news_local_data_source.dart';
import 'features/news/data/datasources/news_mock_data_source.dart';
import 'features/news/data/repositories/news_repository_impl.dart';
import 'features/news/domain/repositories/news_repository.dart';
import 'features/news/domain/usecases/get_articles_usecase.dart';
import 'features/news/domain/usecases/search_articles_usecase.dart';
import 'features/news/presentation/cubit/news_cubit.dart';
import 'features/news/presentation/cubit/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. External Services / Local Databases (Hive)
  await Hive.initFlutter();
  final newsBox = await Hive.openBox(AppConstants.newsBoxName);
  final themeBox = await Hive.openBox(AppConstants.themeBoxName);

  sl.registerLazySingleton<Box>(() => newsBox, instanceName: AppConstants.newsBoxName);
  sl.registerLazySingleton<Box>(() => themeBox, instanceName: AppConstants.themeBoxName);

  // 2. Data Sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsMockDataSourceImpl(),
  );

  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(
      newsBox: sl<Box>(instanceName: AppConstants.newsBoxName),
    ),
  );

  // 3. Repositories
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // 4. Use Cases
  sl.registerLazySingleton(() => GetArticlesUseCase(sl()));
  sl.registerLazySingleton(() => SearchArticlesUseCase(sl()));

  // 5. Cubits / State Management
  sl.registerFactory(
    () => NewsCubit(
      getArticlesUseCase: sl(),
      searchArticlesUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ThemeCubit(
      themeBox: sl<Box>(instanceName: AppConstants.themeBoxName),
    ),
  );
}
