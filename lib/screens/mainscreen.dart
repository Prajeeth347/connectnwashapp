// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:connectnwash/extentions/extentions.dart';
import 'package:connectnwash/models/addressmodel.dart';
import 'package:connectnwash/models/clothesmodel.dart';
import 'package:connectnwash/screens/addressesscreen.dart';
import 'package:connectnwash/screens/profilescreen.dart';
import 'package:connectnwash/services/clotheshelper.dart';
import 'package:connectnwash/variables/variables.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  String? custid;
  int quantity = 0;
  int? custnumb;
  List<AddressModel>? adddet;
  List<Clothesmodel>? clothes;
  List<Clothesmodel> cartItems = [];
  bool clothesloaded = false;
  int? addindex;
  bool addloaded = false;
  final List<String> genders = ["", "Male", "Female", "Unisex"];
  @override
  void initState() {
    super.initState();
    getaddresses();
    getClothesData();
  }

  getaddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    custid = prefs.getString('CNWUid');
    custnumb = prefs.getInt('CNWUpno');
    String baseuri = Variables().baseuri;
    var empclient = http.Client();
    var empuri = Uri.parse("${baseuri}getaddress");
    var empresponse = await empclient.post(empuri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"Custid": custid}));
    setState(() {
      addloaded = true;
    });
    var empjson = empresponse.body;
    if (empjson != []) {
      adddet = addressModelFromJson(empjson);
    }
    prefs.setString('address', empjson);
    addindex = prefs.getInt('addindex');
  }

  getClothesData() async {
    clothes = await ClothesService().getClothes();
    if (clothes != null) {
      setState(() {
        clothesloaded = true;
      });
    }
  }

  addItemToCart(Clothesmodel clothModel) {
    if (cartItems.isNotEmpty) {
      //Below condition will check if the new item exist in the cartItems or not
      //If not then will add new item to the cartItems
      int itemIndex =
          cartItems.indexWhere((element) => element.name == clothModel.name);

      if (itemIndex < 0) {
        setState(() {
          cartItems.add(clothModel);
        });
      }
    } else {
      setState(() {
        cartItems.add(clothModel);
      });
    }
  }

  removeItemFromCart(Clothesmodel clothModel) {
    if (cartItems.isNotEmpty && clothModel.quantity == null) {
      setState(() {
        cartItems.removeWhere((element) => element.name == clothModel.name);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: 'D2E0FB'.toColor(),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          backgroundColor: '2E4374'.toColor(),
          title: GestureDetector(
            onTap: () {
              if (addloaded) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddressScreen(custid: custid!)));
              }
            },
            child: addloaded
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Text(
                          addindex != null
                              ? adddet![addindex!].city
                              : adddet![0].city,
                          style: GoogleFonts.lato(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Text(
                          addindex != null
                              ? adddet![addindex!].address
                              : adddet![0].address,
                          style: GoogleFonts.lato(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ],
                    ))
                : const CircularProgressIndicator(
                    color: Colors.white,
                  ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProfileScreen()));
              },
              icon: const Icon(Icons.person),
              iconSize: MediaQuery.of(context).size.height * 0.04,
            )
          ],
        ),
      ),
      body: Center(
        child: clothesloaded == false
            ? CircularProgressIndicator(
                color: '35155D'.toColor(),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                            0, MediaQuery.of(context).size.height * 0.02, 0, 0),
                        // shrinkWrap: true,
                        itemCount: clothes!.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: ((context, index) {
                          return Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Card(
                                  margin: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            '1B262C'.toColor(),
                                            '0F4C75'.toColor(),
                                            '3282B8'.toColor(),
                                            'BBE1FA'.toColor()
                                          ]),
                                    ),
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.03),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: Image.memory(base64Decode(
                                                clothes![index].image))),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              clothes![index].name,
                                              style: GoogleFonts.lato(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05),
                                            ),
                                            Text(
                                              '₹ ${clothes![index].price.toString()}',
                                              style: GoogleFonts.lato(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.04),
                                            ),
                                            Text(
                                              genders[clothes![index].gender],
                                              style: GoogleFonts.lato(
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.04),
                                            ),
                                          ],
                                        ),
                                        if (clothes![index].quantity ==
                                            null) ...[
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      'BBE1FA'.toColor()),
                                              onPressed: () {
                                                setState(() {
                                                  quantity = quantity + 1;
                                                  clothes![index].quantity = 1;
                                                });
                                                addItemToCart(clothes![index]);
                                              },
                                              child: Text(
                                                'Add',
                                                style: GoogleFonts.roboto(
                                                    color: '1B262C'.toColor()),
                                              ))
                                        ] else ...[
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      quantity = quantity - 1;
                                                      if (clothes![index]
                                                              .quantity ==
                                                          1) {
                                                        clothes![index]
                                                            .quantity = null;
                                                      } else {
                                                        clothes![index]
                                                                .quantity =
                                                            clothes![index]
                                                                    .quantity! -
                                                                1;
                                                      }
                                                    });
                                                    removeItemFromCart(
                                                        clothes![index]);
                                                  },
                                                  icon: FaIcon(
                                                    FontAwesomeIcons.minus,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                    color: 'BBE1FA'.toColor(),
                                                  )),
                                              Text(
                                                clothes![index]
                                                    .quantity
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                    color: 'BBE1FA'.toColor(),
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      quantity = quantity + 1;
                                                      clothes![index].quantity =
                                                          clothes![index]
                                                                  .quantity! +
                                                              1;
                                                    });
                                                    addItemToCart(
                                                        clothes![index]);
                                                  },
                                                  icon: FaIcon(
                                                    FontAwesomeIcons.plus,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                    color: 'BBE1FA'.toColor(),
                                                  )),
                                            ],
                                          )
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        })),
                  ),
                  if (quantity != 0) ...[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                              '071952'.toColor(),
                              '088395'.toColor(),
                              '35A29F'.toColor(),
                              // 'FFCD4B'.toColor()
                            ])),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.04,
                              MediaQuery.of(context).size.height * 0.03,
                              MediaQuery.of(context).size.width * 0.04,
                              MediaQuery.of(context).size.height * 0.03),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.basketShopping,
                                    size: MediaQuery.of(context).size.width *
                                        0.08,
                                    color: '35A29F'.toColor(),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  Text(
                                    quantity == 1
                                        ? '$quantity ITEM ADDED'
                                        : '$quantity ITEMS ADDED',
                                    style: GoogleFonts.lato(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        color: 'F1F6F9'.toColor(),
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: '212A3E'.toColor()),
                                  onPressed: () async {
                                    print(
                                        'LENGTH OF THE CART ITEMS ${cartItems.length}');
                                    bool response = await ClothesService()
                                        .placeOrder(cartItems);
                                    if (response) {
                                      setState(() {
                                        cartItems.clear();
                                        clothes!.forEach((element) {
                                          element.quantity = null;
                                        });
                                        quantity = 0;
                                      });
                                      Fluttertoast.showToast(
                                        backgroundColor: Colors.green,
                                        msg: "Your order has been placed !",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.02),
                                    child: Text(
                                      'Proceed',
                                      style: GoogleFonts.lato(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          color: 'F1F6F9'.toColor(),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    )
                  ]
                ],
              ),
      ),
    );
  }
}
