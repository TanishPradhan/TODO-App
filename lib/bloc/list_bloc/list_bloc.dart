import 'dart:io';

import 'package:bloc/bloc.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/models/list_model.dart';
import 'package:flutter/material.dart';
import 'list_events.dart';
import 'list_states.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc(): super (const InitialListState()) {
    Box<ListModel> listBox = Hive.box<ListModel>('todo-list');

    on<UpdateListEvent>((event, emit) async {
      if (event.listModel.title!.isEmpty) {
        await listBox.deleteAt(event.index);
        debugPrint("List Box Length: ${listBox.length}");
        emit(const UpdateListState());
      } else {
        await listBox.putAt(event.index, ListModel(title: event.listModel.title, value: event.listModel.value));
        debugPrint("List Box Length: ${listBox.length}");
        emit(const UpdateListState());
      }
    });

    on<AddListEvent>((event, emit) async {
      if (listBox.length == 0 || listBox.getAt(listBox.length - 1)!.title!.isNotEmpty) {
        listBox.add(ListModel(title: "", value: false));
      }
      debugPrint("List Box Length: ${listBox.length}");
      emit(const UpdateListState());
    });

    on<RemoveListEvent>((event, emit) async {
      await listBox.deleteAt(event.index);
      debugPrint("List Box Length: ${listBox.length}");
      emit(const RemovedListState());
    });
  }
}