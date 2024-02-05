import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print('WebSocket server listening on ${server.address}:${server.port}');

  await for (var request in server) {
    WebSocketTransformer.upgrade(request).then(
      (webSocket) async {
        print('Client connected');
        // Fetch initial cryptocurrency prices with a delay of 3 seconds to show loading
        await Future.delayed(
          Duration(seconds: 3),
        );
        List<Map<String, dynamic>> initialPrices = generateRandomPrices();
        webSocket.add(
          jsonEncode(initialPrices),
        );
        // Set up a timer to update prices every second
        Timer.periodic(
          Duration(seconds: 1),
          (timer) {
            List<Map<String, dynamic>> updatedPrices = generateRandomPrices();
            webSocket.add(
              jsonEncode(updatedPrices),
            );
          },
        );
        webSocket.listen(
          (data) {
            // You can add custom logic for handling client messages here
            print('Received data: $data');
          },
          onDone: () {
            print('Client disconnected');
          },
        );
      },
    );
  }
}

List<Map<String, dynamic>> generateRandomPrices() {
  final List<String> cryptocurrencies = [
    'Bitcoin',
    'Ethereum',
    'Ripple',
    'Litecoin',
    'Cardano'
  ];
  final Random random = Random();

  List<Map<String, dynamic>> prices = cryptocurrencies.map(
    (crypto) {
      // Random price between 100 and 200
      double price = 100.0 + random.nextDouble() * 100.0;
      return {
        'name': crypto,
        'symbol': crypto.substring(0, 3),
        'price': price.toStringAsFixed(2)
      };
    },
  ).toList();

  return prices;
}
