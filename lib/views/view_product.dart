import 'package:firebase/screens/products_screen.dart';
import 'package:flutter/material.dart';

class ViewProducts extends StatefulWidget {
  const ViewProducts({Key? key}) : super(key: key);

  @override
  _ViewProductsState createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FireBase'),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/agregarnew');
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: ListProducts(),
    );
  }
}
