import 'package:buzpres/src/pres/creator/pres_creator_controller.dart';
import 'package:buzpres/src/pres/creator/pres_creator_slide_widgets.dart';
import 'package:buzpres/src/pres/pres_models.dart';
import 'package:buzpres/src/widgets/input_field_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PresCreatorSlideView extends StatefulWidget {
  final PresSlideModelController slide;
  const PresCreatorSlideView(this.slide, {super.key});

  @override
  State<PresCreatorSlideView> createState() => _PresCreatorSlideViewState();
}

class _PresCreatorSlideViewState extends State<PresCreatorSlideView> {
  Map<int, bool> visible = {};

  bool getIsVisible(int index) {
    if (visible.containsKey(index)) {
      return visible[index]!;
    }
    return false;
  }

  void setVisible(int index, bool value) {
    setState(() {
      visible[index] = value;
    });
  }

  Widget getWidget(PresSlideWidgetModelController controller) {
    if (controller.model.type == PresSlideWidgetType.header) {
      return PresCreatorSlideTextWidget(controller);
    }
    if (controller.model.type == PresSlideWidgetType.content) {
      return PresCreatorSlideTextWidget(controller);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PresSlideModelController>.value(
      value: widget.slide,
      key: ValueKey(widget.slide.slide),
      builder: (context, _) {
        return Consumer<PresSlideModelController>(
          builder: (context, controller, _) {
            if (controller.slide.slideWidgets.isEmpty) {
              return const Center(
                child: Text("Start by adding a  widget"),
              );
            }
            return ReorderableListView.builder(
              onReorderStart: (_) {
                FocusScope.of(context).unfocus();
              },
              buildDefaultDragHandles: false,
              header: Column(
                children: [
                  Consumer<PresCreatorController>(
                    builder: (context, controller, _) {
                      if (controller.getCurrentSlide != null) {
                        String title = controller.getCurrentSlide!.title;
                        return Text(title.isEmpty
                            ? "Editing 'slide ${controller.getCurrentSlide!.index + 1}'"
                            : "Editing '$title'");
                      }
                      return Container();
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {}, child: Text("Preview slide")),
                  const Divider()
                ],
              ),
              itemBuilder: (context, index) {
                PresSlideWidgetModel slideWidget =
                    controller.slide.slideWidgets[index];
                return Container(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  key: Key("$index"),
                  height: slideWidget.size,
                  decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                          color: Colors.black,
                          width: slideWidget.borderSize,
                          style: slideWidget.borderLeft
                              ? BorderStyle.solid
                              : BorderStyle.none,
                        ),
                        right: BorderSide(
                          color: Colors.black,
                          width: slideWidget.borderSize,
                          style: slideWidget.borderRight
                              ? BorderStyle.solid
                              : BorderStyle.none,
                        ),
                        top: BorderSide(
                          color: Colors.black,
                          width: slideWidget.borderSize,
                          style: slideWidget.borderTop
                              ? BorderStyle.solid
                              : BorderStyle.none,
                        ),
                        bottom: BorderSide(
                          color: Colors.black,
                          width: slideWidget.borderSize,
                          style: slideWidget.borderBottom
                              ? BorderStyle.solid
                              : BorderStyle.none,
                        )),
                  ),
                  margin: EdgeInsets.only(
                    left: 20,
                    top: slideWidget.margin,
                    bottom: slideWidget.margin,
                    right: 20,
                  ),
                  width: MediaQuery.of(context).size.width * 1,
                  child: ReorderableDragStartListener(
                    key: Key("$index"),
                    index: index,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                              child: controller.getWidgetController(index) !=
                                      null
                                  ? getWidget(
                                      controller.getWidgetController(index)!)
                                  : Container()),
                        ),
                        Wrap(
                          children: [
                            const Icon(Icons.drag_handle),
                            Row(
                              children: [
                                Container(
                                  key: const Key("show"),
                                  alignment: Alignment.bottomLeft,
                                  child: TextButton.icon(
                                    label: const Text("text options"),
                                    icon: const Icon(Icons.text_fields),
                                    onPressed: () {
                                      controller.changeToolbarValue(index);
                                    },
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child: !getIsVisible(index)
                                      ? Container(
                                          key: const Key("show"),
                                          alignment: Alignment.bottomLeft,
                                          child: TextButton.icon(
                                            label:
                                                const Text("widget settings"),
                                            icon: const Icon(
                                                Icons.construction_outlined),
                                            onPressed: () =>
                                                setVisible(index, true),
                                          ),
                                        )
                                      : Container(
                                          key: const Key("hide"),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          child: Container(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    Tooltip(
                                                      message: "help",
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                          Icons.info_outline,
                                                        ),
                                                      ),
                                                    ),
                                                    Tooltip(
                                                      message: "hide settings",
                                                      child: IconButton(
                                                        onPressed: () =>
                                                            setVisible(
                                                                index, false),
                                                        icon: const Icon(
                                                          Icons
                                                              .visibility_off_outlined,
                                                        ),
                                                      ),
                                                    ),
                                                    Tooltip(
                                                      message: "delete widget",
                                                      child: IconButton(
                                                        onPressed: () {
                                                          controller
                                                              .deleteWidget(
                                                                  index);
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                    const VerticalDivider(),
                                                    Column(
                                                      children: [
                                                        const Text(
                                                            "Widget Size"),
                                                        Slider(
                                                          value:
                                                              slideWidget.size,
                                                          onChanged: (v) {
                                                            setState(() {
                                                              controller
                                                                  .changeWidgetSize(
                                                                      index, v);
                                                            });
                                                          },
                                                          min: 205,
                                                          max: 800,
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 20),
                                                      width: 100,
                                                      child: InputFieldWidget(
                                                        labelText:
                                                            "widget margin",
                                                        text: slideWidget.margin
                                                            .toString(),
                                                        textInputType:
                                                            TextInputType
                                                                .number,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        oncomplete: (fontSize) {
                                                          double? doubleMargin =
                                                              double.tryParse(
                                                                  fontSize);
                                                          if (doubleMargin !=
                                                              null) {
                                                            if (doubleMargin >=
                                                                    0 &&
                                                                doubleMargin <
                                                                    50) {
                                                              setState(() {
                                                                controller
                                                                    .changeWidgetMargin(
                                                                        index,
                                                                        doubleMargin);
                                                              });
                                                            } else {}
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    VerticalDivider(),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Column(
                                                        children: [
                                                          const Text(
                                                              "Widget Borders"),
                                                          ToggleButtons(
                                                            onPressed:
                                                                (borderIndex) {
                                                              controller
                                                                  .changeWidgetBorderState(
                                                                      index,
                                                                      borderIndex);
                                                            },
                                                            renderBorder: true,
                                                            isSelected: [
                                                              slideWidget
                                                                  .borderLeft,
                                                              slideWidget
                                                                  .borderRight,
                                                              slideWidget
                                                                  .borderTop,
                                                              slideWidget
                                                                  .borderBottom
                                                            ],
                                                            children: const [
                                                              Icon(Icons
                                                                  .border_left),
                                                              Icon(Icons
                                                                  .border_right),
                                                              Icon(Icons
                                                                  .border_top),
                                                              Icon(Icons
                                                                  .border_bottom),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      child: SizedBox(
                                                        width: 100,
                                                        child: InputFieldWidget(
                                                          labelText:
                                                              "border size",
                                                          text: slideWidget
                                                              .borderSize
                                                              .toString(),
                                                          textInputType:
                                                              TextInputType
                                                                  .number,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly
                                                          ],
                                                          oncomplete:
                                                              (fontSize) {
                                                            double?
                                                                doubleBorderSize =
                                                                double.tryParse(
                                                                    fontSize);
                                                            if (doubleBorderSize !=
                                                                null) {
                                                              if (doubleBorderSize >=
                                                                      0 &&
                                                                  doubleBorderSize <
                                                                      30) {
                                                                setState(() {
                                                                  controller
                                                                      .changeWidgetBorderSize(
                                                                          index,
                                                                          doubleBorderSize);
                                                                });
                                                              } else {}
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: controller.slide.slideWidgets.length,
              onReorder: (oldIndex, newIndex) =>
                  controller.reorderWidgets(oldIndex, newIndex),
            );
          },
        );
      },
    );
  }
}

TextAlign getPresSlideWidgetModelTextAlign(PresSlideWidgetModel model) {
  switch (model.textAlign) {
    case PresSlideWidgetTextAlign.right:
      return TextAlign.right;

    case PresSlideWidgetTextAlign.center:
      return TextAlign.center;

    default:
      return TextAlign.left;
  }
}



/*
Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  child: SizedBox(
                                                    width: 100,
                                                    child: InputFieldWidget(
                                                      labelText: "font size",
                                                      text: slideWidget.fontSize
                                                          .toString(),
                                                      textInputType:
                                                          TextInputType.number,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      oncomplete: (fontSize) {
                                                        double? doubleFontSize =
                                                            double.tryParse(
                                                                fontSize);
                                                        if (doubleFontSize !=
                                                            null) {
                                                          if (doubleFontSize >
                                                                  2 &&
                                                              doubleFontSize <
                                                                  51) {
                                                            setState(() {
                                                              controller
                                                                  .changeWidgetFontSize(
                                                                      index,
                                                                      doubleFontSize);
                                                            });
                                                          } else {}
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
*/
/*
Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: PopupMenuButton<
                                                      PresSlideWidgetTextAlign>(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    tooltip: "text aligment",
                                                    child: const Row(
                                                      children: [
                                                        Text("Text alignment"),
                                                        Icon(
                                                            Icons.menu_outlined)
                                                      ],
                                                    ),
                                                    onSelected:
                                                        (PresSlideWidgetTextAlign
                                                            textAlign) {
                                                      setState(
                                                        () {
                                                          controller
                                                              .changeWidgetTextAlign(
                                                            index,
                                                            textAlign,
                                                          );
                                                        },
                                                      );
                                                    },
                                                    itemBuilder: (context) => [
                                                      const PopupMenuItem(
                                                        value:
                                                            PresSlideWidgetTextAlign
                                                                .left,
                                                        child: Text("Left"),
                                                      ),
                                                      const PopupMenuItem(
                                                        value:
                                                            PresSlideWidgetTextAlign
                                                                .center,
                                                        child: Text("Center"),
                                                      ),
                                                      const PopupMenuItem(
                                                        value:
                                                            PresSlideWidgetTextAlign
                                                                .right,
                                                        child: Text("Right"),
                                                      ),
                                                    ],
                                                  ),
                                                ),
*/