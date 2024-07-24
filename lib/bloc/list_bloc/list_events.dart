

import 'package:equatable/equatable.dart';

import '../../models/list_model.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();
}

class AddListEvent extends ListEvent {
  const AddListEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class UpdateListEvent extends ListEvent {
  final ListModel listModel;
  final int index;

  const UpdateListEvent({required this.index, required this.listModel});

  @override
  List<Object> get props => [listModel];
}

class RemoveListEvent extends ListEvent {
  final int index;
  const RemoveListEvent({required this.index});

  @override
  List<Object?> get props => throw UnimplementedError();
}