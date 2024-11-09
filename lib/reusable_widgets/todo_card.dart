import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/bloc/list_bloc/list_states.dart';
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
  Timer? timer;

  @override
  void dispose() {
    textEditingController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    value = widget.value ?? false;
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
    return BlocProvider(
      create: (context) => listBloc,
      child: BlocListener<ListBloc, ListState>(
        listener: (context, state) {
          if (state is UpdateListState) {
            debugPrint("List Updated");
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
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
              setState(
                () {
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
                  if ((timer?.isActive ?? false) || !value) timer?.cancel();
                  if (value) {
                    timer = Timer(const Duration(seconds: 3), () {
                      listBloc.add(
                        RemoveListEvent(
                          index: widget.index,
                        ),
                      );
                    });
                  }
                },
              );
            },
            title: TextField(
              focusNode: focusNode,
              controller: textEditingController,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                decoration: value ? TextDecoration.lineThrough : null,
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
      ),
    );
  }
}
