import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Locationnotenabled extends StatefulWidget {
  const Locationnotenabled({super.key});

  @override
  State<Locationnotenabled> createState() => LocationnotenabledState();
}

class LocationnotenabledState extends State<Locationnotenabled> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Please enable the location'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          ElevatedButton(
              onPressed: () {
                Geolocator.requestPermission();
              },
              child: const Text('Enable location'))
        ],
      )),
    );
  }
}
