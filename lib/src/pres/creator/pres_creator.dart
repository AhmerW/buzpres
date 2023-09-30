import 'package:buzpres/src/pres/creator/pres_creator_controller.dart';
import 'package:buzpres/src/pres/creator/pres_creator_slide_view.dart';
import 'package:buzpres/src/pres/pres_models.dart';
import 'package:buzpres/src/widgets/input_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PresCreatorView extends StatefulWidget {
  const PresCreatorView({super.key});

  @override
  State<PresCreatorView> createState() => _PresCreatorViewState();
}

class _PresCreatorViewState extends State<PresCreatorView> {
  @override
  Widget build(BuildContext context) {
    PresCreatorController controller = Provider.of<PresCreatorController>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.home,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => controller.addPresSlide(
                PresSlideModel(
                  slideWidgets: [],
                  title: "",
                  index: controller.slides.length,
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.new_label_outlined),
                  Text("New slide"),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Icon(Icons.settings_outlined),
                  Text("Project settings"),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
      body: Consumer<PresCreatorController>(builder: (
        context,
        controller,
        _,
      ) {
        return Row(
          children: [
            const Expanded(
              flex: 3,
              child: PresSlideListWidget(),
            ),
            Expanded(
              flex: 10,
              child: Column(children: [
                Expanded(
                  flex: 10,
                  child: controller.getCurrentSlideController == null
                      ? const Center(
                          child: Text("Start by creating a slide!"),
                        )
                      : PresCreatorSlideView(
                          controller.getCurrentSlideController!),
                ),
                const Expanded(
                  flex: 3,
                  child: PresSlideTypeListWidget(),
                ),
              ]),
            ),
          ],
        );
      }),
    );
  }
}

class PresSlideListWidget extends StatefulWidget {
  const PresSlideListWidget({super.key});

  @override
  State<PresSlideListWidget> createState() => _PresSlideListWidgetState();
}

class _PresSlideListWidgetState extends State<PresSlideListWidget> {
  Map<int, bool> hovering = {};

  bool isHovering(index) {
    if (hovering.containsKey(index)) {
      return hovering[index]!;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PresCreatorController>(builder: (context, controller, _) {
      return Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey),
            right: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        child: ReorderableListView.builder(
          onReorderStart: (_) {
            FocusScope.of(context).unfocus();
          },
          buildDefaultDragHandles: false,
          header: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Text("Total of ${controller.slides.length} slides"),
                ElevatedButton(
                  onPressed: () {},
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow_outlined),
                      Text("Preview"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          itemBuilder: (context, index) {
            PresSlideModel? slide = controller.getSlide(index);

            if (slide == null) return Container();

            return ReorderableDragStartListener(
              key: Key("$index"),
              index: index,
              child: Container(
                key: Key("$index"),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Wrap(
                  children: [
                    InkWell(
                      key: Key("$index"),
                      onTap: () => controller.setCurrentSlide(index),
                      onHover: (value) {
                        setState(() {
                          hovering[index] = value;
                        });
                      },
                      child: Material(
                        elevation: 5,
                        type: isHovering(index)
                            ? MaterialType.transparency
                            : MaterialType.canvas,
                        child: Container(
                          height: 150,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.menu_outlined),
                                  IconButton(
                                    onPressed: () =>
                                        controller.deletePresSlide(index),
                                    icon: const Icon(
                                        Icons.delete_forever_outlined),
                                  )
                                ],
                              ),
                              const Spacer(),
                              Expanded(
                                child: InputFieldWidget(
                                  key: ValueKey(slide.title),
                                  text: slide.title,
                                  border: InputBorder.none,
                                  labelText:
                                      slide.title.isEmpty ? "new slide" : "",
                                  style: slide.title.isEmpty
                                      ? const TextStyle(
                                          fontStyle: FontStyle.italic)
                                      : const TextStyle(
                                          fontStyle: FontStyle.normal),
                                  oncomplete: (title) =>
                                      controller.changePresSlideTitle(
                                    title,
                                    index,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: controller.slides.length,
          onReorder: ((oldIndex, newIndex) =>
              controller.reorderPresSlides(oldIndex, newIndex)),
        ),
      );
    });
  }
}

class PresSlideTypeListWidget extends StatefulWidget {
  const PresSlideTypeListWidget({super.key});

  @override
  State<PresSlideTypeListWidget> createState() =>
      _PresSlideTypeListWidgetState();
}

class _PresSlideTypeListWidgetState extends State<PresSlideTypeListWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PresCreatorController>(builder: (context, controller, _) {
      return Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Icon(Icons.widgets_outlined),
                          Text("Widgets"),
                        ],
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List<Widget>.generate(
                      PresSlideWidgetType.values.length,
                      (index) => PresSlideTypeWidget(
                        PresSlideWidgetType.values[index],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
    });
  }
}

class PresSlideTypeWidget extends StatefulWidget {
  final PresSlideWidgetType type;
  const PresSlideTypeWidget(this.type, {super.key});

  @override
  State<PresSlideTypeWidget> createState() => _PresSlideTypeWidgetState();
}

class _PresSlideTypeWidgetState extends State<PresSlideTypeWidget> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        var presController = Provider.of<PresCreatorController>(
          context,
          listen: false,
        );
        PresSlideModelController? controller =
            presController.getCurrentSlideController;

        if (controller != null) {
          controller.addWidget(
            PresSlideWidgetModel(widget.type),
          );
        }
      },
      onHover: (value) => setState(() {
        hovering = value;
      }),
      child: Container(
        color: hovering ? Theme.of(context).secondaryHeaderColor : null,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Material(
          elevation: 10,
          child: Container(
            width: 200,
            height: 100,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(widget.type.name),
                Icon(
                  presSlideWidgetTypeIcons[widget.type],
                  size: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
