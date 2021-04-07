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
                                image: NetworkImage("data:image/jpeg;base64,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"),
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
