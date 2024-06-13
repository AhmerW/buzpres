import 'package:flutter/material.dart';

enum PresSlideWidgetType { poll, image, content, header, row }

enum PresSlideWidgetTextAlign { center, left, right }

Map<PresSlideWidgetType, IconData> presSlideWidgetTypeIcons = {
  PresSlideWidgetType.poll: Icons.ballot_outlined,
  PresSlideWidgetType.image: Icons.image_outlined,
  PresSlideWidgetType.content: Icons.feed_outlined,
  PresSlideWidgetType.header: Icons.title_outlined,
  PresSlideWidgetType.row: Icons.list_alt_outlined,
};

// Represents one widget, which can contain sub widgets
class PresSlideWidgetModel {
  int widgetNumber = 0;
  final PresSlideWidgetType type;
  PresSlideWidgetTextAlign textAlign;
  double size;
  double margin;
  double fontSize;
  double borderSize;
  final List<PresSlideWidgetType> children;
  bool borderLeft;
  bool borderRight;
  bool borderTop;
  bool borderBottom;
  String content;
  var json;

  PresSlideWidgetModel(this.type,
      {this.children = const [],
      this.size = 205,
      this.fontSize = 14,
      this.margin = 10,
      this.textAlign = PresSlideWidgetTextAlign.left,
      this.borderBottom = false,
      this.borderRight = false,
      this.borderLeft = false,
      this.borderTop = false,
      this.borderSize = 1,
      this.content = ""});
}

class PresModel {
  List<PresSlideModel> slides;

  PresModel({this.slides = const []});
}

class PresSlideModel {
  final List<PresSlideWidgetModel> slideWidgets;
  int index;
  String title;

  PresSlideModel({
    required this.slideWidgets,
    required this.index,
    this.title = "",
  });
  void changeSlideTitle(String newTitle) {
    title = newTitle;
  }
}
