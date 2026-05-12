import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ObjetsSpeciauxTile extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final Function(BuildContext)? deleteFunction;

  const ObjetsSpeciauxTile({
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
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.star, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
          ],
        ),
      ),
    );
  }
}