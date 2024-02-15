part of 'navigation_builder.dart';

final scaffoldObject = ScaffoldObject();

class ScaffoldObject {
  NavigationBuilder? _mock;

  BuildContext? _context;

  /// The closest [ScaffoldMessengerState ]
  ScaffoldMessengerState get scaffoldMessengerState {
    final ctx = _context ?? navigateObject.navigatorState.context;
    return ScaffoldMessenger.of(ctx);
  }

  /// The closest [ScaffoldState]
  ScaffoldState get scaffoldState {
    final ctx = _context;
    if (ctx == null) {
      throw Exception(
        '''
No valid BuildContext is defined yet

  Before calling any method a decedent BuildContext of Scaffold must be set.
  This can be done this way:
  
   ```dart
     onPressed: (){
      myNavigator.scaffold.context= context;
      myNavigator.scaffold.showBottomSheet(...);
     }
    ```
 
''',
      );
    }
    return Scaffold.of(ctx);
  }

  BuildContext get context {
    if (_context == null) {
      throw Exception(
        '''
No valid BuildContext is defined yet

  Before calling any method a decedent BuildContext of Scaffold must be set.
  This can be done this way:
  
   ```dart
     onPressed: (){
      myNavigator.scaffold.context= context;
      myNavigator.scaffold.showBottomSheet(...);
     }
    ```
 
''',
      );
    }
    return _context!;
  }

  set context(BuildContext context) => _context = context;

  /// Shows a material design persistent bottom sheet in the nearest [Scaffold].
  ///
  /// The new bottom sheet becomes a [LocalHistoryEntry] for the enclosing
  /// [ModalRoute] and a back button is added to the app bar of the [Scaffold]
  /// that closes the bottom sheet.
  ///
  /// To create a persistent bottom sheet that is not a [LocalHistoryEntry] and
  /// does not add a back button to the enclosing Scaffold's app bar, use the
  /// [scaffold.showBottomSheet] constructor parameter.
  ///
  /// A closely related widget is a modal bottom sheet, which is an alternative
  /// to a menu or a dialog and prevents the user from interacting with the
  /// rest of the app. Modal bottom sheets can be created and displayed with
  /// the [_Navigate.toBottomSheet] or [showModalBottomSheet] Methods.
  ///
  /// Returns a controller that can be used to close and otherwise manipulate
  /// the bottom sheet.
  ///
  ///
  /// * Required parameters:
  ///  * [bottomSheet]:  (positional parameter) Widget to display.
  /// * optional parameters:
  ///  * [backgroundColor], [elevation], [shape], and [clipBehavior] : used to
  /// customize the appearance and behavior of bottom sheet
  ///
  /// To close the bottomSheet just call the [NavigationBuilder.back] method
  ///
  /// Equivalent to: [ScaffoldState.showBottomSheet].
  ///
  /// Before calling any method a decedent BuildContext of Scaffold must be set.
  /// This can be done :
  ///
  /// ```dart
  ///   onPressed: (){
  ///    myNavigator.scaffold.context= context;
  ///    myNavigator.scaffold.showBottomSheet(...);
  ///   }
  ///  ```
  PersistentBottomSheetController showBottomSheet(
    Widget bottomSheet, {
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    bool? enableDrag,
    AnimationController? transitionAnimationController,
  }) {
    if (_mock != null) {
      return _mock!.scaffold.showBottomSheet(
        bottomSheet,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        constraints: constraints,
        enableDrag: enableDrag,
        transitionAnimationController: transitionAnimationController,
      );
    }
    final r = scaffoldState.showBottomSheet(
      (_) => bottomSheet,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      enableDrag: enableDrag,
      transitionAnimationController: transitionAnimationController,
    );
    _context = null;

    return r;
  }

  /// Shows a [SnackBar] at the bottom of the scaffold.
  ///
  /// By default any current SnackBar will be hidden.
  ///
  /// * Required parameters:
  ///  * [snackBar]:  (positional parameter) The SnackBar to display.
  /// * optional parameters:
  ///  * [hideCurrentSnackBar]: Whether to hide the current SnackBar (if any).
  /// Default value is true.
  ///
  /// Equivalent to: [ScaffoldMessengerState.showSnackBar].
  ///
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar<T>(
    SnackBar snackBar, {
    bool hideCurrentSnackBar = true,
  }) {
    if (_mock != null) {
      return _mock!.scaffold
          .showSnackBar(snackBar, hideCurrentSnackBar: hideCurrentSnackBar);
    }

    if (hideCurrentSnackBar) {
      scaffoldMessengerState.hideCurrentSnackBar();
    }
    final r = scaffoldMessengerState.showSnackBar(snackBar);
    _context = null;
    return r;
  }

  /// Removes the current [SnackBar] by running its normal exit animation.
  ///
  /// Similar to [ScaffoldMessengerState.hideCurrentSnackBar].
  void hideCurrentSnackBar({
    SnackBarClosedReason reason = SnackBarClosedReason.hide,
  }) {
    if (_mock != null) {
      return _mock!.scaffold.hideCurrentSnackBar(reason: reason);
    }

    scaffoldMessengerState.hideCurrentSnackBar(reason: reason);
  }

  /// Removes the current [SnackBar] (if any) immediately from
  /// registered [Scaffold]s.
  ///
  /// Similar to [ScaffoldMessengerState.removeCurrentSnackBar].
  void removeCurrentSnackBar({
    SnackBarClosedReason reason = SnackBarClosedReason.remove,
  }) {
    if (_mock != null) {
      return _mock!.scaffold.removeCurrentSnackBar(reason: reason);
    }
    scaffoldMessengerState.removeCurrentSnackBar(reason: reason);
  }

  /// Shows a [MaterialBanner] across all registered [Scaffold]s.

  ///
  /// By default any current MaterialBanner will be hidden.
  ///
  /// * Required parameters:
  ///  * [materialBanner]:  (positional parameter) The MaterialBanner to display.
  /// * optional parameters:
  ///  * [hideCurrentMaterialBanner]: Whether to hide the current MaterialBanner (if any).
  /// Default value is true.
  ///
  /// Equivalent to: [ScaffoldMessengerState.showMaterialBanner].
  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>
      showMaterialBanner(
    MaterialBanner materialBanner, {
    bool hideCurrentMaterialBanner = true,
  }) {
    if (_mock != null) {
      return _mock!.scaffold.showMaterialBanner(
        materialBanner,
        hideCurrentMaterialBanner: hideCurrentMaterialBanner,
      );
    }

    if (hideCurrentMaterialBanner) {
      scaffoldMessengerState.hideCurrentMaterialBanner();
    }
    final r = scaffoldMessengerState.showMaterialBanner(materialBanner);
    _context = null;
    return r;
  }

  /// Removes the current [MaterialBanner] by running its normal exit animation.
  ///
  /// Similar to [ScaffoldMessengerState.hideCurrentMaterialBanner].
  void hideCurrentMaterialBanner({
    MaterialBannerClosedReason reason = MaterialBannerClosedReason.hide,
  }) {
    if (_mock != null) {
      return _mock!.scaffold.hideCurrentMaterialBanner(reason: reason);
    }
    scaffoldMessengerState.hideCurrentMaterialBanner(reason: reason);
  }

  /// Removes the current [MaterialBanner] (if any) immediately from
  /// registered [Scaffold]s.
  ///
  /// Similar to [ScaffoldMessengerState.removeCurrentMaterialBanner].
  void removeCurrentMaterialBanner({
    MaterialBannerClosedReason reason = MaterialBannerClosedReason.hide,
  }) {
    if (_mock != null) {
      return _mock!.scaffold.removeCurrentMaterialBanner(reason: reason);
    }
    scaffoldMessengerState.removeCurrentMaterialBanner(reason: reason);
  }

  /// Opens the [Drawer] (if any).
  ///
  /// Before calling any method a decedent BuildContext of Scaffold must be set.
  /// This can be done either:
  ///
  /// To close the drawer just call the [NavigationBuilder.back] method
  ///
  /// Equivalent to: [ScaffoldState.openDrawer].
  ///
  /// Before calling any method a decedent BuildContext of Scaffold must be set.
  /// This can be done :
  ///
  /// * ```dart
  ///   onPressed: (){
  ///    myNavigator.scaffold.context= context;
  ///    myNavigator.scaffold.openDrawer();
  ///   }
  ///  ```
  void openDrawer<T>() {
    if (_mock != null) {
      return _mock!.scaffold.openDrawer();
    }
    scaffoldState.openDrawer();
    _context = null;
  }

  /// Close the Drawer if it is opened.
  ///
  /// You can close the drawer by just calling [NavigationBuilder.back]
  void closeDrawer<T>() {
    if (_mock != null) {
      return _mock!.scaffold.closeDrawer();
    }
    RouterObjects.navigationBuilder?.back();

    _context = null;
  }

  /// Opens the end side [Drawer] (if any).
  ///
  /// Before calling any method a decedent BuildContext of Scaffold must be set.
  /// This can be done either:
  ///
  /// To close the end drawer just call the [NavigationBuilder.back] method
  ///
  /// Equivalent to: [ScaffoldState.openEndDrawer].
  ///
  /// Before calling any method a decedent BuildContext of Scaffold must be set.
  /// This can be done :
  /// ```dart
  ///   onPressed: (){
  ///    myNavigator.scaffold.context= context;
  ///    myNavigator.scaffold.openEndDrawer();
  ///   }
  ///  ```

  void openEndDrawer<T>() {
    if (_mock != null) {
      return _mock!.scaffold.openEndDrawer();
    }
    scaffoldState.openEndDrawer();
    _context = null;
  }

  /// Close the EndDrawer if it is opened.
  ///
  /// You can close the EndDrawer by just calling [NavigationBuilder.back]
  void closeEndDrawer<T>() {
    if (_mock != null) {
      return _mock!.scaffold.closeEndDrawer();
    }
    scaffoldState.closeEndDrawer();
    _context = null;
  }

  void dispose() {
    _context = null;
  }
}
