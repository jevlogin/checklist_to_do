
import 'package:auto_route/auto_route.dart';
import 'package:checklist_to_do/app_view.dart';
import 'package:checklist_to_do/screens/auth/welcome_screen.dart';
import 'package:checklist_to_do/screens/home/home_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: MyAppViewRoute.page, initial: true),
    AutoRoute(page: WelcomeRoute.page,),
    AutoRoute(page: HomeRoute.page),
  ];
}