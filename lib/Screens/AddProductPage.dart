import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_project/Model/Product.dart';
import 'package:new_project/PA.dart';
import 'package:new_project/appTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductAddPage extends StatefulWidget {
  final bool isUpdating;

  ProductAddPage({@required this.isUpdating});

  @override
  _StockEditPageState createState() => _StockEditPageState();
}

class _StockEditPageState extends State<ProductAddPage> {
  PA paMem = PA.getInstance();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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

    if (this.widget.isUpdating) {
      _name.text = paMem.selectedProduct.name;
      _brand.text = paMem.selectedProduct.brand;
      _rate.text = paMem.selectedProduct.price;
      _des.text = paMem.selectedProduct.description;
      _waranty.text = paMem.selectedProduct.waranty;
      storage = paMem.selectedProduct.storage;
      rating = paMem.selectedProduct.rating;
      ram = paMem.selectedProduct.ram;
      color = paMem.selectedProduct.color;
      images.addAll(paMem.selectedProduct.images);
    } else {
      _name.text = "";
      _brand.text = "";
      _rate.text = "";
      _des.text = "";
      _waranty.text = "";
      storage = null;
      rating = 0;
      ram = null;
      color = null;
    }
  }

  void showSnackBar(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          _scaffoldKey.currentState.removeCurrentSnackBar();
        },
      ),
    ));
  }

  msgDialog(String text, bool val) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              StatefulBuilder(
                builder: (BuildContext context, StateSetter alertState) {
                  return Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 16),
                          child: val
                              ? Icon(
                                  Icons.check,
                                  size: 100,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.close,
                                  size: 100,
                                  color: Colors.red,
                                )),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0),
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        padding: EdgeInsets.only(
                            top: 24, bottom: 16, left: 8, right: 0),
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            Navigator.pop(context);
                            if (val) {
                              Navigator.pop(context);
                            }
                          },
                          child: Text("OK",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0)),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<Product>> getPrefs(Product item) async {
    prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList("products");
    if (list == null) {
      print('null');
      setPref(item);
    } else {
      print('!null');
      setState(() {
        productList.clear();
        productList = list
            .map<Product>((item) => Product.fromJson(json.decode(item)))
            .toList();
      });
      print(productList.length);
      if (this.widget.isUpdating) {
        print("Already present");
        for (int i = 0; i < productList.length; i++) {
          if (productList[i].id == item.id) {
            productList[i] = item;
          }
        }
      } else {
        productList.add(item);
      }
      print(productList.length);
      setPrefs(productList);
    }
    msgDialog("Product added successfully", true);
    return productList;
  }

  Future<String> setPref(Product cart) async {
    List<String> list = [];
    // var list = prefs.getStringList("cart");
    String item = json.encode(cart.toJson());
    list.add(item);
    print(item);
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList("products", list);
    print(prefs.getStringList("products"));
  }

  Future<String> setPrefs(List<Product> cart) async {
    List<String> list = [];
    // String item = jsonEncode(cart);
    for (var i = 0; i < cart.length; i++) {
      setState(() {
        String item = json.encode(cart[i].toJson());
        list.add(item);
      });
    }
    print(list);
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList("products", list);
    print(prefs.getStringList("products"));
  }

  Future<void> _validate() async {
    if (widget.isUpdating) {
      //edit data
      if (_formKey.currentState.validate()) {
        print("Edit data");
        if (storage == null) {
          msgDialog("Please select storage", false);
        } else if (ram == null) {
          msgDialog("Please select RAM", false);
        } else if (color == null) {
          msgDialog("Please select color", false);
        } else if (rating == null) {
          msgDialog("Please give rating", false);
        } else if (images.length == 0) {
          msgDialog("Please select images before saving", false);
        } else {
          Product product = new Product(
              paMem.selectedProduct.id,
              _name.text,
              color,
              images[0],
              storage,
              ram,
              rating,
              _des.text,
              paMem.selectedProduct.favourite,
              _waranty.text,
              images,
              _brand.text,
              _rate.text);
          getPrefs(product);
        }
      }
    } else {
      //add data
      if (_formKey.currentState.validate()) {
        print(storage);
        if (storage == null) {
          msgDialog("Please select storage", false);
        } else if (ram == null) {
          msgDialog("Please select RAM", false);
        } else if (color == null) {
          msgDialog("Please select color", false);
        } else if (rating == null) {
          msgDialog("Please give rating", false);
        } else if (images.length == 0) {
          msgDialog("Please select images before saving", false);
        } else {
          Product product = new Product(
              DateTime.now().millisecondsSinceEpoch.toString(),
              _name.text,
              color,
              images[0],
              storage,
              ram,
              rating,
              _des.text,
              false,
              _waranty.text,
              images,
              _brand.text,
              _rate.text);
          getPrefs(product);
        }
      }
    }
  }

  Future<void> uploadImage() async {
    final completer = Completer<List<String>>();
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.accept = 'image/*';
    uploadInput.click();
    // onChange doesn't work on mobile safari
    uploadInput.addEventListener('change', (e) async {
      // read file content as dataURL
      final files = uploadInput.files;
      Iterable<Future<String>> resultsFutures = files.map((file) {
        final reader = FileReader();
        reader.readAsDataUrl(file);
        reader.onError.listen((error) => completer.completeError(error));
        return reader.onLoad.first.then((_) => reader.result as String);
      });

      final results = await Future.wait(resultsFutures);
      completer.complete(results);
    });
    // need to append on mobile safari
    document.body.append(uploadInput);
    final List<String> image = await completer.future;
    setState(() {
      images.clear();
      images.addAll(image);
    });
    uploadInput.remove();
  }

  // void uploadImage() {
  //   InputElement upload = FileUploadInputElement()..accept = "image/*";
  //   upload.click();

  //   upload.onChange.listen((event) {
  //     final file = upload.files.first;
  //     final reader = FileReader();
  //     reader.readAsDataUrl(file);
  //     reader.onLoadEnd.listen((event) {
  //       print("DONE*****************");
  //     });
  //   });
  // }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: new Text('Exit', style: TextStyle(color: Colors.red)),
            content: new Text('Are you sure you want to Exit ?'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              new FlatButton(
                child: new Text('Yes'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Add Product',
            ),
          ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          if (selectedIdx !=
                                              images.length - 1) {
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
                              Container(
                                  height: 800,
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
                                              child: Text("Select Images")))),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: FlatButton(
                                  color: Colors.grey,
                                  onPressed: () {
                                    uploadImage();
                                  },
                                  child: Text('Choose File'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          padding: EdgeInsets.only(left: 32),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                child: TextFormField(
                                  onChanged: (value) {
                                    nameText = value;
                                  },
                                  validator: (value) {
                                    _name.text = value;
                                    if (value.isEmpty) {
                                      return 'Enter Name';
                                    }
                                    return null;
                                  },
                                  controller: _name,
                                  decoration: InputDecoration(
                                      labelText: "Name",
                                      hintText: 'Name',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                padding: EdgeInsets.all(16),
                                child: TextFormField(
                                  onChanged: (value) {
                                    nameText = value;
                                  },
                                  validator: (value) {
                                    _brand.text = value;
                                    if (value.isEmpty) {
                                      return 'Enter Brand';
                                    }
                                    return null;
                                  },
                                  controller: _brand,
                                  decoration: InputDecoration(
                                      labelText: "Brand",
                                      hintText: 'Brand',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                padding: EdgeInsets.all(16),
                                child: TextFormField(
                                  onChanged: (value) {
                                    nameText = value;
                                  },
                                  validator: (value) {
                                    _rate.text = value;
                                    if (value.isEmpty) {
                                      return 'Enter Price';
                                    }
                                    return null;
                                  },
                                  controller: _rate,
                                  decoration: InputDecoration(
                                      labelText: "Price",
                                      hintText: 'Price',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      "Storage ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                        side: BorderSide(
                                            width: 1,
                                            color: appTheme.accentColor),
                                      ),
                                      color: storage == "128GB"
                                          ? appTheme.accentColor
                                          : Colors.transparent,
                                      onPressed: () {
                                        setState(() {
                                          storage = "128GB";
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '128GB',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // ignore: deprecated_member_use
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                        side: BorderSide(
                                            width: 1,
                                            color: appTheme.accentColor),
                                      ),
                                      color: storage == "256GB"
                                          ? appTheme.accentColor
                                          : Colors.transparent,
                                      onPressed: () {
                                        setState(() {
                                          storage = "256GB";
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '256GB',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 24),
                                      child: Text(
                                        "RAM ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                          side: BorderSide(
                                              width: 1,
                                              color: appTheme.accentColor),
                                        ),
                                        color: ram == "6GB"
                                            ? appTheme.accentColor
                                            : Colors.transparent,
                                        onPressed: () {
                                          setState(() {
                                            ram = "6GB";
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '6GB',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // ignore: deprecated_member_use
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                          side: BorderSide(
                                              width: 1,
                                              color: appTheme.accentColor),
                                        ),
                                        color: ram == "8GB"
                                            ? appTheme.accentColor
                                            : Colors.transparent,
                                        onPressed: () {
                                          setState(() {
                                            ram = "8GB";
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '8GB',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 24),
                                      child: Text(
                                        "Color ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FlatButton(
                                        color: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                          side: BorderSide(
                                              width: 2,
                                              color: color == "black"
                                                  ? Colors.orange
                                                  : Colors.black),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            color = "black";
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FlatButton(
                                        color: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                          side: BorderSide(
                                              width: 2,
                                              color: color == "blue"
                                                  ? Colors.orange
                                                  : Colors.black),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            color = "blue";
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FlatButton(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                          side: BorderSide(
                                              width: 2,
                                              color: color == "white"
                                                  ? Colors.orange
                                                  : Colors.black),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            color = "white";
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 24),
                                      child: Text(
                                        "Rating ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isSelected = [
                                              true,
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                            rating = 1;
                                          });
                                        },
                                        icon: Icon(
                                          rating >= 1
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
                                        onPressed: () {
                                          setState(() {
                                            isSelected = [
                                              true,
                                              true,
                                              false,
                                              false,
                                              false
                                            ];
                                            rating = 2;
                                          });
                                        },
                                        icon: Icon(
                                          rating >= 2
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
                                        onPressed: () {
                                          setState(() {
                                            isSelected = [
                                              true,
                                              true,
                                              true,
                                              false,
                                              false
                                            ];
                                            rating = 3;
                                          });
                                        },
                                        icon: Icon(
                                          rating >= 3
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
                                        onPressed: () {
                                          setState(() {
                                            isSelected = [
                                              true,
                                              true,
                                              true,
                                              true,
                                              false
                                            ];
                                            rating = 4;
                                          });
                                        },
                                        icon: Icon(
                                          rating >= 4
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
                                        onPressed: () {
                                          setState(() {
                                            isSelected = [
                                              true,
                                              true,
                                              true,
                                              true,
                                              true
                                            ];
                                            rating = 5;
                                          });
                                        },
                                        icon: Icon(
                                          rating >= 5
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
                                width: MediaQuery.of(context).size.width / 2,
                                padding: EdgeInsets.all(16),
                                child: TextFormField(
                                  onChanged: (value) {
                                    nameText = value;
                                  },
                                  validator: (value) {
                                    _waranty.text = value;
                                    if (value.isEmpty) {
                                      return 'Enter waranty details';
                                    }
                                    return null;
                                  },
                                  controller: _waranty,
                                  decoration: InputDecoration(
                                      labelText: "Enter waranty details",
                                      hintText: 'Enter waranty details',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                padding: EdgeInsets.all(16),
                                child: TextFormField(
                                  onChanged: (value) {
                                    nameText = value;
                                  },
                                  maxLines: 15,
                                  validator: (value) {
                                    _des.text = value;
                                    if (value.isEmpty) {
                                      return 'Enter description';
                                    }
                                    return null;
                                  },
                                  controller: _des,
                                  decoration: InputDecoration(
                                      labelText: "Enter description",
                                      hintText: 'Enter description',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 16, bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                              height: 48,
                              width: MediaQuery.of(context).size.width / 1.1,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                  side:
                                      BorderSide(width: 1, color: Colors.green),
                                ),
                                onPressed: () {
                                  print("*****save**********");
                                  _validate();
                                },
                                color: Colors.green,
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
