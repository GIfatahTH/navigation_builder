// ignore_for_file: use_key_in_widget_constructors, file_names, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navigation_builder/navigation_builder.dart';
import 'package:states_rebuilder/scr/state_management/state_management.dart';

final _navigator = NavigationBuilder.create(routes: {
  '/': (data) {
    return Scaffold(
      key: NavigationBuilder.scaffoldKey,
      body: Builder(
        builder: (ctx) {
          context = ctx;
          return OnBuilder(listenTo: 0.inj(), builder: () => Container());
        },
      ),
      drawer: Text('Drawer'),
      endDrawer: Text('EndDrawer'),
    );
  },
  '/page2': (data) {
    return Scaffold(
      key: NavigationBuilder.scaffoldKey,
      body: Builder(
        builder: (ctx) {
          context = ctx;
          return OnBuilder(listenTo: 0.inj(), builder: () => Container());
        },
      ),
      drawer: Text('Drawer of page2'),
      endDrawer: Text('EndDrawer of page2'),
    );
  },
});
BuildContext? context;

void main() {
  setUp(() {
    context = null;
    RM.disposeAll();
  });
  testWidgets('Throw exception no scaffold', (tester) async {
    final widget = MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (ctx) {
            context = ctx;
            return Container();
          },
        ),
      ),
    );

    await tester.pumpWidget(widget);
    expect(() => NavigationBuilder.scaffold.scaffoldState, throwsException);
    expect(() => NavigationBuilder.scaffold.scaffoldMessengerState,
        throwsAssertionError);

    NavigationBuilder.scaffold.context = context!;
    expect(NavigationBuilder.scaffold.scaffoldState, isNotNull);
    expect(NavigationBuilder.scaffold.scaffoldMessengerState, isNotNull);
  });

  testWidgets('showBottomSheet', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerDelegate: _navigator.routerDelegate,
        routeInformationParser: _navigator.routeInformationParser,
      ),
    );
    NavigationBuilder.scaffold.showBottomSheet(
      Text('showBottomSheet'),
      backgroundColor: Colors.red,
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      shape: BorderDirectional(),
    );
    await tester.pumpAndSettle();
    expect(find.text('showBottomSheet'), findsOneWidget);
  });

  testWidgets('hideCurrentSnackBar', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerDelegate: _navigator.routerDelegate,
        routeInformationParser: _navigator.routeInformationParser,
      ),
    );
    NavigationBuilder.scaffold.showSnackBar(
        SnackBar(
          content: Text('showSnackBar'),
        ),
        hideCurrentSnackBar: false);
    await tester.pumpAndSettle();
    expect(find.text('showSnackBar'), findsOneWidget);
    NavigationBuilder.scaffold.hideCurrentSnackBar();
    await tester.pump();
    expect(find.text('showSnackBar'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('showSnackBar'), findsNothing);
  });

  testWidgets('removeCurrentSnackBarm', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerDelegate: _navigator.routerDelegate,
        routeInformationParser: _navigator.routeInformationParser,
      ),
    );
    NavigationBuilder.scaffold.showSnackBar(
        SnackBar(
          content: Text('showSnackBar'),
        ),
        hideCurrentSnackBar: false);
    await tester.pumpAndSettle();
    expect(find.text('showSnackBar'), findsOneWidget);
    NavigationBuilder.scaffold.removeCurrentSnackBarm();
    await tester.pump();
    expect(find.text('showSnackBar'), findsNothing);
  });

  testWidgets('openDrawer and openEndDrawer', (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routerDelegate: _navigator.routerDelegate,
      routeInformationParser: _navigator.routeInformationParser,
    ));
    NavigationBuilder.scaffold.openDrawer();
    await tester.pumpAndSettle();
    expect(find.text('Drawer'), findsOneWidget);
    NavigationBuilder.scaffold.openEndDrawer();
    await tester.pumpAndSettle();
    expect(find.text('EndDrawer'), findsOneWidget);
    //
    _navigator.to('/page2');
    await tester.pumpAndSettle();
  });
}
