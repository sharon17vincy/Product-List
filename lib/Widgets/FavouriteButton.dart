import 'package:flutter/material.dart';
import 'package:new_project/PA.dart';
import 'package:new_project/appTheme.dart';


class FavouriteButton extends StatefulWidget {
  // final String itemID;
  // final VoidCallback onRefresh;

  // FavouriteButton(this.itemID,this.onRefresh);

  @override
  _FavouriteButtonState createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  PA libMem = PA.getInstance();


  // Future<bool> getFavourite() async {
  //   List<String> listFav = [];
  //   String uid = libMem.userRecord.uid;
  //   await FirebaseFavouriteHelper().getFavourite(uid).then((favourite) {
  //     setState(() {
  //       libMem.favourList.clear();
  //       libMem.favourList.addAll(favourite);
  //       print('************');
  //       print(libMem.favourList.length);
  //       for (var i = 0; i < libMem.favourList.length; i++) {
  //         if (!listFav.contains(libMem.favourList[i].item_id)) {
  //           setState(() {
  //             listFav.add(libMem.favourList[i].item_id);
  //           });
  //         }
  //       }
  //       libMem.listFavour.clear();
  //       libMem.listFavour.addAll(listFav);
  //       widget.onRefresh();
  //     });
  //   });
  //   return true;
  // }

  // Future<bool> addFavourite() async {
  //   await FirebaseFavouriteHelper()
  //       .addFavourite(libMem.userRecord.uid, this.widget.itemID).then((value) => getFavourite())
  //       .catchError((error) {});
  //   return true;
  // }


  // Future<bool> removeFavourite(String id) async {
  //   await FirebaseFavouriteHelper().removeFavourite(id).then((value) => getFavourite());
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    // print(this.widget.itemID);
    return IconButton(
      onPressed: () {
        // newFavDialog(context);
      },
      icon: Icon(
        // libMem.listFavour.contains(widget.itemID)
        //     ? Icons.star
            // :
             Icons.star_border,
        color: appTheme.accentColor,
        size: 30,
      ),
    );
  }

  // Future<String> newFavDialog(BuildContext context) async {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15.0),
  //         ),
  //         title: Container(
  //             child: Text(
  //           !libMem.listFavour.contains(widget.itemID)
  //               ? "Add Favourite"
  //               : "Remove Favourite",
  //           style: TextStyle(color: appTheme.accentColor),
  //         )),
  //         content: !libMem.listFavour.contains(widget.itemID)
  //             ? Text("Add"  + ' to Favourites ?')
  //             : Text("Remove" + ' ' + 'from Favourites ?'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text(
  //               "No",
  //               style: TextStyle(color: Colors.white),
  //             ),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //           TextButton(
  //             child: Text(
  //               !libMem.listFavour.contains(widget.itemID) ? "Add" : "Remove",
  //               style: TextStyle(color: appTheme.accentColor),
  //             ),
  //             onPressed: () {
  //               if (!libMem.listFavour.contains(widget.itemID)) {
  //                 setState(() {
  //                   libMem.listFavour.add(widget.itemID);
  //                   addFavourite();
  //                 });
  //               } else {
  //                 setState(() {
  //                   print("removing*******");
  //                   libMem.listFavour.remove(widget.itemID);
  //                   for (var i = 0; i < libMem.favourList.length; i++) {
  //                     if (libMem.favourList[i].item_id == widget.itemID &&
  //                         libMem.favourList[i].uid == libMem.currentUser.uid) {
  //                       removeFavourite(libMem.favourList[i].ID);
  //                     }
  //                   }
  //                 });
  //               }
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

