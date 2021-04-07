import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:new_project/Model/Product.dart';
import 'package:new_project/PA.dart';
import 'package:new_project/Screens/AddProductPage.dart';
import 'package:new_project/Widgets/productCard.dart';
import 'package:new_project/appTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PA paMem = PA.getInstance();
  List<Product> productList, filteredList;

  TextEditingController _searchController = new TextEditingController();
  Future _future;
  bool isSearching = false;
  bool isSelected = true;
  int gridCount;
  RangeValues _currentRangeValues = const RangeValues(40, 80);

  SharedPreferences prefs;

  void initState() {
    super.initState();
    productList = [];
    filteredList = [];
    gridCount = 3;
    _future = getPrefs();
  }

  Future<List<Product>> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList("products");
    if (list == null) {
      print('null');
    } else {
      print('!null');
      setState(() {
        productList.clear();
        productList = list
            .map<Product>((item) => Product.fromJson(json.decode(item)))
            .toList();
      });
      print(productList.length);
      filteredList.clear();
      filteredList.addAll(productList);
    }
    return productList;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(true);
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              backgroundColor: appTheme.primaryColor,
              floating: true,
              pinned: true,
              snap: false,
              leadingWidth: 16,
              title: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 36, bottom: 24),
                child: Text(
                  "Mobile Phones",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                      fontSize: 45,
                      color: Colors.black),
                ),
              ),
              actions: [
                Container(
                    padding: EdgeInsets.only(top: 16, bottom: 16.0, right: 16),
                    child: SizedBox(
                        height: 40,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            side: BorderSide(
                                width: 1, color: appTheme.primaryColorDark),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .push(new MaterialPageRoute(
                                    builder: (context) => new ProductAddPage(
                                          isUpdating: false,
                                        )))
                                .whenComplete(() => _future = getPrefs());
                          },
                          color: appTheme.primaryColorDark,
                          child: Text(
                            'ADD PRODUCT',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ))),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                centerTitle: true,
                background: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 80, left: 36, right: 36),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(15)),
                    child: TextFormField(
                      onTap: () {
                        setState(() {
                          isSearching = true;
                        });
                      },
                      onChanged: (text) {
                    
                        print(text);
                        setState(() {
                          if (text.isNotEmpty) {
                            filteredList.clear();
                            for (int i = 0; i < productList.length; i++) {
                              if (productList[i].brand.contains(text)) {
                                filteredList.add(productList[i]);
                              }
                            }
                          } else {
                            filteredList.clear();
                            filteredList.addAll(productList);
                          }
                        });
                      },
                      controller: _searchController,
                      decoration: InputDecoration(
                          // fillColor: Colors.grey[850],
                          filled: true,
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search Product',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.zero),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder(
                  future: _future,
                  builder: (_, snapshot) {
                    if (snapshot.connectionState != ConnectionState.waiting) {
                      return Column(
                        children: [
                          Container(
                            height: 80,
                            // color: Colors.red,
                            child: Stack(fit: StackFit.passthrough, children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 40.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: appTheme.primaryColor,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(30),
                                      )),
                                ),
                              ),
                              // Padding(
                              //     padding: EdgeInsets.only(
                              //         right: 8, left: 8, bottom: 8),
                              //     child: Container(
                              //       padding: EdgeInsets.all(12),
                              //       decoration: BoxDecoration(
                              //           color: Colors.grey[850],
                              //           borderRadius:
                              //               BorderRadius.circular(15)),
                              //     ))
                            ]),
                          ),
                          //     newFilterCard(),
                          GestureDetector(
                            // onPanDown: (scale) {},
                            // onPanUp : (scale){},
                            onDoubleTap: () {
                              setState(() {
                                gridCount == 1 ? gridCount = 2 : gridCount = 1;
                              });
                            },
                            child: Container(
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: filteredList.length,
                                    scrollDirection: Axis.vertical,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4),
                                    itemBuilder: (_, index) {
                                      return ProductCard(
                                        index,
                                        productList[index],
                                      ); //stockList[index]
                                    })),
                          ),
                        ],
                      );
                    }
                    return Container(
                      height: 500,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
