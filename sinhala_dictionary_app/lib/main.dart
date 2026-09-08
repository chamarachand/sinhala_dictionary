import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/core/constants/string_constants.dart';
import 'package:sinhala_dictionary_app/core/di/injection.dart';
import 'package:sinhala_dictionary_app/core/theme/app_theme.dart';
import 'package:sinhala_dictionary_app/features/auth/repository/auth_repository.dart';
import 'package:sinhala_dictionary_app/features/theme/cubit/theme_cubit.dart';
import 'package:sinhala_dictionary_app/core/widgets/main_navigation_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();

  await getIt<AuthRepository>().initializeAnonymousUser();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => getIt<ThemeCubit>())],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: AppStrings.appTitleEnglish,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const MainNavigationWrapper(),
          );
        },
      ),
    );
  }
}
