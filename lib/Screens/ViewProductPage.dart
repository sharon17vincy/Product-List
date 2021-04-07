import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/Model/Product.dart';
import 'package:new_project/PA.dart';
import 'package:new_project/Screens/AddProductPage.dart';
import 'package:new_project/appTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductViewPage extends StatefulWidget {
  @override
  _StockEditPageState createState() => _StockEditPageState();
}

class _StockEditPageState extends State<ProductViewPage> {
  PA paMem = PA.getInstance();
  final _formKey = GlobalKey<FormState>();
  String filePath = 'images/${DateTime.now()}';
  List<bool> isSelected;
  TextEditingController _name = new TextEditingController();
  TextEditingController _brand = new TextEditingController();
  TextEditingController _rate = new TextEditingController();
  TextEditingController _waranty = new TextEditingController();
  TextEditingController _des = new TextEditingController();
  String storage, ram, color;
  num rating, selectedIdx;
  List images;
  List<Product> productList;

  bool isSelecting;
  var myFormat = DateFormat('dd/MM/yyyy');

  List<String> itemList;
  String nameText;
  String stockText;
  String rateText;
  String comText;
  String imageQual;

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    images = [];
    productList = [];
    isSelected = [false, false, false, false, false];
    selectedIdx = 0;
    images.addAll(paMem.selectedProduct.images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(right: 16, left: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {
                                  if (selectedIdx != 0) {
                                    setState(() {
                                      selectedIdx--;
                                    });
                                  }
                                },
                                icon: Icon(
                                  // libMem.listFavour.contains(widget.itemID)
                                  //     ? Icons.star
                                  // :
                                  Icons.arrow_left,
                                  color: Colors.black,
                                  size: 60,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (selectedIdx != images.length - 1) {
                                      selectedIdx++;
                                    }
                                  });
                                },
                                icon: Icon(
                                  // libMem.listFavour.contains(widget.itemID)
                                  //     ? Icons.star
                                  // :
                                  Icons.arrow_right,
                                  color: Colors.black,
                                  size: 60,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top :24.0),
                          child: Container(
                              height: 500,
                              // decoration: BoxDecoration(
                              //     color: Colors.grey[900],
                              //     borderRadius: BorderRadius.circular(15),
                              // image: DecorationImage(
                              //   image: NetworkImage(
                              //      images[0]),
                              //   fit: BoxFit.fill,
                              // )),
                              child: images.length > 0
                                  ? Image.network(images[selectedIdx])
                                  : Center(
                                      child: Container(
                                          child: Text("No Images Found")))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/2,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                              padding: EdgeInsets.only(top: 16, bottom: 16.0),
                              child: SizedBox(
                                  height: 40,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                      side: BorderSide(
                                          width: 1,
                                          color: appTheme.primaryColorDark),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new ProductAddPage(
                                                    isUpdating: true,
                                                  )));
                                    },
                                    color: appTheme.primaryColorDark,
                                    child: Text(
                                      'EDIT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ))),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            paMem.selectedProduct.name,
                            style: TextStyle(
                                color: appTheme.primaryColor,
                                fontSize: 48,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            paMem.selectedProduct.brand,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: Icon(
                                    paMem.selectedProduct.rating >= 1
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: appTheme.accentColor,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: Icon(
                                    paMem.selectedProduct.rating >= 2
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: appTheme.accentColor,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: Icon(
                                    paMem.selectedProduct.rating >= 3
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: appTheme.accentColor,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: Icon(
                                    paMem.selectedProduct.rating >= 4
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: appTheme.accentColor,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: Icon(
                                    paMem.selectedProduct.rating >= 5
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: appTheme.accentColor,
                                    size: 30,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            paMem.selectedProduct.price,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                "Storage : ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                paMem.selectedProduct.storage,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                "RAM : ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                paMem.selectedProduct.ram,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              "Color : ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              paMem.selectedProduct.color.toUpperCase(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ]),
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              "Waranty : ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              paMem.selectedProduct.waranty,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ]),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8, left: 16.0),
                              child: Text(
                                "Description : ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 16),
                              child: Text(
                                paMem.selectedProduct.description,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                          ],
                        )
                        
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
