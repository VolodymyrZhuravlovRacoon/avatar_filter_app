import 'package:avatar_filter_app/domain/repositories/avatar_repository_impl.dart';
import 'package:avatar_filter_app/domain/usecases/get_avatars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/datasources/mock_avatar_datasource.dart';
import 'presentation/providers/avatar_provider.dart';
import 'presentation/screens/avatar_list_screen.dart';

void main() {
  // --- Dependency Injection ---
  final MockAvatarDataSource dataSource = MockAvatarDataSource();
  final AvatarRepositoryImpl repository = AvatarRepositoryImpl(dataSource);
  final GetAvatars getAvatarsUseCase = GetAvatars(repository);
  runApp(MyApp(getAvatarsUseCase: getAvatarsUseCase));
}

class MyApp extends StatelessWidget {
  final GetAvatars getAvatarsUseCase;

  const MyApp({super.key, required this.getAvatarsUseCase});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AvatarProvider(getAvatarsUseCase),
      child: MaterialApp(
        title: 'Avatar Filter App',
        theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'ItalianPlate',
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              fontFamily: 'ItalianPlate',
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        home: const AvatarListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
