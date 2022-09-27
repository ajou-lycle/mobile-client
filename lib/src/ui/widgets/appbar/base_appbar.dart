import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lycle/src/constants/ui.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  static final AppBar _appBar = AppBar();
  final String title;
  final bool needBackButton;
  final void Function()? backButtonOnPressed;

  const BaseAppBar(
      {Key? key,
      required this.title,
      required this.needBackButton,
      this.backButtonOnPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: size.height * 0.03,
      shadowColor: kPrimaryAppBarShadowColor,
      backgroundColor: kPrimaryAppBarBackgroundColor,
      foregroundColor: kPrimaryAppBarForegroundColor,
      leading: needBackButton
          ? BackButton(
              onPressed: backButtonOnPressed,
              color: kPrimaryAppBarBackButtonColor,
            )
          : null,
      title: Text(
        title,
        style: TextStyle(fontSize: kDefaultAppBarTitleFontSize),
      ),
      centerTitle: true,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(_appBar.preferredSize.height);
}
