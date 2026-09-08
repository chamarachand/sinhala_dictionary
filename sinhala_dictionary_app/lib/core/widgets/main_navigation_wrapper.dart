import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/core/di/injection.dart';
import 'package:sinhala_dictionary_app/features/favourites/cubit/favourites_cubit.dart';
import 'package:sinhala_dictionary_app/features/favourites/screens/favourites_tab_screen.dart';
import 'package:sinhala_dictionary_app/features/history/cubit/history_cubit.dart';
import 'package:sinhala_dictionary_app/features/history/screens/history_tab_screen.dart';
import 'package:sinhala_dictionary_app/features/search/cubit/search_cubit.dart';
import 'package:sinhala_dictionary_app/features/settings/screens/settings_screen.dart';
import 'package:sinhala_dictionary_app/features/search/screens/search_screen.dart';
import 'package:sinhala_dictionary_app/custom_navigation_drawer.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  // 0 = Search, 1 = History, 2 = Favourites, 3 = Settings
  int _currentViewIndex = 0;

  void _navigateTo(int index) {
    setState(() => _currentViewIndex = index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final drawer = CustomNavigationDrawer(
      currentViewIndex: _currentViewIndex,
      onNavigate: _navigateTo,
    );

    return switch (_currentViewIndex) {
      0 => BlocProvider(
        create: (_) => getIt<SearchCubit>(),
        child: SearchScreen(drawer: drawer),
      ),
      1 => BlocProvider(
        create: (_) => getIt<HistoryCubit>(),
        child: HistoryTabScreen(drawer: drawer),
      ),
      2 => BlocProvider(
        create: (_) => getIt<FavouritesCubit>(),
        child: FavouritesTabScreen(drawer: drawer),
      ),
      3 => SettingsScreen(drawer: drawer),
      _ => BlocProvider(
        create: (_) => getIt<SearchCubit>(),
        child: SearchScreen(drawer: drawer),
      ),
    };
  }
}
