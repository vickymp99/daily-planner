import 'package:daily_planner/core/constant/app_theme.dart';
import 'package:daily_planner/core/utils/data_repository.dart';
import 'package:daily_planner/core/utils/hive_service.dart';
import 'package:daily_planner/features/cubit/Signin_cubit.dart';
import 'package:daily_planner/features/cubit/home_cubit.dart';
import 'package:daily_planner/features/cubit/login_cubit.dart';
import 'package:daily_planner/features/cubit/newday_plan_cubit.dart';
import 'package:daily_planner/features/cubit/statistics_cubit.dart';
import 'package:daily_planner/features/data/model/plan_model.dart';
import 'package:daily_planner/features/pages/home.dart';
import 'package:daily_planner/features/pages/login.dart';
import 'package:daily_planner/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/utils/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseService.initFirebaseMessage();
  await Hive.initFlutter();
  Hive.registerAdapter(PlanModelAdapter());
  Hive.registerAdapter(PlanListModelAdapter());
  await HiveService.init();
  if (FirebaseAuth.instance.currentUser != null) {
    final dataRepository = DataRepository(FirebaseService());
    dataRepository.listenChanges();
    dataRepository.initLoad();
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => SignInCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => NewDayPlanCubit()),
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => StatisticsCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, theme) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: theme,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return FirebaseAuth.instance.currentUser == null
                  ? Login()
                  : Home();
            },
          ),
        );
      },
    );
  }
}
