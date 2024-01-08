// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:convert';

import 'package:connectnwash/extentions/extentions.dart';
import 'package:connectnwash/models/addressmodel.dart';
import 'package:connectnwash/models/customersmodel.dart';
import 'package:connectnwash/screens/profilescreen.dart';
import 'package:connectnwash/variables/variables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class Orderindiscreen extends StatefulWidget {
  Orderindiscreen(
      {required this.addressid,
      required this.custid,
      required this.time,
      required this.date,
      required this.empid,
      required this.id,
      required this.items,
      required this.status,
      required this.totalcost,
      required this.datetime,
      super.key});

  String id;
  String addressid;
  String custid;
  String empid;
  List<String> items;
  int status;
  String time;
  String date;
  int totalcost;
  DateTime datetime;
  @override
  State<Orderindiscreen> createState() => OrderindiscreenState();
}

class OrderindiscreenState extends State<Orderindiscreen> {
  bool _addressloaded = false;
  bool _customerloaded = false;
  List<AddressModel>? address;
  List<Findcust>? customer;
  List<String> statusses = [
    "",
    "Ordered",
    "Accepted",
    "Picked up",
    "Washed",
    "Delivered"
  ];
  getaddress() async {
    String baseuri = Variables().baseuri;
    var empclient = http.Client();
    var empuri = Uri.parse("${baseuri}getaddressid");
    var empresponse = await empclient.post(empuri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": widget.addressid}));
    var empjson = empresponse.body;
    address = addressModelFromJson(empjson);
    setState(() {
      _addressloaded = true;
    });
  }

  getcustomer() async {
    String baseuri = Variables().baseuri;
    var empclient = http.Client();
    var empuri = Uri.parse("${baseuri}searchempid");
    var empresponse = await empclient.post(empuri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": widget.empid}));
    var empjson = empresponse.body;
    customer = findcustFromJson(empjson);
    setState(() {
      _customerloaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getaddress();
    getcustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: 'D2E0FB'.toColor(),
      appBar: AppBar(
        backgroundColor: '2E4374'.toColor(),
        // title: Text(widget.id),
      ),
      body: (_addressloaded && _customerloaded)
          ? SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.01,
                  MediaQuery.of(context).size.height * 0.03,
                  MediaQuery.of(context).size.width * 0.01,
                  MediaQuery.of(context).size.height * 0.2),
              child: Center(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.time,
                        style: GoogleFonts.lato(
                            color: '1B262C'.toColor(),
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                      Text(widget.date,
                          style: GoogleFonts.lato(
                              color: '1B262C'.toColor(),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04))
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    "Service Partner Details",
                    style: GoogleFonts.lato(
                        color: '0C356A'.toColor(),
                        fontSize: MediaQuery.of(context).size.width * 0.08),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    customer![0].gender == 1
                        ? "Mr.${customer![0].name}"
                        : "Mrs.${customer![0].name}",
                    style: GoogleFonts.roboto(
                        color: '1B262C'.toColor(),
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  TextButton(
                    onPressed: () async {
                      final Uri _url = Uri.parse(
                          "https://maps.google.com/?q=<${address![0].latitude}>,<${address![0].longitude}>");
                      await launchUrl(_url);
                    },
                    child: Text(
                      "${address![0].address}, ${address![0].city} - ${address![0].pincode}",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.roboto(
                          height: 1.7,
                          color: '071952'.toColor(),
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final Uri _phoneUri =
                          Uri(scheme: "tel", path: '+91${customer![0].mobile}');
                      await launchUrl(_phoneUri);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Icon(
                          Icons.phone,
                          color: '071952'.toColor(),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(
                          customer![0].mobile.toString(),
                          style: GoogleFonts.roboto(
                              height: 1.7,
                              color: '071952'.toColor(),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        )
                      ],
                    ),
                  ),
                  Text(
                    'Status :  ${statusses[widget.status]}',
                    style: GoogleFonts.roboto(
                        height: 1.7,
                        color: '0B666A'.toColor(),
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  if (widget.status == 1) ...[
                    ElevatedButton(
                        onPressed: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              backgroundColor: '1B262C'.toColor(),
                              title: Text('Assign new employee',
                                  style: GoogleFonts.roboto(
                                      color: 'EEEEEE'.toColor())),
                              content: Text(
                                  'Order might get cancelled if no new employee is available',
                                  style: GoogleFonts.roboto(
                                      color: 'EEEEEE'.toColor())),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.roboto(
                                        color: 'EEEEEE'.toColor()),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    String baseuri = Variables().baseuri;
                                    var empclient = http.Client();
                                    var empuri =
                                        Uri.parse("${baseuri}assignnew");
                                    // ignore: unused_local_variable
                                    var empresponse = await empclient.post(
                                        empuri,
                                        headers: {
                                          "Content-Type": "application/json"
                                        },
                                        body: jsonEncode({"id": widget.id}));
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfileScreen()));
                                  },
                                  child: Text('Assign new',
                                      style: GoogleFonts.roboto(
                                          color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: '0F4C75'.toColor()),
                        child: const Text('Assign new Service Provider'))
                  ],
                  if (widget.status == 1) ...[
                    ElevatedButton(
                        onPressed: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              backgroundColor: '1B262C'.toColor(),
                              title: Text('Cancelling Order',
                                  style: GoogleFonts.roboto(
                                      color: 'EEEEEE'.toColor())),
                              content: Text(
                                  'Are you sure to Cancel this Order?',
                                  style: GoogleFonts.roboto(
                                      color: 'EEEEEE'.toColor())),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.roboto(
                                        color: 'EEEEEE'.toColor()),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    String baseuri = Variables().baseuri;
                                    var addressclient = http.Client();
                                    var addressuri =
                                        Uri.parse("${baseuri}editorder");
                                    var addressResponse =
                                        await addressclient.post(addressuri,
                                            headers: {
                                              "Content-Type": "application/json"
                                            },
                                            body: jsonEncode({
                                              "id": widget.id,
                                              "Custid": widget.custid,
                                              "Addid": widget.addressid,
                                              "items": widget.items,
                                              "cost": widget.totalcost,
                                              "empid": '0',
                                              "status": 6,
                                              "datetime":
                                                  widget.datetime.toString()
                                            }));
                                    var addressJson =
                                        addressResponse.statusCode;
                                    if (addressJson == 201) {
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProfileScreen()));
                                    }
                                  },
                                  child: Text('Proceed',
                                      style: GoogleFonts.roboto(
                                          color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: 'D71313'.toColor()),
                        child: const Text('Cancel Order'))
                  ]
                ],
              )),
            )
          : Center(child: CircularProgressIndicator(color: '213555'.toColor())),
    );
  }
}
