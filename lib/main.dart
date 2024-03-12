// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';
import 'dart:convert';
import 'package:connectnwash/Models/customersmodel.dart';
import 'package:connectnwash/Screens/mainscreen.dart';
import 'package:connectnwash/Variables/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? _id;
  @override
  void initState() {
    super.initState();
    getid();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  _id == null ? const HomeScreen() : const Mainscreen()));
    });
  }

  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _id = prefs.getString('CNWUid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xff053b50),
                Color(0xff176b87),
                Color(0xff64ccc5),
                // Color(0xffeeeeee),
              ]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/CNWlogo.png',
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController numcontroll = TextEditingController();
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //width: double.infinity,
        //height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xffffc7c7),
              Color(0xffffe2e2),
              // Color(0xfff6f6f6),
              Color(0xff8785a2),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.05,
            MediaQuery.of(context).size.height * 0.1,
            MediaQuery.of(context).size.width * 0.05,
            MediaQuery.of(context).size.height * 0.1,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  DateTime.now().hour < 12 && DateTime.now().hour > 3
                      ? "Good Morning Connectables,"
                      : DateTime.now().hour < 17
                          ? "Good Afternoon Connectables"
                          : "Good evening Connectables",
                  style: GoogleFonts.satisfy(
                    color: const Color(0xff0f2c59),
                    fontSize: MediaQuery.of(context).size.width * 0.08,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/India.png',
                                width: MediaQuery.of(context).size.width * 0.07,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              Text(
                                '+91',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextField(
                        decoration: InputDecoration(
                          counterText: '',
                          suffixIcon: _isloading
                              ? Transform.scale(
                                  scale: 0.5,
                                  child: const CircularProgressIndicator(
                                    color: Color(0xff0f2c59),
                                  ),
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.chevron_right_sharp,
                                    color: Color(0xff0f2c59),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _isloading = true;
                                    });
                                    if (numcontroll.text.length != 10) {
                                      setState(() {
                                        _isloading = false;
                                      });
                                      Fluttertoast.showToast(
                                          msg:
                                              "Please Enter a valid mobile number",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER);
                                    } else {
                                      String baseuri = Variables().baseuri;
                                      var empclient = http.Client();
                                      var empuri =
                                          Uri.parse("${baseuri}searchuser");
                                      var empresponse = await empclient.post(
                                          empuri,
                                          headers: {
                                            "Content-Type": "application/json"
                                          },
                                          body: jsonEncode({
                                            "Mobile":
                                                int.parse(numcontroll.text.trim())
                                          }));
                                      var empjson = empresponse.body;
                                      List<Findcust> empdet =
                                          findcustFromJson(empjson);
                                      if (empdet.isNotEmpty) {
                                        SharedPreferences prefs =
                                            await SharedPreferences.getInstance();
                                        prefs.setInt('CNWUpno',
                                            int.parse(numcontroll.text.trim()));
                                        prefs.setString('CNWUid', empdet[0].id!);
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Mainscreen(),
                                          ),
                                        );
                                      } else {
                                        setState(() {
                                          _isloading = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg:
                                                "Mobile number not registered with us",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER);
                                      }
                                    }
                                  },
                                ),
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                            borderSide: new BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          hintText: 'Mobile Number',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        controller: numcontroll,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
