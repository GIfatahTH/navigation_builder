import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigation_builder/navigation_builder.dart';

final navigator = NavigationBuilder.create(
  routes: {
    '/': (data) => const MyHomePage(),
  },
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: navigator.routerConfig,
    );
  }
}

class MyHomePageViewModel {
  void showDialogWithoutTheNeedOfBuildContext() {
    navigator.toDialog(
      AlertDialog(
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () {
              navigator.back();
            },
            child: const Text('NO'),
          ),
        ],
      ),
    );
  }

  void showDialogUsingNavigationBuilderBuildContext() {
    showDialog(
        context: navigator.navigationContext!,
        builder: (context) {
          return AlertDialog(
            content: const Text('Are you sure?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(navigator.navigationContext!).pop();
                },
                child: const Text('NO'),
              ),
            ],
          );
        });
  }

  void showBottomSheet() {
    navigator.toBottomSheet(
      ColoredBox(
        color: Colors.amber,
        child: SizedBox(
          height: 150,
          width: double.infinity,
          child: Column(
            children: [
              const Text('This is a Bottom Sheet'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  navigator.back();
                },
                child: const Text('CLOSE'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCupertionDialog() {
    navigator.toCupertinoDialog(
      CupertinoAlertDialog(
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () {
              navigator.back();
            },
            child: const Text('NO'),
          ),
        ],
      ),
    );
  }

  void showCupertinoModalPopup() {
    navigator.toCupertinoModalPopup(
      ColoredBox(
        color: Colors.amber,
        child: Material(
          child: SizedBox(
            height: 150,
            width: double.infinity,
            child: Column(
              children: [
                const Text('This is Cupertino Modal Popup'),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    navigator.back();
                  },
                  child: const Text('CLOSE'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showAboutDialogWithoutBuildContext() {
    showAboutDialog(
      context: NavigationBuilder.context!,
      applicationName: 'Navigation builder',
    );
  }

  // Scaffold related pop ups
  void showPersistentBottomSheet() {
    navigator.scaffold.showBottomSheet(
      BottomSheet(
        onClosing: () {},
        builder: (context) {
          return ColoredBox(
            color: Colors.amber,
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: Column(
                children: [
                  const Text('This is persistent bottom sheet'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      navigator.back();
                    },
                    child: const Text('CLOSE'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void openDrawer() {
    navigator.scaffold.openDrawer();
  }

  void openEndDrawer() {
    navigator.scaffold.openEndDrawer();
  }

  void showSnackBar() {
    navigator.scaffold.showSnackBar(
      SnackBar(
        content: const Text('HI'),
        action: SnackBarAction(
          label: 'HIDE',
          onPressed: () => navigator.scaffold.hideCurrentSnackBar(),
        ),
      ),
    );
  }

  void showMaterialBanner() {
    navigator.scaffold.showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.amber,
        content: const Text('Material Banner'),
        actions: [
          TextButton(
            onPressed: () => navigator.scaffold.removeCurrentMaterialBanner(),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }
}

final myHomePageViewModel = MyHomePageViewModel();

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('Dialogs and bottom sheets'),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: myHomePageViewModel
                        .showDialogWithoutTheNeedOfBuildContext,
                    child: const Text('Show Dialog'),
                  ),
                  ElevatedButton(
                    onPressed: myHomePageViewModel
                        .showDialogUsingNavigationBuilderBuildContext,
                    child: const Text('Show Dialog using BuildContext'),
                  ),
                  ElevatedButton(
                    onPressed: myHomePageViewModel.showCupertionDialog,
                    child: const Text('Show Cupertino dialog'),
                  ),
                  ElevatedButton(
                    onPressed:
                        myHomePageViewModel.showAboutDialogWithoutBuildContext,
                    child: const Text('Show About dialog'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: myHomePageViewModel.showBottomSheet,
                    child: const Text('Show Bottom sheet'),
                  ),
                  ElevatedButton(
                    onPressed: myHomePageViewModel.showCupertinoModalPopup,
                    child: const Text('Show Cupertino Modal Popup'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Scaffold related popups'),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: myHomePageViewModel.showSnackBar,
                    child: const Text('Show  SnackBar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      myHomePageViewModel.showMaterialBanner();
                    },
                    child: const Text('Show  Material banner'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      navigator.scaffold.context = context;
                      myHomePageViewModel.showPersistentBottomSheet();
                    },
                    child: const Text('Show persistent bottom sheet'),
                  );
                },
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          navigator.scaffold.context = context;
                          myHomePageViewModel.openDrawer();
                        },
                        child: const Text('Open Drawer'),
                      );
                    },
                  ),
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          navigator.scaffold.context = context;
                          myHomePageViewModel.openEndDrawer();
                        },
                        child: const Text('Open EndDrawer'),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => navigator.scaffold.closeDrawer(),
              child: const Text('Close Drawer using scaffold.closeDrawer'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => navigator.back(),
              child: const Text('Close Drawer using back'),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => navigator.scaffold.closeDrawer(),
              child: const Text('Close end Drawer using scaffold.closeDrawer'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => navigator.back(),
              child: const Text('Close end Drawer using back'),
            ),
          ],
        ),
      ),
    );
  }
}
