import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SaveTile extends StatelessWidget {
  final String name;
  final bool isFavorite;
  final VoidCallback onTap;
  final Function(BuildContext)? deleteFunction;
  final Function(BuildContext)? changeFavorite;

  const SaveTile({
    super.key,
    required this.name,
    required this.isFavorite,
    required this.onTap,
    required this.deleteFunction,
    required this.changeFavorite,
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
            SlidableAction(
              onPressed: changeFavorite,
              backgroundColor: Colors.green,
              foregroundColor: isFavorite ? Colors.yellow : Colors.grey,
              icon: isFavorite ? Icons.star : Icons.star_border,
              )
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
