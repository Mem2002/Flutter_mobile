import 'package:flutter_app/utils/statusbar_utils.dart';
import 'package:flutter_app/widgets/flexible_space_date_bar.dart';
import 'package:flutter/material.dart';

class SliverDateAppBar extends StatelessWidget {
  final List<Widget>? actions;
  final Function()? onTap;
  final DateTime? currentTime;
  const SliverDateAppBar(
      {super.key, this.actions, this.onTap, this.currentTime});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      systemOverlayStyle: StatusBarUtils.statusConfig(),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      collapsedHeight: 56,
      toolbarHeight: 56,
      expandedHeight: 56,
      foregroundColor: Theme.of(context).colorScheme.primary,
      flexibleSpace: FlexibleSpaceDateBar(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          currentTime: currentTime ?? DateTime.now()),
      actions: actions,
      pinned: true,
    );
  }
}
