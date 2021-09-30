import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:brother_printer/brother_printer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  List<BrotherDevice> _platformVersion = [];
  late Animation<double> _myAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _myAnimation = CurvedAnimation(curve: Curves.linear, parent: _controller);
    searchDevices();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> searchDevices() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    _controller.forward();
    try {
      _platformVersion = await BrotherPrinter.searchDevices();
    } on PlatformException {
      _platformVersion = [];
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            IconButton(
                onPressed: searchDevices,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.search_ellipsis,
                  progress: _myAnimation,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
              children: _platformVersion
                  .map((e) => ListTile(
                        title: Text(e.model.nameAndroid),
                        subtitle: Text(e.macAddress ?? ''),
                      ))
                  .toList()),
        ),
      ),
    );
  }
}
