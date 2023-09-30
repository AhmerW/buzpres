import 'package:buzpres/src/pres/creator/pres_creator_controller.dart';
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

  Widget getWidget(PresSlideWidgetModel model) {
    if (model.type == PresSlideWidgetType.header) {
      return PresCreatorSlideHeaderWidget(model);
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
                child: Text("No slide widgets added!"),
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
                        return Text(
                            "Editing '${title.isEmpty ? 'New slide' : title}'");
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
                  alignment: Alignment.center,
                  key: Key("$index"),
                  height: slideWidget.size,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  margin: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * 1,
                  child: ReorderableDragStartListener(
                    key: Key("$index"),
                    index: index,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: getWidget(slideWidget),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: !getIsVisible(index)
                              ? Container(
                                  key: const Key("show"),
                                  alignment: Alignment.bottomLeft,
                                  child: TextButton.icon(
                                    label: const Text("widget settings"),
                                    icon:
                                        const Icon(Icons.construction_outlined),
                                    onPressed: () => setVisible(index, true),
                                  ),
                                )
                              : Container(
                                  key: const Key("hide"),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  child: Container(
                                    alignment: Alignment.bottomLeft,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: IntrinsicHeight(
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
                                              message: "hide widget",
                                              child: IconButton(
                                                onPressed: () =>
                                                    setVisible(index, false),
                                                icon: const Icon(
                                                  Icons.visibility_off_outlined,
                                                ),
                                              ),
                                            ),
                                            Tooltip(
                                              message: "delete widget",
                                              child: IconButton(
                                                onPressed: () {
                                                  controller
                                                      .deleteWidget(index);
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
                                                const Text("Widget Size"),
                                                Slider(
                                                  value: slideWidget.size,
                                                  onChanged: (v) {
                                                    setState(() {
                                                      controller
                                                          .changeWidgetSize(
                                                              index, v);
                                                    });
                                                  },
                                                  min: 100,
                                                  max: 800,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
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
                                                      double.tryParse(fontSize);
                                                  if (doubleFontSize != null) {
                                                    if (doubleFontSize > 2 &&
                                                        doubleFontSize < 51) {
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
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              child: PopupMenuButton<
                                                  PresSlideWidgetTextAlign>(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                tooltip: "text aligment",
                                                child: const Row(
                                                  children: [
                                                    Text("Text alignment"),
                                                    Icon(Icons.menu_outlined)
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
                                            VerticalDivider(),
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  children: [
                                                    Text("Widget Borders"),
                                                    ToggleButtons(
                                                      renderBorder: true,
                                                      isSelected: [
                                                        true,
                                                        false,
                                                        true,
                                                        true
                                                      ],
                                                      children: const [
                                                        Icon(Icons.border_left),
                                                        Icon(
                                                            Icons.border_right),
                                                        Icon(Icons.border_top),
                                                        Icon(Icons
                                                            .border_bottom),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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

class PresCreatorSlideHeaderWidget extends StatefulWidget {
  final PresSlideWidgetModel model;
  const PresCreatorSlideHeaderWidget(this.model, {super.key});

  @override
  State<PresCreatorSlideHeaderWidget> createState() =>
      _PresCreatorSlideHeaderWidgetState();
}

class _PresCreatorSlideHeaderWidgetState
    extends State<PresCreatorSlideHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: InputFieldWidget(
        labelText: "Header",
        expands: true,
        border: InputBorder.none,
        textAlign: getPresSlideWidgetModelTextAlign(widget.model),
        style: TextStyle(fontSize: widget.model.fontSize),
      ),
    );
  }
}
