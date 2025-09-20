// import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/data/categories.dart';
import 'package:shop_app/model/grocery_item.dart';
import 'package:shop_app/widget/grocery_list_items.dart';
import 'package:shop_app/widget/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() =>
      _GroceryListScreenState();
}

class _GroceryListScreenState
    extends State<GroceryListScreen> {
  List<GroceryItem> _groceryItems = [];
  var _isloading = true;
  String? _error;
  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  void _loadItem() async {
    try {
      final url = Uri.https(
        'shopping-list-4a428-default-rtdb.firebaseio.com',
        'shopping-list.json',
      );
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Server is down :(';
          _isloading = false;
        });
        return;
      }
      if (response.body == 'null') {
        setState(() {
          _isloading = false;
        });
        return;
      }
      final Map<String, dynamic> listdata = jsonDecode(
        response.body,
      );
      final List<GroceryItem> loadedItem = [];
      for (final item in listdata.entries) {
        final category = categories.entries
            .firstWhere(
              (catItem) =>
                  item.value['category'] ==
                  catItem.value.title,
            )
            .value;

        loadedItem.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }
      setState(() {
        _groceryItems = loadedItem;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong';
        _isloading = false;
      });
      return;
    }
  }

  void _addItem(BuildContext context) async {
    final newItem = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(builder: (context) => NewItem()),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
      _isloading = false;
    });
  }

  void _removedItem(GroceryItem removedItem) async {
    final index = _groceryItems.indexOf(removedItem);
    setState(() {
      _groceryItems.remove(removedItem);
    });
    final url = Uri.https(
      'shopping-list-4a428-default-rtdb.firebaseio.com',
      'shopping-list/${removedItem.id}.json',
    );
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, removedItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        "No Items added yet",
        style: TextStyle(fontSize: 24),
      ),
    );
    if (_isloading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
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
    if (_error != null) {
      content = Center(child: Text(_error!));
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
