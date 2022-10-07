import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/snack_bar/snack_bar_bloc.dart';
import '../bloc/valid_form/valid_form_bloc.dart';

import '../ui/loading/loading.dart';
import '../ui/login/login.dart';
import '../ui/sign_up/account_name_and_password/account_name_and_password.dart';
import '../ui/sign_up/info/info.dart';

import '../ui/home/home.dart';
import '../ui/nft_card_list/nft_card_list.dart';
import '../ui/nft_detail/nft_card.dart';
import '../ui/quest_list/quest_list.dart';
import '../ui/quest_detail/quest_detail.dart';

import 'routes_enum.dart';

final routes = {
  PageRoutes.loading.routeName: (context) => const LoadingPage(),
  PageRoutes.login.routeName: (context) => const LoginPage(),
  PageRoutes.signUpAccountNameAndPassword.routeName: (context) =>
      MultiBlocProvider(providers: [
        BlocProvider(create: (context) => ValidFormBloc()),
        BlocProvider(create: (context) => SnackBarBloc())
      ], child: const SignUpAccountNameAndPasswordPage()),
  PageRoutes.home.routeName: (context) => HomePage(),
  PageRoutes.nftCardList.routeName: (context) => const NftCardListPage(),
  PageRoutes.questList.routeName: (context) => QuestListPage(),
};

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  if (settings.name == null) {
    assert(false, 'Need to implement ${settings.name}');
    return null;
  }

  if (settings.name == PageRoutes.signUpInfo.routeName) {
    final args = settings.arguments as SignUpInfoArgument;

    return MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<SnackBarBloc>(
                    create: (context) => SnackBarBloc(),
                  ),
                  BlocProvider<ValidFormBloc>.value(value: args.validFormBloc)
                ],
                child: SignUpInfoPage(
                  formKey: args.formKey,
                )));
  }

  if (settings.name == PageRoutes.nftDetail.routeName) {
    final args = settings.arguments as NftDetailArguments;

    return PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        reverseTransitionDuration: const Duration(seconds: 1),
        pageBuilder: (context, animation, secondaryAnimation) {
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: Interval(0, 0.5));
          return FadeTransition(
              opacity: curvedAnimation,
              child: NftDetailPage(
                  imageUrl: args.imageUrl,
                  nftTitle: args.nftTitle,
                  animation: animation));
        });
  }

  if (settings.name == PageRoutes.questDetail.routeName) {
    final args = settings.arguments as QuestDetailArguments;

    return MaterialPageRoute(
        builder: (context) => QuestDetailPage(index: args.index));
  }

  assert(false, 'Need to implement ${settings.name}');
  return null;
}
