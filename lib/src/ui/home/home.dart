import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lycle/src/constants/assets.dart';
import 'package:lycle/src/constants/ui.dart';

import '../../bloc/quest/quest_bloc.dart';
import '../../bloc/quest/quest_event.dart';
import '../../bloc/quest/quest_state.dart';
import '../nft_card_list/nft_card_list.dart';
import '../quest_list/quest_list.dart';
import '../widgets/dialog.dart';
import '../widgets/snack_bar/transaction_snack_bar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late QuestBloc _questBloc;

  final List<Widget> _widgetOptions = <Widget>[
    NftCardListPage(),
    QuestListPage(),
    Container()
  ];
  final List<BottomNavigationBarItem> _bottomNavigationBarOptions =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      activeIcon: SvgPicture.asset(
        bottomNavigationBarHomeActiveIconSvg,
        color: kPrimaryColor,
      ),
      icon: SvgPicture.asset(
        bottomNavigationBarHomeDisableIconSvg,
        color: kDisableColor,
      ),
      label: '홈페이지',
    ),
    BottomNavigationBarItem(
      activeIcon: SvgPicture.asset(
        bottomNavigationBarQuestActiveIconSvg,
        color: kPrimaryColor,
      ),
      icon: SvgPicture.asset(
        bottomNavigationBarQuestDisableIconSvg,
        color: kDisableColor,
      ),
      label: '퀘스트',
    ),
    BottomNavigationBarItem(
      activeIcon: SvgPicture.asset(
        bottomNavigationBarMyPageActiveIconSvg,
        color: kPrimaryColor,
      ),
      icon: SvgPicture.asset(
        bottomNavigationBarMyPageDisableIconSvg,
        color: kDisableColor,
      ),
      label: '내 정보',
    ),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  void initState() {
    super.initState();

    _questBloc = BlocProvider.of<QuestBloc>(context);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await _questBloc.questRepository.init();
    _questBloc.add(GetQuest());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuestBloc, QuestState>(
        listener: (context, state) {
          if (state is QuestLoading) {
            showLoadingDialog(context, Text("정보를 불러오는 중입니다."));
          } else if (state is QuestLoaded) {
            if (isDialogShowing) {
              Navigator.of(context).pop();
              isDialogShowing = false;
            }
          }
        },
        child: TransactionSnackBar(
            child: Scaffold(
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: _bottomNavigationBarOptions,
            currentIndex: _selectedIndex,
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: kDisableColor,
            onTap: _onItemTapped,
          ),
        )));
  }
}
