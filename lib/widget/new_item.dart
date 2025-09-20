import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/data/categories.dart';
import 'package:shop_app/model/category.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/model/grocery_item.dart';
// import 'package:shop_app/model/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _enteredCategory = categories[Categories.other]!;
  var _isSending = false;
  void _saveState() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      _formKey.currentState!.save();
      final url = Uri.https(
        'shopping-list-4a428-default-rtdb.firebaseio.com',
        'shopping-list.json',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _enteredCategory.title,
        }),
      );
      print(response.body);
      print(response.statusCode);
      if (!context.mounted) {
        return;
      }
      final Map<String, dynamic> responseData = jsonDecode(
        response.body,
      );
      Navigator.of(context).pop(
        GroceryItem(
          id: responseData['name'],
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _enteredCategory,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adding New Item")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,

                decoration: InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter a name.';
                  }
                  if (value.trim().length < 4) {
                    return 'Name must be at least 4 chars';
                  }
                  if (!RegExp(
                    r'^[a-zA-Z\s]+$',
                  ).hasMatch(value)) {
                    return 'No special characters or numbers allowed.';
                  }
                  return null;
                },
                onSaved: (newValue) =>
                    _enteredName = newValue!,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly,
                      ],
                      decoration: InputDecoration(
                        label: Text("Quantity"),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Please enter a quantity.';
                        }
                        final intValue = int.parse(value);
                        if (intValue < 1) {
                          return 'Quantity must be at least 1.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(
                          value!,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _enteredCategory,
                      items: [
                        for (final category
                            in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color:
                                      category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        _enteredCategory = value!;
                      },
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSending
                          ? null
                          : () => _formKey.currentState!
                                .reset(),
                      child: const Text("Reset"),
                    ),
                    ElevatedButton(
                      onPressed: _isSending
                          ? null
                          : () => _saveState(),
                      child: _isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child:
                                  CircularProgressIndicator(),
                            )
                          : const Text("Add Item"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
