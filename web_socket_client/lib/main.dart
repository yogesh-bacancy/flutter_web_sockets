import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.7.65:8080'),
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Crypto Tracker'),
        ),  
        body: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> body = jsonDecode(snapshot.data);
              return ListView.builder(
                itemCount: body.length,
                itemBuilder: (context, index) => ListTile(
                  leading: Text(
                    body[index]["symbol"],
                  ),
                  title: Text(
                    body[index]["name"],
                  ),
                  trailing: Text(
                    '₹${body[index]["price"]}',
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error Connecting Stream: ${snapshot.error.toString()}',
                ),
              );
            } else {
              return const Center(
                child: Text('Waiting for updates...'),
              );
            }
          },
        ),
      ),
    );
  }
}
