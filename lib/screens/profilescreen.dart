import 'dart:convert';
import 'package:connectnwash/extentions/extentions.dart';
import 'package:connectnwash/models/customersmodel.dart';
import 'package:connectnwash/models/ordersmodel.dart';
import 'package:connectnwash/screens/ordersindiscreen.dart';
import 'package:connectnwash/variables/variables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool profloaded = false;
  String? custid;
  int? custnumb;
  List<Findcust>? customer;
  List<OrdersModel>? orders;
  bool ordersloaded = false;
  bool pending = true;
  @override
  void initState() {
    super.initState();
    getaddresses();
  }

  getaddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    custid = prefs.getString('CNWUid');
    custnumb = prefs.getInt('CNWUpno');
    String baseuri = Variables().baseuri;
    var empclient = http.Client();
    var empuri = Uri.parse("${baseuri}searchuserid");
    var empresponse = await empclient.post(empuri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": custid}));
    var empjson = empresponse.body;
    customer = findcustFromJson(empjson);

    setState(() {
      profloaded = true;
    });
    getorders(custid);
  }

  getorders(custid) async {
    String baseuri = Variables().baseuri;
    var ordersClient = http.Client();
    var ordersUri = Uri.parse("${baseuri}getord");
    var ordersResponse = await ordersClient.post(ordersUri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"custid": custid}));
    var ordersJson = ordersResponse.body;
    orders = ordersModelFromJson(ordersJson);
    setState(() {
      ordersloaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: 'D2E0FB'.toColor(),
      appBar: AppBar(
        backgroundColor: '2E4374'.toColor(),
      ),
      body: profloaded
          ? Padding(
              padding: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height * 0.03, 0, 0),
              child: Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Card(
                          elevation: 40,
                          color: '002B5B'.toColor(),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topRight,
                                  colors: [
                                    '1B262C'.toColor(),
                                    '0F4C75'.toColor(),
                                    '3282B8'.toColor(),
                                    // 'BBE1FA'.toColor()
                                  ]),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width * 0.05,
                                  MediaQuery.of(context).size.height * 0.02,
                                  MediaQuery.of(context).size.width * 0.05,
                                  MediaQuery.of(context).size.height * 0.02),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: 'F8F6F4'.toColor(),
                                    radius:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: Text(
                                      customer![0].name![0],
                                      style: GoogleFonts.roboto(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.09,
                                          color: '1B262C'.toColor()),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          customer![0].name!,
                                          overflow: TextOverflow.clip,
                                          style: GoogleFonts.roboto(
                                              color: 'E3F4F4'.toColor(),
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        Text(
                                          customer![0].mobile!.toString(),
                                          overflow: TextOverflow.clip,
                                          style: GoogleFonts.roboto(
                                              color: 'E3F4F4'.toColor(),
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        Text(
                                          customer![0].email!,
                                          overflow: TextOverflow.clip,
                                          style: GoogleFonts.roboto(
                                              color: 'E3F4F4'.toColor(),
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              pending = true;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.02),
                              color: pending
                                  ? '04364A'.toColor()
                                  : 'EEEEEE'.toColor(),
                              child: Text('Pending',
                                  style: GoogleFonts.lato(
                                      color: pending
                                          ? 'DAFFFB'.toColor()
                                          : '04364A'.toColor()))),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              pending = false;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.02),
                              color: pending
                                  ? 'EEEEEE'.toColor()
                                  : '04364A'.toColor(),
                              child: Text(
                                'Completed',
                                style: GoogleFonts.lato(
                                    color: pending
                                        ? '04364A'.toColor()
                                        : 'DAFFFB'.toColor()),
                              )),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  ordersloaded
                      ? Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.fromLTRB(
                                  MediaQuery.of(context).size.width * 0.01,
                                  0,
                                  MediaQuery.of(context).size.width * 0.01,
                                  MediaQuery.of(context).size.height * 0.2),
                              itemCount: orders!.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: ((context, index) {
                                List<Widget> itemslist = [];
                                List<String> statusses = [
                                  "",
                                  "Ordered",
                                  "Accepted",
                                  "Picked up",
                                  "Washed",
                                  "Delivered"
                                ];
                                for (int i = 0;
                                    i < orders![index].items.length;
                                    i = i + 1) {
                                  itemslist.add(Text(orders![index].items[i],
                                      style: GoogleFonts.roboto(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          color: 'F6F4EB'.toColor())));
                                  itemslist.add(SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ));
                                }
                                return ((pending &&
                                            orders![index].status != 5) ||
                                        (!pending &&
                                            orders![index].status == 5))
                                    ? Center(
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Orderindiscreen(
                                                            addressid:
                                                                orders![index]
                                                                    .addressid,
                                                            custid:
                                                                orders![index]
                                                                    .custid,
                                                            time:
                                                                '${orders![index].datetime.hour}:${orders![index].datetime.minute}',
                                                            date:
                                                                '${orders![index].datetime.day}/${orders![index].datetime.month}/${orders![index].datetime.year}',
                                                            empid:
                                                                orders![index]
                                                                    .empid,
                                                            id: orders![index]
                                                                .id,
                                                            items:
                                                                orders![index]
                                                                    .items,
                                                            status:
                                                                orders![index]
                                                                    .status,
                                                            totalcost:
                                                                orders![index]
                                                                    .totalcost,
                                                            datetime:
                                                                orders![index]
                                                                    .datetime,
                                                          )));
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Card(
                                                  elevation: 8,
                                                  shadowColor:
                                                      '071952'.toColor(),
                                                  margin: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05),
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                            begin: Alignment
                                                                .bottomCenter,
                                                            end: Alignment
                                                                .topRight,
                                                            colors: [
                                                          '04364A'.toColor(),
                                                          '176B87'.toColor(),
                                                          '64CCC5'.toColor()
                                                        ])),
                                                    padding: EdgeInsets.all(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "${orders![index].datetime.hour}:${orders![index].datetime.minute}",
                                                              style: GoogleFonts.roboto(
                                                                  color: 'DAFFFB'
                                                                      .toColor(),
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.04),
                                                            ),
                                                            Text(
                                                              "${orders![index].datetime.day}/${orders![index].datetime.month}/${orders![index].datetime.year}",
                                                              style: GoogleFonts.roboto(
                                                                  color: '04364A'
                                                                      .toColor(),
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.04),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                        ),
                                                        ExpansionTile(
                                                          collapsedIconColor:
                                                              'F6F4EB'
                                                                  .toColor(),
                                                          iconColor: 'F6F4EB'
                                                              .toColor(),
                                                          title: Text(
                                                            'Items',
                                                            style: GoogleFonts.roboto(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.04,
                                                                color: 'F6F4EB'
                                                                    .toColor()),
                                                          ),
                                                          children: itemslist,
                                                        ),
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Text(
                                                              statusses[
                                                                  orders![index]
                                                                      .status],
                                                              style: GoogleFonts.roboto(
                                                                  color: 'F1EFEF'
                                                                      .toColor(),
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.04),
                                                            ),
                                                            Text(
                                                              '₹${orders![index].totalcost}',
                                                              style: GoogleFonts.roboto(
                                                                  color: 'F1EFEF'
                                                                      .toColor(),
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.04),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container();
                              })),
                        )
                      : CircularProgressIndicator(
                          color: '35155D'.toColor(),
                        )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
              color: '35155D'.toColor(),
            )),
    );
  }
}
