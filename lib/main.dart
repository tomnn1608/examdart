import 'package:flutter/material.dart';
import 'model/Order.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Order',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Order> orders = [];
  List<Order> filteredOrders = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredOrders = orders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Order',
          style: TextStyle(
            color: Colors.amber.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search'),
              onChanged: (value) {
                filterOrders(value);
              },
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _itemController,
                    decoration: InputDecoration(labelText: 'Item'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an item';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _itemNameController,
                    decoration: InputDecoration(labelText: 'Item Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an item name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _currencyController,
                    decoration: InputDecoration(labelText: 'Currency'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          Order newOrder = Order(
                            id: orders.length + 1,
                            item: _itemController.text,
                            itemName: _itemNameController.text,
                            quantity: int.parse(_quantityController.text),
                            price: double.parse(_priceController.text),
                            currency: _currencyController.text,
                          );
                          orders.add(newOrder);
                          filterOrders(_searchController.text); // Cập nhật danh sách lọc
                          _itemController.clear();
                          _itemNameController.clear();
                          _quantityController.clear();
                          _priceController.clear();
                          _currencyController.clear();
                        });
                      }
                    },
                    child: Text('Add Item'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Item')),
                    DataColumn(label: Text('Item Name')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Currency')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: filteredOrders.map((order) {
                    return DataRow(cells: [
                      DataCell(Text(order.id.toString())),
                      DataCell(Text(order.item)),
                      DataCell(Text(order.itemName)),
                      DataCell(Text(order.quantity.toString())),
                      DataCell(Text(order.price.toString())),
                      DataCell(Text(order.currency)),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              orders.remove(order);
                              filterOrders(_searchController.text); // Cập nhật danh sách lọc
                            });
                          },
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filterOrders(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredOrders = orders;
      } else {
        filteredOrders = orders.where((order) =>
        order.item.toLowerCase().contains(query.toLowerCase()) ||
            order.itemName.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }
}
