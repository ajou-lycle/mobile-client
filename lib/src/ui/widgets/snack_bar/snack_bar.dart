import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/snack_bar/snack_bar_bloc.dart';
import '../../../bloc/snack_bar/snack_bar_event.dart';
import '../../../bloc/snack_bar/snack_bar_state.dart';
import '../../../constants/ui.dart';
import '../../../utils/context_extension.dart';

class SnackBarBuilder extends StatefulWidget {
  final SnackBarBloc snackBarBloc;
  final Widget child;

  const SnackBarBuilder({
    Key? key,
    required this.snackBarBloc,
    required this.child,
  }) : super(key: key);

  @override
  State<SnackBarBuilder> createState() => SnackBarBuilderState();
}

class SnackBarBuilderState extends State<SnackBarBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SnackBarBloc, SnackBarState>(
        bloc: widget.snackBarBloc,
        listener: (context, state) {
          if (context.isDeprecated()) {
            return;
          }
          if (state is SnackBarShow) {
            if (!isSnackbarActive) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              if (!widget.snackBarBloc.isClosed) {
                widget.snackBarBloc.add(HideSnackBar());
              }
            }
            isSnackbarActive = true;

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(
                    duration: const Duration(seconds: 1),
                    content: Row(
                      children: state.children,
                    )))
                .closed
                .then((value) {
              isSnackbarActive = false;
              if (!widget.snackBarBloc.isClosed) {
                widget.snackBarBloc.add(HideSnackBar());
              }
              if (state.closedCallback != null) {
                state.closedCallback!();
              }
            });
          }
        },
        child: widget.child);
  }
}
