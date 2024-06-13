import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PresCreatorSettingsViewDialog extends StatefulWidget {
  const PresCreatorSettingsViewDialog({super.key});

  @override
  State<PresCreatorSettingsViewDialog> createState() =>
      _PresCreatorSettingsViewDialogState();
}

class _PresCreatorSettingsViewDialogState
    extends State<PresCreatorSettingsViewDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50.h,
          height: 50.h,
          child: AlertDialog(
              content: Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text("Go live"),
              )
            ],
          )),
        ),
      ],
    );
  }
}
