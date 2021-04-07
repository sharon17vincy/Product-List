import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/Model/Product.dart';
// import 'package:new_project/Model/Product.dart';
import 'package:new_project/PA.dart';
import 'package:new_project/Screens/ViewProductPage.dart';
import 'package:new_project/Widgets/FavouriteButton.dart';
import 'package:new_project/appTheme.dart';

class ProductCard extends StatefulWidget {
  ProductCard(this.index, this.item);


  int index;
  Product item;


  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final PA paMem = PA.getInstance();



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        paMem.selectedProduct = this.widget.item;
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new ProductViewPage()));
      },
      child: Material(
        child: Container(
          height: 350,
          width: 350,
          child: Stack(
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment(0.0, 0.4),
                    end: Alignment(0.0, 1.0),
                    colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                  ).createShader(rect);
                },
                blendMode: BlendMode.srcATop,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(15),
                        image:
                             DecorationImage(
                                image: NetworkImage(this.widget.item.images[0]),
                                fit: BoxFit.fill,
                              )
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(left: 8, right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  this.widget.item.name,
                                  maxLines: 2,
                                  style: productTitle,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom : 16.0, left: 8),
                                child: Text(
                                        this.widget.item.brand,
                                        maxLines: 2,
                                        style: productSubTitle,
                                      ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: FavouriteButton(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
