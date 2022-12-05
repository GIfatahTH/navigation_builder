import 'package:flutter/material.dart';
import 'package:navigation_builder/navigation_builder.dart';

final navigator = NavigationBuilder.create(
  builder: ((routerOutlet) => Scaffold(
        appBar: AppBar(),
        body: routerOutlet,
      )),
  routes: {
    '/': (data) => const MyHomePage(),
    '/page1': (data) => RouteWidget(
          builder: (outlet) {
            return Padding(
              padding: const EdgeInsets.all(80.0),
              child: Center(
                child: outlet,
              ),
            );
          },
          routes: {
            '/': (data) => const MyHomePage(),
            '/page11': (data) => Text('PAge11'),
          },
        )
  },
);

void main() {
  runApp(
    MaterialApp.router(
      routerDelegate: navigator.routerDelegate,
      routeInformationParser: navigator.routeInformationParser,
    ),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              navigator.toDialog(
                AlertDialog(
                  content: const Text('Are you sure?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // final nav = Navigator.of(context);
                        navigator.back();
                      },
                      child: const Text('NO'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Show Dialog'),
          ),
          ElevatedButton(
              onPressed: () => navigator.to('/page1'),
              child: Text('GO to page1'))
        ],
      ),
    );
  }
}
