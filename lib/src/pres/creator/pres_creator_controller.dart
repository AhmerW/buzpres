import 'package:buzpres/src/pres/pres_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class PresSlideModelController extends ChangeNotifier {
  final PresSlideModel slide;
  int widgetCount = 0;
  Map<int, PresSlideWidgetModelController> widgetControllers = {};

  PresSlideModelController(this.slide);

  void changeSlideTitle(String title) {
    slide.title = title;
    notifyListeners();
  }

  PresSlideWidgetModel? getWidget(int index) {
    if (slide.slideWidgets.length > index) {
      return slide.slideWidgets[index];
    }
    return null;
  }

  void changeWidgetSize(int index, double size) {
    var widget = getWidget(index);
    if (widget != null) {
      widget.size = size;
    }
  }

  void changeWidgetFontSize(int index, double size) {
    var widget = getWidget(index);
    if (widget != null) {
      widget.fontSize = size;
    }
  }

  void changeWidgetMargin(int index, double margin) {
    var widget = getWidget(index);
    if (widget != null) {
      widget.margin = margin;
    }
  }

  void changeWidgetBorderSize(int index, double size) {
    var widget = getWidget(index);
    if (widget != null) {
      widget.borderSize = size;
    }
  }

  void changeToolbarValue(int index) {
    var controller = getWidgetController(index);
    if (controller != null) {
      controller.updateToolbarValue(!controller.toolbarActive);
    }
  }

  void setBorder() {}
  void getBorder() {}

  void changeWidgetBorderState(int widgetIndex, int index) {
    var widget = getWidget(widgetIndex);
    if (widget == null) {
      return;
    }
    if (index == 0) {
      widget.borderLeft = !widget.borderLeft;
    }
    if (index == 1) {
      widget.borderRight = !widget.borderRight;
    }
    if (index == 2) {
      widget.borderTop = !widget.borderTop;
    }
    if (index == 3) {
      widget.borderBottom = !widget.borderBottom;
    }
    notifyListeners();
  }

  void changeWidgetTextAlign(int index, PresSlideWidgetTextAlign textAlign) {
    var widget = getWidget(index);
    if (widget != null) {
      widget.textAlign = textAlign;
    }
  }

  PresSlideWidgetModelController? getWidgetController(int index) {
    var widget = getWidget(index);
    if (widget != null) {
      if (widgetControllers.containsKey(widget.widgetNumber)) {
        return widgetControllers[widget.widgetNumber]!;
      }
      var controller = PresSlideWidgetModelController(widget);
      widgetControllers[widget.widgetNumber] = controller;
    }
    return null;
  }

  void addWidget(PresSlideWidgetModel model) {
    widgetCount += 1;
    model.widgetNumber = widgetCount;
    widgetControllers[model.widgetNumber] =
        PresSlideWidgetModelController(model);
    slide.slideWidgets.add(model);

    notifyListeners();
  }

  void deleteWidget(int index) {
    if (slide.slideWidgets.length > index) {
      widgetControllers.remove(slide.slideWidgets[index].widgetNumber);
      slide.slideWidgets.removeAt(index);
      notifyListeners();
    }
  }

  void reorderWidgets(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    var s = slide.slideWidgets.removeAt(oldIndex);
    slide.slideWidgets.insert(newIndex, s);

    notifyListeners();
  }
}

class PresSlideWidgetModelController extends ChangeNotifier {
  PresSlideWidgetModel model;
  late QuillController controller;
  bool toolbarActive = false;
  PresSlideWidgetModelController(this.model) {
    if (model.type == PresSlideWidgetType.header ||
        model.type == PresSlideWidgetType.content) {
      controller = QuillController(
        document:
            model.json == null ? Document() : Document.fromJson(model.json),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }

  void updateToolbarValue(bool value) {
    toolbarActive = value;
    notifyListeners();
  }
}

class PresCreatorController extends ChangeNotifier {
  String title = "";
  List<PresSlideModelController> slides = [];
  PresSlideModelController? currentSlide;

  PresModel getPresModel() {
    return PresModel(slides: List.from(slides));
  }

  PresSlideModel? getSlide(int index) {
    PresSlideModelController? slide = slides.elementAtOrNull(index);
    if (slide != null) {
      return slide.slide;
    }
    return null;
  }

  PresSlideModel? get getCurrentSlide =>
      currentSlide != null ? currentSlide!.slide : null;

  PresSlideModelController? get getCurrentSlideController => currentSlide;

  void setCurrentSlide(int index) {
    if (slides.length > index) {
      currentSlide = slides[index];

      notifyListeners();
    }
  }

  void changePresSlideTitle(String title, int index) {
    if (slides.length > index) {
      slides[index].changeSlideTitle(title);
    }
  }

  void reorderPresSlides(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    PresSlideModelController slide = slides.removeAt(oldIndex);
    slides.insert(newIndex, slide);

    notifyListeners();
  }

  void addPresSlide(PresSlideModel slide) {
    PresSlideModelController newSlide = PresSlideModelController(slide);
    currentSlide ??= newSlide;

    slides.add(newSlide);
    notifyListeners();
  }

  void deletePresSlide(int index) {
    if (slides.length > index) {
      slides.removeAt(index);
      notifyListeners();
    }
  }

  void savePres() {}
}
