import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:lycle/src/constants/assets.dart';

import '../login/login.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  bool isSloganWide = false;
  Duration sloganAnimationDuration = const Duration(milliseconds: 1250);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(loadingBannerPng), context).then((value) {
      FlutterNativeSplash.remove();
      sloganAnimation();
    });
    precacheImage(const AssetImage(loginBannerPng), context);
  }

  Future<void> sloganAnimation() async {
    Future.delayed(const Duration(milliseconds: 250)).then((value) {
      setState(() => isSloganWide = !isSloganWide);
    }).then((value) => Future.delayed(sloganAnimationDuration).then((value) =>
        Future.delayed(const Duration(milliseconds: 1250)).then((value) =>
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginPage())))));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
        child: Container(
            height: double.infinity,
            color: Colors.white,
            child: Image.asset(
              loadingBannerPng,
            )));
  }
}
