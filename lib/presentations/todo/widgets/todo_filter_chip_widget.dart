import 'package:apps_5_crud_firestore/domains/todo/repositories/todo_repository.dart';
import 'package:flutter/material.dart';

class TodoFilterChipWidget extends StatefulWidget {
  final void Function(List<TodoQuery> queries)? onFilterChange;

  const TodoFilterChipWidget({super.key, this.onFilterChange});

  @override
  State<TodoFilterChipWidget> createState() => _TodoFilterChipWidget();
}

class _TodoFilterChipWidget extends State<TodoFilterChipWidget>
    with RestorationMixin {
  final RestorableBool isSelectedFinishedFilter = RestorableBool(true);
  final RestorableBool isSelectedUnfinishedFilter = RestorableBool(true);
  List<TodoQuery> queries = [];

  @override
  void dispose() {
    isSelectedFinishedFilter.dispose();
    isSelectedUnfinishedFilter.dispose();
    super.dispose();
  }

  @override
  String? get restorationId => 'filter_todo';

  @override
  void initState() {
    super.initState();
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(isSelectedFinishedFilter, 'selected_finished');
    registerForRestoration(isSelectedUnfinishedFilter, 'selected_unfinished');
  }

  @override
  Widget build(BuildContext context) {
    final chips = [
      FilterChip(
        label: const Text("Finished"),
        selected: isSelectedFinishedFilter.value,
        onSelected: (value) {
          setState(() {
            isSelectedFinishedFilter.value = !isSelectedFinishedFilter.value;
            if (value) {
              queries.add(TodoQuery.finished);
            } else {
              queries.remove(TodoQuery.finished);
            }
          });

          widget.onFilterChange!(queries);
        },
      ),
      FilterChip(
        label: const Text("Unfinished"),
        selected: isSelectedUnfinishedFilter.value,
        onSelected: (value) {
          setState(() {
            isSelectedUnfinishedFilter.value =
                !isSelectedUnfinishedFilter.value;

            if (value) {
              queries.add(TodoQuery.unfinished);
            } else {
              queries.remove(TodoQuery.unfinished);
            }
          });

          widget.onFilterChange!(queries);
        },
      ),
    ];
    return Row(
      children: [
        for (final chip in chips)
          Padding(
            padding: const EdgeInsets.all(4),
            child: chip,
          )
      ],
    );
  }
}
