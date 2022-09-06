import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project1/Models/cart.dart';
import 'package:project1/Screens/LoginPage.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:core';
import 'package:project1/Screens/ProfileUpdate.dart';
import 'package:project1/Screens/Welcome.dart';
import 'package:project1/Services/auth.dart';

class ShowListPage extends StatefulWidget {
  var product;
  ShowListPage(this.product);

  @override
  State<ShowListPage> createState() => _ShowListPage();
}

class _ShowListPage extends State<ShowListPage> {
  var formKey = GlobalKey<FormState>();
  Future addToCard() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentuser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-cart-items");
    return _collectionRef
        .doc(currentuser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget.product["product-name"],
      "price": widget.product["product-price"],
      "images": widget.product["product-img"],
    }).then((value) => print("Added to the card"));
  }

  Future addToFavorite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentuser = _auth.currentUser;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-favorite-items");
    return _collectionRef
        .doc(currentuser!.email)
        .collection("items")
        .doc()
        .set({
      "name": widget.product["product-name"],
      "price": widget.product["product-price"],
      "images": widget.product["product-img"],
    }).then((value) => print("Added to the favorite"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['product-name']),
        backgroundColor: Colors.grey,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.redAccent,
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ),
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users-favourite-items")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection("items")
                .where("name", isEqualTo: widget.product['product-name'])
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Text("");
              }
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: IconButton(
                    onPressed: () => snapshot.data.docs.length == 0
                        ? addToFavorite()
                        : print("Already Added"),
                    icon: snapshot.data.docs.length != 0
                        ? Icon(
                            Icons.favorite_outline,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*AspectRatio(
              aspectRatio: 3.5,
              child: CarouselSlider(
                  items: String.product['product-img']
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(left: 3, right: 3),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(item),
                                      fit: BoxFit.fitWidth)),
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (val, carouselPageChangedReason) {
                        setState(() {});
                      })),
            ),*/
            SizedBox(
              height: 20,
            ),
            Text(
              widget.product['product-name'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),
            Text(widget.product['product-description']),
            SizedBox(
              height: 20,
            ),
            Text(
              " ${widget.product['product-price'].toString()}",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
            ),
            Divider(),
            SizedBox(
              width: 1000,
              height: 56,
              child: ElevatedButton(
                onPressed: () => addToCard(),
                child: Text(
                  "Add to cart",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
