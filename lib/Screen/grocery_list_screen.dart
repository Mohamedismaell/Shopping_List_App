// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/model/grocery_item.dart';
import 'package:shop_app/widget/grocery_list_items.dart';
import 'package:shop_app/widget/new_item.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() =>
      _GroceryListScreenState();
}

class _GroceryListScreenState
    extends State<GroceryListScreen> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem(BuildContext context) async {
    final newItem = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(builder: (context) => NewItem()),
    );
    if (newItem == null) {
      return;
    } else {
      setState(() {
        _groceryItems.add(newItem);
      });
    }
  }

  void _removedItem(GroceryItem removedItem) {
    setState(() {
      _groceryItems.remove(removedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        "No Items added yet",
        style: TextStyle(fontSize: 24),
      ),
    );
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          return GroceryListItems(
            groceryItem: _groceryItems[index],
            onremove: (removeItem) =>
                _removedItem(_groceryItems[index]),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: () => _addItem(context),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
