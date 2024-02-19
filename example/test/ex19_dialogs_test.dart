import 'package:example/ex19_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:navigation_builder/navigation_builder.dart';

void main() {
  testWidgets(
    'Show hide dialog',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      await tester.tap(find.text('NO'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      //
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      navigator.back();
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    },
  );

  testWidgets(
    'Show hide dialog using BuildContext',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Show Dialog using BuildContext'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      await tester.tap(find.text('NO'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      //
      await tester.tap(find.text('Show Dialog using BuildContext'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      Navigator.of(NavigationBuilder.context!).pop();
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    },
  );

  testWidgets(
    'Show hide Cupertino Dialog',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Show Cupertino dialog'));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      await tester.tap(find.text('NO'));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsNothing);
      //
      await tester.tap(find.text('Show Cupertino dialog'));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      navigator.back();
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsNothing);
    },
  );

  testWidgets(
    'Show hide About Dialog',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Show About dialog'));
      await tester.pumpAndSettle();
      expect(find.byType(AboutDialog), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(AboutDialog), findsNothing);
      //
      await tester.tap(find.text('Show About dialog'));
      await tester.pumpAndSettle();
      expect(find.byType(AboutDialog), findsOneWidget);
      navigator.back();
      await tester.pumpAndSettle();
      expect(find.byType(AboutDialog), findsNothing);
    },
  );

  testWidgets(
    'Show hide Bottom sheet',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Show Bottom sheet'));
      await tester.pumpAndSettle();
      expect(find.text('This is a Bottom Sheet'), findsOneWidget);
      await tester.tap(find.text('CLOSE'));
      await tester.pumpAndSettle();
      expect(find.text('This is a Bottom Sheet'), findsNothing);
      //
      await tester.tap(find.text('Show Bottom sheet'));
      await tester.pumpAndSettle();
      expect(find.text('This is a Bottom Sheet'), findsOneWidget);
      navigator.back();
      await tester.pumpAndSettle();
      expect(find.text('This is a Bottom Sheet'), findsNothing);
    },
  );

  testWidgets(
    'Show hide Cupertino Modal Popup',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Show Cupertino Modal Popup'));
      await tester.pumpAndSettle();
      expect(find.text('This is Cupertino Modal Popup'), findsOneWidget);
      await tester.tap(find.text('CLOSE'));
      await tester.pumpAndSettle();
      expect(find.text('This is Cupertino Modal Popup'), findsNothing);
      //
      await tester.tap(find.text('Show Cupertino Modal Popup'));
      await tester.pumpAndSettle();
      expect(find.text('This is Cupertino Modal Popup'), findsOneWidget);
      navigator.back();
      await tester.pumpAndSettle();
      expect(find.text('This is Cupertino Modal Popup'), findsNothing);
    },
  );

  testWidgets(
    'Show hide SnackBar',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Show  SnackBar'));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      await tester.tap(find.text('HIDE'));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsNothing);
      //
      await tester.tap(find.text('Show  SnackBar'));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      navigator.scaffold.hideCurrentSnackBar();
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsNothing);
      //
      await tester.tap(find.text('Show  SnackBar'));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      navigator.scaffold.removeCurrentSnackBar();
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsNothing);
    },
  );

  testWidgets(
    'Show hide  Material banner',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Show  Material banner'));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialBanner), findsOneWidget);
      await tester.tap(find.text('CLOSE'));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialBanner), findsNothing);
      //
      await tester.tap(find.text('Show  Material banner'));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialBanner), findsOneWidget);
      navigator.scaffold.hideCurrentMaterialBanner();
      await tester.pumpAndSettle();
      expect(find.byType(MaterialBanner), findsNothing);
      //
      await tester.tap(find.text('Show  Material banner'));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialBanner), findsOneWidget);
      navigator.scaffold.removeCurrentMaterialBanner();
      await tester.pumpAndSettle();
      expect(find.byType(MaterialBanner), findsNothing);
    },
  );

  testWidgets(
    'Show hide persistent bottom sheet',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Show persistent bottom sheet'));
      await tester.pumpAndSettle();
      expect(find.text('This is persistent bottom sheet'), findsOneWidget);
      await tester.tap(find.text('CLOSE'));
      await tester.pumpAndSettle();
      expect(find.text('This is persistent bottom sheet'), findsNothing);
      //
      await tester.tap(find.text('Show persistent bottom sheet'));
      await tester.pumpAndSettle();
      expect(find.text('This is persistent bottom sheet'), findsOneWidget);
      navigator.back();
      await tester.pumpAndSettle();
      expect(find.text('This is persistent bottom sheet'), findsNothing);
    },
  );

  testWidgets(
    'Open close  Drawer',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Open Drawer'));
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsOneWidget);
      await tester.tap(find.text('Close Drawer using scaffold.closeDrawer'));
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsNothing);
      //
      await tester.tap(find.text('Open Drawer'));
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsOneWidget);
      await tester.tap(find.text('Close Drawer using back'));
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsNothing);
      //
      await tester.tap(find.text('Open Drawer'));
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsOneWidget);
      navigator.back();
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsNothing);
    },
  );

  testWidgets(
    'Open close end Drawer',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text('Open EndDrawer'));
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsOneWidget);
      await tester
          .tap(find.text('Close end Drawer using scaffold.closeDrawer'));
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsNothing);
      //
      await tester.tap(find.text('Open EndDrawer'));
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsOneWidget);
      await tester.tap(find.text('Close end Drawer using back'));
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsNothing);
      //
      await tester.tap(find.text('Open EndDrawer'));
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsOneWidget);
      navigator.back();
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsNothing);
    },
  );
}
