import 'dart:convert';

import 'package:buzpres/src/pres/creator/pres_creator_controller.dart';
import 'package:buzpres/src/pres/creator/pres_creator_slide_view.dart';
import 'package:buzpres/src/pres/pres_models.dart';
import 'package:buzpres/src/widgets/input_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

class PresCreatorSlideTextWidget extends StatefulWidget {
  PresSlideWidgetModelController state;

  PresCreatorSlideTextWidget(this.state, {super.key}) {}

  @override
  State<PresCreatorSlideTextWidget> createState() =>
      _PresCreatorSlideTextWidgetState();
}

class _PresCreatorSlideTextWidgetState
    extends State<PresCreatorSlideTextWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PresSlideWidgetModelController>.value(
      key: ValueKey(widget.state.model),
      value: widget.state,
      builder: (context, child) {
        return Container(
          child: Column(
            children: [
              widget.state.toolbarActive
                  ? QuillToolbar.simple(
                      configurations: QuillSimpleToolbarConfigurations(
                        controller: widget.state.controller,
                        sharedConfigurations: const QuillSharedConfigurations(
                          locale: Locale('en'),
                        ),
                      ),
                    )
                  : Container(),
              Expanded(
                child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    placeholder: "text",
                    autoFocus: true,
                    scrollable: true,
                    controller: widget.state.controller,
                    readOnly: false,
                    sharedConfigurations: const QuillSharedConfigurations(
                      locale: Locale('en'),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
