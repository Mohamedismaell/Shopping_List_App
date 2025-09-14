import 'package:flutter/material.dart';
import 'package:shop_app/model/grocery_item.dart';

class GroceryListItems extends StatelessWidget {
  const GroceryListItems({
    super.key,
    required this.groceryItem,
    required this.onremove,
  });
  final GroceryItem groceryItem;
  final void Function(GroceryItem removeItem) onremove;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(groceryItem),
      background: Container(
        color: Colors.red,
        child: Row(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Icon(Icons.delete),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        onremove(groceryItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${groceryItem.name} removed!'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 5,
        ),
        child: ListTile(
          title: Text(groceryItem.name),
          leading: Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: groceryItem.category.color,
            ),
          ),
          trailing: Text(
            groceryItem.quantity.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
// Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Container(
//               height: 40,
//               width: 40,
//               decoration: BoxDecoration(
//                 color: groceryItem.category.color,
//               ),
//             ),
//           ),
//           Text(groceryItem.name),
//           Spacer(),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               groceryItem.quantity.toString(),
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),