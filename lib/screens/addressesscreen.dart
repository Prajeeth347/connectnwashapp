// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:convert';

import 'package:connectnwash/extentions/extentions.dart';
import 'package:connectnwash/models/addressmodel.dart';
import 'package:connectnwash/screens/mainscreen.dart';
import 'package:connectnwash/variables/variables.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  AddressScreen({required this.custid, super.key});
  String custid;
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  List<AddressModel>? adddet;
  int? addindex;
  bool addloaded = false;
  @override
  void initState() {
    super.initState();
    getaddresses();
  }

  getaddresses() async {
    String baseuri = Variables().baseuri;
    var empclient = http.Client();
    var empuri = Uri.parse("${baseuri}getaddress");
    var empresponse = await empclient.post(empuri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"Custid": widget.custid}));
    setState(() {
      addloaded = true;
    });
    var empjson = empresponse.body;
    adddet = addressModelFromJson(empjson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: 'D2E0FB'.toColor(),
      appBar: AppBar(
        backgroundColor: '2E4374'.toColor(),
      ),
      body: addloaded
          ? ListView.builder(
              itemCount: adddet!.length,
              itemBuilder: ((context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setInt('addindex', index);
                        Navigator.pop(context);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const Mainscreen()));
                      },
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              color: '0F4C75'.toColor(),
                              child: Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.04),
                                child: Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.mapLocation,
                                      color: 'BBE1FA'.toColor(),
                                      size: MediaQuery.of(context).size.width *
                                          0.1,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            adddet![index].address,
                                            overflow: TextOverflow.clip,
                                            style: GoogleFonts.roboto(
                                                color: 'F1F6F9'.toColor(),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.015,
                                          ),
                                          Text(
                                            "${adddet![index].city} - ${adddet![index].pincode}",
                                            overflow: TextOverflow.clip,
                                            style: GoogleFonts.roboto(
                                                color: 'F1F6F9'.toColor(),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.025,
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              onPressed: () {
                                                Fluttertoast.showToast(
                                                  backgroundColor: Colors.red,
                                                  msg:
                                                      "Account delete request has been send",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                );
                                              },
                                              child: Text(
                                                'Delete',
                                                style: GoogleFonts.roboto(),
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )),
                    )
                  ],
                );
              }))
          : Center(
              child: CircularProgressIndicator(
                color: '35155D'.toColor(),
              ),
            ),
    );
  }
}
