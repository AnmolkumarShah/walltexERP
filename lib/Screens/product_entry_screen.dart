import 'package:flutter/material.dart';
import 'package:walltex_app/Helpers/querie.dart';
import 'package:walltex_app/Helpers/show_snakebar.dart';
import 'package:walltex_app/Helpers/text_form_field_helper.dart';
import 'package:walltex_app/Services/loader_services.dart';
import 'package:walltex_app/Services/product_class.dart';
import 'package:walltex_app/Services/references_class.dart';
import 'package:walltex_app/control.dart';

class ProductEntryScreen extends StatefulWidget {
  const ProductEntryScreen({Key? key}) : super(key: key);

  @override
  State<ProductEntryScreen> createState() => _ProductEntryScreenState();
}

class _ProductEntryScreenState extends State<ProductEntryScreen> {
  final Input _product = Input(label: "Product Name");
  bool loading = false;

  handleSave() async {
    setState(() {
      loading = true;
    });

    if (!_product.isEmpty()) {
      Product prod = Product(desc: _product.value(), id: -1);
      dynamic res = await prod.save();
      if (res == true) {
        showSnakeBar(context, "Product Saved Successfully");
        Navigator.pop(context);
      } else {
        showSnakeBar(context, "Error In Product Saving");
      }
    } else {
      showSnakeBar(context, "Enter Product Name");
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Control.productScreen['name'].toString()),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: FutureBuilder(
                future: Query.fetch(Product()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loader.circular;
                  }
                  List<Product> data = snapshot.data as List<Product>;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text(
                          data[index].display(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      color: Colors.green,
                    ),
                  );
                },
              ),
            ),
            Card(
              elevation: 8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _product.builder(),
                  TextButton(
                    onPressed: handleSave,
                    child: const Text("Save Product"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
