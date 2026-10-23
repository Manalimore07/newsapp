import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/news/presentation/cubit/news_cubit.dart';
import 'features/news/presentation/cubit/theme_cubit.dart';
import 'features/news/presentation/screens/home_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies and local Hive boxes
  await di.initDependencies();

  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => di.sl<ThemeCubit>(),
        ),
        BlocProvider<NewsCubit>(
          create: (_) => di.sl<NewsCubit>()..fetchNews(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: AppConstants.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
