import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/Screens/ProfileUpdate.dart';
import 'package:project1/Screens/SearchScreen.dart';
import 'package:project1/Screens/ShowListPage.dart';
import 'package:project1/Screens/Welcome.dart';
import 'package:project1/Services/auth.dart';

class HomeState extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeState> {
  TextEditingController _searchController = TextEditingController();
  List<String> _carouselImages = [];
  var _dotPosition = 0;
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;
  @override
  void initState() {
    fetchCarouselImages();
    fetcthProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("HOME"),
          backgroundColor: Colors.green,
        ),
        drawer: NavigationDrawer(),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 10,
                ),
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        borderSide: BorderSide(color: Colors.grey)),
                    hintText: "Search",
                    hintStyle: TextStyle(fontSize: 15),
                  ),
                  onTap: () => Navigator.push(context,
                      CupertinoPageRoute(builder: (_) => SearchScreen())),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              AspectRatio(
                aspectRatio: 3.5,
                child: CarouselSlider(
                    items: _carouselImages
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
                          setState(() {
                            _dotPosition = val;
                          });
                        })),
              ),
              SizedBox(
                height: 10,
              ),
              DotsIndicator(
                dotsCount:
                    _carouselImages.length == 0 ? 1 : _carouselImages.length,
                position: _dotPosition.toDouble(),
                decorator: DotsDecorator(
                  activeColor: Colors.green,
                  color: Colors.green.withOpacity(0.5),
                  spacing: EdgeInsets.all(2),
                  activeSize: Size(8, 8),
                  size: Size(6, 6),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (() => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ShowListPage(_products[index])))),
                          child: Card(
                            elevation: 3,
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 2,
                                  child: Container(
                                      color: Colors.green.shade100,
                                      child: Image.network(
                                          _products[index]["product-img"])),
                                ),
                                Text("${_products[index]["product-name"]}"),
                                Text("${_products[index]["product-price"]}")
                              ],
                            ),
                          ),
                        );
                      }))
            ],
          )),
        ));
  }

  fetchCarouselImages() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("carousel-slider").get();
    for (var i = 0; i < qn.docs.length; i++) {
      setState(() {
        _carouselImages.add(
          qn.docs[i]["img-path"],
        );
      });
      print(qn.docs[i]["img-path"]);
    }
    return qn.docs;
  }

  fetcthProducts() async {
    QuerySnapshot qn = await _firestoreInstance.collection("products").get();
    for (var i = 0; i < qn.docs.length; i++) {
      setState(() {
        _products.add({
          "product-img": qn.docs[i]["product-img"],
          "product-name": qn.docs[i]["product-name"],
          "product-price": qn.docs[i]["product-price"],
          "product-description": qn.docs[i]["product-description"],
        });
      });
    }
    return qn.docs;
  }
}

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({Key? key}) : super(key: key);
  final AuthService _authService = AuthService();

  /* List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('User')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }*/

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          runSpacing: 10,
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text("HOME"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => WelcomeState()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("UPDATE PROFILE"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app_sharp),
              title: const Text("SIGN OUT"),
              onTap: () {
                _authService.signout();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        color: Color.fromARGB(255, 28, 156, 32),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Column(
          children: const [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              backgroundImage: NetworkImage(
                  "https://cdn0.iconfinder.com/data/icons/set-ui-app-android/32/8-512.png"),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "user" + " " + "lastname",
              style: TextStyle(fontSize: 28, color: Colors.white),
            )
          ],
        ),
      );
}
