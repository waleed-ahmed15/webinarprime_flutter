import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeeksforGeeks',

      // to hide debug banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GeeksforGeeks'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => const FutureDemoPage(),
              ),
            ),
            child: const Text('Demonstrate FutureBuilder'),
          ),
        ),
      ),
    );
  }
}

class FutureDemoPage extends StatelessWidget {
  const FutureDemoPage({super.key});

  /// Function that will return a
  /// "string" after some time
  /// To demonstrate network call
  /// delay of [2 seconds] is used
  ///
  /// This function will behave as an
  /// asynchronous function
  Future<String> getData() async {
    print("Fetching data...");

    return "I am data${DateTime.now()}";
    // throw Exception("Custom Error");
  }

  @override
  Widget build(BuildContext context) {
    print('object');
    // Timer.periodic(const Duration(seconds: 1), (timer) {
    // getData();
    // });

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Future Demo Page'),
          ),
          body: FutureBuilder(
            future: getData(),
            key: const Key('futureBuilder'),
            builder: (ctx, snapshot) {
              print('inside builder');
              // Checking if future is resolved or not
              if (snapshot.connectionState == ConnectionState.done) {
                // If we got an error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error} occurred',
                      style: const TextStyle(fontSize: 18),
                    ),
                  );

                  // if we got our data
                } else if (snapshot.hasData) {
                  // Extracting data from snapshot object
                  final data = snapshot.data as String;
                  return Center(
                    child: Text(
                      data,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }
              }

              // Displaying LoadingSpinner to indicate waiting state
              return const Center(
                child: CircularProgressIndicator(),
              );
            },

            // Future that needs to be resolved
            // inorder to display something on the Canvas
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // getData();
              // Timer.periodic(const Duration(seconds: 1), (timer) {
              //   getData();
              // });
              getData();
            },
            child: const Icon(Icons.refresh),
          )),
    );
  }
}
