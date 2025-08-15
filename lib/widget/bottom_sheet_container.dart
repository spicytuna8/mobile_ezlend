import 'package:flutter/material.dart';

class BottomSheetContainer extends StatelessWidget {
  final Widget child;
  final double? radiusBorder;
  const BottomSheetContainer(
      {super.key, required this.child, this.radiusBorder});

  static Future<T?> showBottomSheet<T>(BuildContext context, Widget child,
      {double? paddingHeight}) {
    return showModalBottomSheet<T?>(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (bottomSheetContext) {
          return BottomSheetContainer(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: paddingHeight ?? 56),
            child: child,
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radiusBorder ?? 20),
                topRight: Radius.circular(radiusBorder ?? 20))),
        child: child);
  }
}
