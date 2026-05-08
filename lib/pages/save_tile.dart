import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SaveTile extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final Function(BuildContext)? deleteFunction;

  const SaveTile({
    super.key,
    required this.name,
    required this.onTap,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              //label: 'Supprimer',
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(name),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
