import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../bloc/list_bloc/list_bloc.dart';
import '../bloc/list_bloc/list_events.dart';
import '../models/list_model.dart';

class TodoCard extends StatefulWidget {
  final String? title;
  final bool? value;
  final int index;

  const TodoCard({super.key, this.title, this.value, required this.index});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  Box<ListModel> listBox = Hive.box<ListModel>('todo-list');
  bool value = false;
  TextEditingController textEditingController = TextEditingController();
  ListBloc listBloc = ListBloc();
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      value = widget.value ?? false;
    });
    textEditingController.text = widget.title ?? "";
    focusNode.addListener(() => focusChange());
    super.initState();
  }

  void focusChange() {
    debugPrint("Focus Changed to: ${focusNode.hasFocus}");
    if (!focusNode.hasFocus) {
      listBloc.add(
        UpdateListEvent(
          index: widget.index,
          listModel: ListModel(
            title: textEditingController.text,
            value: value,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Dismissible(
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Colors.red,
          ),
          child: const Center(
            child: Text(
              "Delete",
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        key: ValueKey<String>(textEditingController.text),
        onDismissed: (DismissDirection direction) {
          listBloc.add(
            RemoveListEvent(index: widget.index),
          );
        },
        child: CheckboxListTile(
          value: value,
          side: const BorderSide(color: Colors.black45, width: 2.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
            side: const BorderSide(color: Colors.black12, width: 1.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          activeColor: Colors.blue,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (onChanged) {
            setState(() {
              value = onChanged!;
              listBloc.add(
                UpdateListEvent(
                  index: widget.index,
                  listModel: ListModel(
                    title: textEditingController.text,
                    value: value,
                  ),
                ),
              );
            });
          },
          title: TextField(
            focusNode: focusNode,
            controller: textEditingController,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            autofocus: textEditingController.text.isEmpty ? true : false,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Type here...",
              hintStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
