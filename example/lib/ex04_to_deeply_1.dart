import 'package:flutter/material.dart';
import 'package:navigation_builder/navigation_builder.dart';

// This example show the difference between NavigationBuilder.to and
// NavigationBuilder.toDeeply methods
void main() {
  NavigationBuilder.transitionsBuilder = NavigationBuilder.transitions
      .bottomToUp(duration: const Duration(milliseconds: 3000));
  runApp(const MyApp());
}

final NavigationBuilder navigator = NavigationBuilder.create(
  builder: (routerOutlet) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: routerOutlet, // The routes are displayed here
          //
          // This FloatingActionButton is always displayed above routes
          floatingActionButton: FloatingActionButton(
            onPressed: () => navigator.toAndRemoveUntil('/'),
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
            child: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        );
      },
    );
  },
  routes: {
    '/': (data) => const HomePage(),
    '/page1': (data) => const PageWidget(title: 'Page1'),
    '/page1/page11': (data) => const PageWidget(title: 'Page1/Page11'),
    '/page1/page11/page111': (data) => const PageWidget(
          title: 'Page1/Page11/Page111',
        ),
    '/page1/page11/page111/page1111': (data) => const PageWidget(
          title: 'Page1/Page11/Page111/Page1111',
        ),
  },
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Books App',
      routerConfig: navigator.routerConfig,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => navigator.to(
                '/page1/page11/page111/page1111',
              ),
              child: const Text('Navigate using "to"'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => navigator.toDeeply(
                '/page1/page11/page111/page1111',
              ),
              child: const Text('Navigate using "toDeeply"'),
            ),
          ],
        ),
      ),
    );
  }
}

class PageWidget extends StatelessWidget {
  const PageWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(title),
      ),
    );
  }
}
