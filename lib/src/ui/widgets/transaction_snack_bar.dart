import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lycle/src/bloc/wallet/wallet_bloc.dart';

import '../../bloc/wallet/wallet_event.dart';
import '../../bloc/write_contract/write_contract_bloc.dart';
import '../../bloc/write_contract/write_contract_state.dart';
import '../../constants/ui.dart';

class TransactionSnackBar extends StatefulWidget {
  Widget child;

  TransactionSnackBar({required this.child});

  @override
  State<TransactionSnackBar> createState() => TransactionSnackBarState();
}

class TransactionSnackBarState extends State<TransactionSnackBar> {
  late WriteContractBloc _writeContractBloc;
  late WalletBloc _walletBloc;

  @override
  void initState() {
    super.initState();
    _writeContractBloc = BlocProvider.of<WriteContractBloc>(context);
    _walletBloc = BlocProvider.of<WalletBloc>(context);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WriteContractBloc, WriteContractState>(
        bloc: _writeContractBloc,
        listener: (context, state) {
          if (!isSnackbarActive) {
            if (state is TransactionSend) {
              isSnackbarActive = true;

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                      content: Row(
                    children: [
                      CircularProgressIndicator(),
                      Text("요청을 처리 중입니다.")
                    ],
                  )))
                  .closed
                  .then((value) => isSnackbarActive = false);
            } else if (state is TransactionSucceed) {
              isSnackbarActive = true;

              _walletBloc.add(UpdateWallet());
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                      content: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                      ),
                      Text("요청이 성공했습니다.")
                    ],
                  )))
                  .closed
                  .then((value) => isSnackbarActive = false);
            } else if (state is TransactionFailed ||
                state is WriteContractError) {
              isSnackbarActive = true;

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                      content: Row(
                    children: [
                      Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                      ),
                      Text("요청이 실패했습니다.")
                    ],
                  )))
                  .closed
                  .then((value) => isSnackbarActive = false);
            }
          }
        },
        child: widget.child);
  }
}
