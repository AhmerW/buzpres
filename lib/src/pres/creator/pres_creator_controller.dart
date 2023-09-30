import 'package:buzpres/src/pres/pres_models.dart';
import 'package:flutter/material.dart';

class PresSlideModelController extends ChangeNotifier {
  final PresSlideModel slide;
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

  void setBorder() {}
  void getBorder() {}

  void changeWidgetTextAlign(int index, PresSlideWidgetTextAlign textAlign) {
    var widget = getWidget(index);
    if (widget != null) {
      widget.textAlign = textAlign;
    }
  }

  void addWidget(PresSlideWidgetModel model) {
    slide.slideWidgets.add(model);

    notifyListeners();
  }

  void deleteWidget(int index) {
    if (slide.slideWidgets.length > index) {
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
