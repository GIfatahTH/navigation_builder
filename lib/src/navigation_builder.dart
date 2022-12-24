// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common/logger.dart';

part 'build_context_x.dart';
part 'navigator2/on_navigate_back_scope.dart';
part 'navigator2/page_settings.dart';
part 'navigator2/route_information_parser.dart';
part 'navigator2/router_delegate.dart';
part 'navigator2/router_objects.dart';
part 'page_route_builder.dart';
part 'rm_navigator.dart';
part 'rm_resolve_path_route_util.dart';
part 'rm_scaffold.dart';
part 'route_data.dart';
part 'route_full_widget.dart';
part 'route_widget.dart';
part 'sub_route.dart';
part 'transitions.dart';

///{@template NavigationBuilder}
/// Injecting a Navigator 2 that holds a [RouteData] state.
///
/// ```dart
///  final myNavigator = NavigationBuilder.create(
///    routes: {
///      '/': (RouteData data) => HomePage(),
///      '/page1': (RouteData data) => Page1(),
///    },
///  );
///
///  class MyApp extends StatelessWidget {
///    const MyApp({Key? key}) : super(key: key);
///
///    @override
///    Widget build(BuildContext context) {
///      return MaterialApp.router(
///        routeInformationParser: myNavigator.routeInformationParser,
///        routerDelegate: myNavigator.routerDelegate,
///      );
///    }
///  }
/// ```
///
/// See also [RouteData] and [RouteWidget]
/// {@endtemplate}
abstract class NavigationBuilder {
  static NavigationBuilder create({
    //ORDER OF routes is important (/signin, /) home is not used even if skipHome slash is false
    required Map<String, Widget Function(RouteData data)> routes,
    String? initialLocation,
    Widget Function(RouteData data)? unknownRoute,
    Widget Function(Widget routerOutlet)? builder,
    Page<dynamic> Function(MaterialPageArgument arg)? pageBuilder,
    bool shouldUseCupertinoPage = false,
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondAnimation,
      Widget child,
    )?
        transitionsBuilder,
    Duration? transitionDuration,
    Redirect? Function(RouteData data)? onNavigate,
    bool? Function(RouteData? data)? onNavigateBack,
    bool debugPrintWhenRouted = false,
    bool ignoreUnknownRoutes = false,
    List<NavigatorObserver> navigatorObservers = const [],
  }) {
    return NavigationBuilderImp(
      routes: routes,
      unknownRoute: unknownRoute,
      transitionsBuilder: transitionsBuilder,
      transitionDuration: transitionDuration,
      builder: builder,
      initialRoute: initialLocation,
      shouldUseCupertinoPage: shouldUseCupertinoPage,
      redirectTo: onNavigate,
      debugPrintWhenRouted: debugPrintWhenRouted,
      pageBuilder: pageBuilder,
      onBack: onNavigateBack,
      ignoreUnknownRoutes: ignoreUnknownRoutes,
      navigatorObservers: navigatorObservers,
    );
  }

  /// Scaffold without BuildContext.
  late final scaffold = scaffoldObject.._mock = navigationBuilderMockedInstance;

  /// Navigation without BuildContext.
  static final navigate = navigateObject;

  /// Predefined set of route transition animation
  static set transitionsBuilder(
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)
        value,
  ) {
    navigateObject.transitionsBuilder = value;
  }

  static set pageRouteBuilder(
          PageRoute<dynamic> Function(Widget, RouteSettings?) value) =>
      navigateObject.pageRouteBuilder = value;
  static final transitions = transitionsObject;

  ///Get an active navigation [BuildContext].
  BuildContext? get navigationContext => context;

  ///Get an active [BuildContext].
  ///
  static BuildContext? get context {
    return navigateObject.navigatorState.context;
  }

  /// [RouterDelegate] implementation
  RouterDelegate<PageSettings> get routerDelegate =>
      RouterObjects.rootDelegate!;

  /// [RouteInformationParser] delegate.
  RouteInformationParser<PageSettings> get routeInformationParser =>
      RouterObjects.routeInformationParser!;
  RouterConfig<PageSettings> get routerConfig => RouterObjects.routerConfig!;

  /// Set the route stack. It exposes the current [PageSettings] stack.
  void setRouteStack(
    List<PageSettings> Function(List<PageSettings> pages) stack, {
    String? subRouteName,
  }) {
    if (navigationBuilderMockedInstance != null) {
      navigationBuilderMockedInstance!
          .setRouteStack(stack, subRouteName: subRouteName);
    }
    return navigateObject.setRouteStack(stack, subRouteName: subRouteName);
  }

  /// Get the [PageSettings] stack.
  List<PageSettings> get pageStack {
    if (navigationBuilderMockedInstance != null) {
      return navigationBuilderMockedInstance!.pageStack;
    }
    return (routerDelegate as RouterDelegateImp).pageSettingsList;
  }

  /// Get the current [RouteData]
  RouteData get routeData {
    if (navigationBuilderMockedInstance != null) {
      return (navigationBuilderMockedInstance as NavigationBuilderImp)
          .routeData;
    }
    throw UnimplementedError();
  }

  /// Find the page with given routeName and add it to the route stack and trigger
  /// route transition.
  ///
  /// If the page belongs to a sub route the page is added to it and only this
  /// particular sub route is triggered to animate transition.
  ///
  ///Equivalent to: [NavigatorState.pushNamed]
  Future<T?> to<T extends Object?>(
    String routeName, {
    Object? arguments,
    Map<String, String>? queryParams,
    bool fullscreenDialog = false,
    bool maintainState = true,
    Widget Function(Widget route)? builder,
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondAnimation,
      Widget child,
    )?
        transitionsBuilder,
  }) {
    final r = navigateObject.toNamed<T>(
      routeName,
      builder: builder,
      arguments: arguments,
      queryParams: queryParams,
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
      transitionsBuilder: transitionsBuilder,
    );

    if (navigationBuilderMockedInstance != null) {
      return navigationBuilderMockedInstance!.to<T>(
        routeName,
        arguments: arguments,
        queryParams: queryParams,
        builder: builder,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
        transitionsBuilder: transitionsBuilder,
      );
    }
    return r;
  }

  ///navigate to the given page.
  ///
  ///You can specify a name to the route  (e.g., "/settings"). It will be used with
  ///[backUntil], [toAndRemoveUntil],
  ///
  ///Equivalent to: [NavigatorState.push]
  Future<T?> toPageless<T extends Object?>(
    Widget page, {
    String? name,
    bool fullscreenDialog = false,
    bool maintainState = true,
    // Widget Function(
    //   BuildContext context,
    //   Animation<double> animation,
    //   Animation<double> secondAnimation,
    //   Widget child,
    // )?
    //     transitionsBuilder,
  }) {
    if (navigationBuilderMockedInstance != null) {
      // As pageless routing need a navigationState, We must return the mocked
      // toPageless
      return navigationBuilderMockedInstance!.toPageless<T>(
        page,
        name: name,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
        // transitionsBuilder: transitionsBuilder,
      );
    }
    return navigateObject.to<T>(
      page,
      name: name,
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
      // transitionsBuilder: transitionsBuilder,
    );
  }

  // Future<T?> toReplacementPageless<T extends Object?, TO extends Object?>(
  //   Widget page, {
  //   TO? result,
  //   String? name,
  //   bool fullscreenDialog = false,
  //   bool maintainState = true,
  //   // transitionsBuilder,
  // }) {
  //   if (_mock != null) {
  //     _mock!.toReplacementPageless<T, TO>(
  //       page,
  //       name: name,
  //       fullscreenDialog: fullscreenDialog,
  //       maintainState: maintainState,
  //       // transitionsBuilder: transitionsBuilder,
  //     );
  //   }

  //   return navigateObject.toReplacement<T, TO>(
  //     page,
  //     name: name,
  //     fullscreenDialog: fullscreenDialog,
  //     maintainState: maintainState,
  //     // transitionsBuilder: transitionsBuilder,
  //   );
  // }

  /// Whether a page can be popped off from the root route stack or sub route
  /// stacks.
  bool get canPop {
    throw UnimplementedError();
  }

  /// Deeply navigate to the given routeName. Deep navigation means that the
  /// root stack is cleaned and pages corresponding to sub paths are added to
  /// the stack.
  ///
  /// Example:
  /// Suppose our navigator is :
  /// ```dart
  ///  final myNavigator = NavigationBuilder.create(
  ///    routes: {
  ///      '/': (RouteData data) => HomePage(),
  ///      '/page1': (RouteData data) => Page1(),
  ///      '/page1/page11': (RouteData data) => Page11(),
  ///      '/page1/page11/page111': (RouteData data) => Page111(),
  ///    },
  ///  );
  /// ```
  /// On app start up, the route stack is `['/']`.
  ///
  /// If we call `myNavigator.to('/page1/page11/page111')`,
  /// the route stack is
  ///
  /// `['/', '/page1/page11/page111']`.
  ///
  ///
  ///
  /// In contrast, if we invoke myNavigator.toDeeply('/page1/page11/page111'),
  /// the route stack is
  ///
  /// `['/', '/page1', '/page1/page11', '/page1/page11/page111']`.
  void toDeeply(
    String routeName, {
    Object? arguments,
    Map<String, String>? queryParams,
    bool fullscreenDialog = false,
    bool maintainState = true,
  }) {
    RouterObjects.clearStack();
    final pathSegments = Uri.parse(routeName).pathSegments;

    if (pathSegments.isEmpty) {
      to('/', arguments: arguments, queryParams: queryParams);
      return;
    }
    to('/');
    String path = '';
    for (var i = 0; i < pathSegments.length; i++) {
      path += '/${pathSegments[i]}';
      if (i == pathSegments.length - 1) {
        to(
          path,
          arguments: arguments,
          queryParams: queryParams,
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
        );
      } else {
        to(
          path,
          maintainState: maintainState,
        );
      }
      if (navigationBuilderMockedInstance != null) {
        navigationBuilderMockedInstance!.toDeeply(
          routeName,
          arguments: arguments,
          queryParams: queryParams,
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
        );
      }
    }
  }

  /// Find the page with given routeName and remove the current route and
  /// replace it with the new one.
  ///
  ///Equivalent to: [NavigatorState.pushReplacementNamed]
  Future<T?> toReplacement<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    Map<String, String>? queryParams,
    bool fullscreenDialog = false,
    bool maintainState = true,
  }) {
    final r = navigateObject.toReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
      queryParams: queryParams,
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
    );
    if (navigationBuilderMockedInstance != null) {
      return navigationBuilderMockedInstance!.toReplacement<T, TO>(
        routeName,
        result: result,
        arguments: arguments,
        queryParams: queryParams,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
      );
    }
    return r;
  }

  /// Navigate to the page with the given named route (first argument), and then
  /// remove all the previous routes until meeting the route with defined route
  /// name [untilRouteName].
  ///
  /// If no route name is given ([untilRouteName] is null) , all routes will be
  /// removed except the new page route.
  ///
  /// Equivalent to: [NavigatorState.pushNamedAndRemoveUntil]
  Future<T?> toAndRemoveUntil<T extends Object?>(
    String newRouteName, {
    String? untilRouteName,
    Object? arguments,
    Map<String, String>? queryParams,
    bool fullscreenDialog = false,
    bool maintainState = true,
  }) {
    final r = navigateObject.toNamedAndRemoveUntil<T>(
      newRouteName,
      untilRouteName: untilRouteName,
      arguments: arguments,
      queryParams: queryParams,
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
    );
    if (navigationBuilderMockedInstance != null) {
      try {
        return navigationBuilderMockedInstance!.toAndRemoveUntil<T>(
          newRouteName,
          untilRouteName: untilRouteName,
          arguments: arguments,
          queryParams: queryParams,
          fullscreenDialog: fullscreenDialog,
          maintainState: maintainState,
        );
      } catch (e) {}
    }
    return r;
  }

  ///Navigate back and remove all the previous routes until meeting the route
  ///with defined name
  ///
  ///Equivalent to: [NavigatorState.popUntil]
  void backUntil(String untilRouteName) {
    if (navigationBuilderMockedInstance != null) {
      navigationBuilderMockedInstance!.backUntil(untilRouteName);
    }
    return navigateObject.backUntil(untilRouteName);
  }

  /// Navigate back to the last page, ie
  /// Pop the top-most route off the navigator.
  ///
  /// Equivalent to: [NavigatorState.pop]
  ///
  /// See also: [forceBack]
  void back<T extends Object>([T? result]) {
    if (navigationBuilderMockedInstance != null) {
      return navigationBuilderMockedInstance!.back<T>(result);
    }
    return navigateObject.back<T>(result);
  }

  ///Navigate back than to the page with the given named route
  ///
  ///Equivalent to: [NavigatorState.popAndPushNamed]
  Future<T?> backAndToNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    bool fullscreenDialog = false,
    bool maintainState = true,
  }) {
    if (navigationBuilderMockedInstance != null) {
      return navigationBuilderMockedInstance!.backAndToNamed<T, TO>(
        routeName,
        result: result,
        arguments: arguments,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
      );
    }
    return navigateObject.backAndToNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
    );
    ;
  }

  ///{@template forceBack}
  /// Navigate Back by popping the top-most page route with all pagesless route
  /// associated with it and without calling `onNavigateBack` hook.
  ///
  /// For example:
  /// In case a `Dialog` (a `Dialog` is an example pageless route) is displayed and
  /// we invoke `forceBack`, the dialog and the last page are popped from route stack.
  /// Contrast this with the case when we call [back] where only the dialog is popped.
  /// {@endtemplate}
  /// See also: [back]
  ///
  void forceBack<T extends Object>([T? result]) {
    if (navigationBuilderMockedInstance != null) {
      return navigationBuilderMockedInstance!.forceBack<T>(result);
    }
    return navigateObject.forceBack<T>(result);
  }

  /// Remove a pages from the route stack.
  void removePage<T extends Object>(String routeName, [T? result]) {
    if (navigationBuilderMockedInstance != null) {
      navigationBuilderMockedInstance!.removePage<T>(routeName, result);
    }
    RouterObjects.removePage<T>(
      routeName: routeName,
      activeSubRoutes: RouterObjects.getActiveSubRoutes(),
      result: result,
    );
  }

  /// Invoke `onNavigate` callback and navigate according the logic defined there.
  void onNavigate() {
    throw UnimplementedError();
  }

  /// Used in test to simulate a deep link call.
  void deepLinkTest(String url) {
    routeInformationParser.parseRouteInformation(
      RouteInformation(location: url),
    );
    (routerDelegate as RouterDelegateImp).updateRouteStack();
  }

  NavigationBuilder? navigationBuilderMockedInstance;

  /// Mock NavigationBuilder
  void injectMock(NavigationBuilder mock, {String? startRoute}) {
    dispose();
    assert(() {
      mock.navigationBuilderMockedInstance = this;
      navigationBuilderMockedInstance = mock;
      return true;
    }());
  }

  ///{@template toDialog}
  ///Displays a Material dialog above the current contents of the app, with
  ///Material entrance and exit animations, modal barrier color, and modal
  ///barrier behavior (dialog is dismissible with a tap on the barrier).
  ///
  ///* Required parameters:
  ///  * [dialog]:  (positional parameter) Widget to display.
  /// * optional parameters:
  ///  * [barrierDismissible]: Whether dialog is dismissible when tapping
  /// outside it. Default value is true.
  ///  * [barrierColor]: the color of the modal barrier that darkens everything
  /// the dialog. If null the default color Colors.black54 is used.
  ///  * [useSafeArea]: Whether the dialog should only display in 'safe' areas
  /// of the screen. Default value is true.
  ///
  ///Equivalent to: [showDialog].
  /// {@endtemplate}
  Future<T?> toDialog<T>(
    Widget dialog, {
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
    bool postponeToNextFrame = false,
  }) {
    if (navigationBuilderMockedInstance != null) {
      return navigationBuilderMockedInstance!.toDialog(
        dialog,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        useSafeArea: useSafeArea,
        postponeToNextFrame: postponeToNextFrame,
      );
    }
    return navigateObject.toDialog<T>(
      dialog,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      useSafeArea: useSafeArea,
      postponeToNextFrame: postponeToNextFrame,
    );
  }

  ///{@template toCupertinoDialog}
  ///Displays an iOS-style dialog above the current contents of the app, with
  ///iOS-style entrance and exit animations, modal barrier color, and modal
  ///barrier behavior
  ///
  ///* Required parameters:
  ///  * [dialog]:  (positional parameter) Widget to display.
  /// * optional parameters:
  ///  * [barrierDismissible]: Whether dialog is dismissible when tapping
  /// outside it. Default value is false.
  ///
  ///Equivalent to: [showCupertinoDialog].
  /// {@endtemplate}
  Future<T?> toCupertinoDialog<T>(
    Widget dialog, {
    bool barrierDismissible = false,
    bool postponeToNextFrame = false,
  }) {
    if (navigationBuilderMockedInstance != null) {
      return navigationBuilderMockedInstance!.toCupertinoDialog<T>(
        dialog,
        barrierDismissible: barrierDismissible,
        postponeToNextFrame: postponeToNextFrame,
      );
    }

    return navigateObject.toCupertinoDialog<T>(
      dialog,
      barrierDismissible: barrierDismissible,
      postponeToNextFrame: postponeToNextFrame,
    );
  }

  ///{@template toBottomSheet}
  ///Shows a modal material design bottom sheet that prevents the user from
  ///interacting with the rest of the app.
  ///
  ///A closely related widget is the persistent bottom sheet, which allows
  ///the user to interact with the rest of the app. Persistent bottom sheets
  ///can be created and displayed with the [NavigationBuilder.showBottomSheet] or
  ///[showBottomSheet] Methods.
  ///
  ///
  ///* Required parameters:
  ///  * [bottomSheet]:  (positional parameter) Widget to display.
  /// * optional parameters:
  ///  * [isDismissible]: whether the bottom sheet will be dismissed when user
  /// taps on the scrim. Default value is true.
  ///  * [enableDrag]: whether the bottom sheet can be dragged up and down and
  /// dismissed by swiping downwards. Default value is true.
  ///  * [isScrollControlled]: whether this is a route for a bottom sheet that
  /// will utilize [DraggableScrollableSheet]. If you wish to have a bottom
  /// sheet that has a scrollable child such as a [ListView] or a [GridView]
  /// and have the bottom sheet be draggable, you should set this parameter
  /// to true.Default value is false.
  ///  * [backgroundColor], [elevation], [shape], [clipBehavior] and
  /// [barrierColor]: used to customize the appearance and behavior of modal
  /// bottom sheets
  ///
  ///Equivalent to: [showModalBottomSheet].
  /// {@endtemplate}
  Future<T?> toBottomSheet<T>(
    Widget bottomSheet, {
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool postponeToNextFrame = false,
  }) {
    if (navigationBuilderMockedInstance != null) {
      return navigationBuilderMockedInstance!.toBottomSheet<T>(
        bottomSheet,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        barrierColor: barrierColor,
        postponeToNextFrame: postponeToNextFrame,
      );
    }
    return navigateObject.toBottomSheet<T>(
      bottomSheet,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      postponeToNextFrame: postponeToNextFrame,
    );
  }

  ///{@template toCupertinoModalPopup}
  ///Shows a modal iOS-style popup that slides up from the bottom of the screen.
  ///* Required parameters:
  ///  * [cupertinoModalPopup]:  (positional parameter) Widget to display.
  /// * optional parameters:
  ///  * [filter]:
  ///  * [semanticsDismissible]: whether the semantics of the modal barrier are
  /// included in the semantics tree
  /// {@endtemplate}
  Future<T?> toCupertinoModalPopup<T>(
    Widget cupertinoModalPopup, {
    ImageFilter? filter,
    bool? semanticsDismissible,
    bool postponeToNextFrame = false,
  }) {
    if (navigationBuilderMockedInstance != null) {
      return navigationBuilderMockedInstance!.toCupertinoModalPopup<T>(
        cupertinoModalPopup,
        filter: filter,
        semanticsDismissible: semanticsDismissible,
        postponeToNextFrame: postponeToNextFrame,
      );
    }

    return navigateObject.toCupertinoModalPopup<T>(
      cupertinoModalPopup,
      filter: filter,
      semanticsDismissible: semanticsDismissible,
      postponeToNextFrame: postponeToNextFrame,
    );
  }

  void dispose() {
    scaffold.dispose();
    navigate.dispose();
  }
}

class NavigationBuilderImp extends NavigationBuilder {
  NavigationBuilderImp({
    required Map<String, Widget Function(RouteData data)> routes,
    required Widget Function(RouteData)? unknownRoute,
    required Widget Function(
            BuildContext, Animation<double>, Animation<double>, Widget)?
        transitionsBuilder,
    required Duration? transitionDuration,
    required Widget Function(Widget child)? builder,
    required String? initialRoute,
    required bool shouldUseCupertinoPage,
    required Redirect? Function(RouteData data)? redirectTo,
    required this.debugPrintWhenRouted,
    required this.pageBuilder,
    required this.onBack,
    required this.ignoreUnknownRoutes,
    required List<NavigatorObserver> navigatorObservers,
  }) : _redirectTo = redirectTo {
    _resetDefaultState = () {
      _routeData = initialRouteData;
      RouterObjects.initialize(
        routes: routes,
        unknownRoute: unknownRoute,
        transitionsBuilder: transitionsBuilder,
        transitionDuration: transitionDuration,
        builder: builder,
        initialRoute: initialRoute,
        shouldUseCupertinoPage: shouldUseCupertinoPage,
        observers: navigatorObservers,
      );
      RouterObjects.navigationBuilder = this;
    };
  }

  bool _isInitialized = false;
  @override
  void injectMock(NavigationBuilder mock, {String? startRoute}) {
    super.injectMock(mock);
    routerDelegate;
    if (startRoute != null) {
      RouterObjects._initialRouteValue = startRoute;
    }
    routeInformationParser.parseRouteInformation(RouteInformation(
      location: RouterObjects._initialRouteValue,
    ));
  }

  @override
  RouterConfig<PageSettings> get routerConfig {
    if (!_isInitialized) {
      _isInitialized = true;
      _resetDefaultState();
    }
    return super.routerConfig;
  }

  @override
  RouterDelegate<PageSettings> get routerDelegate {
    if (!_isInitialized) {
      _isInitialized = true;
      _resetDefaultState();
    }
    return super.routerDelegate;
  }

  @override
  RouteInformationParser<PageSettings> get routeInformationParser {
    if (!_isInitialized) {
      _isInitialized = true;
      _resetDefaultState();
    }
    return super.routeInformationParser;
  }

  static final initialRouteData = RouteData.initial();
  static bool ignoreSingleRouteMapAssertion = false;
  final bool ignoreUnknownRoutes;

  final Redirect? Function(RouteData data)? _redirectTo;
  Redirect? Function(RouteData data)? get redirectTo {
    if (_redirectTo == null) {
      return null;
    }
    return (RouteData data) {
      return _redirectTo!(data);
    };
  }

  @override
  void onNavigate() {
    if (RouterObjects.rootDelegate == null) return;
    final toLocation = _redirectTo?.call(routeData);
    if (toLocation is Redirect && toLocation.to != null) {
      setRouteStack(
        (pages) {
          pages.clear();
          return pages.to(
            toLocation.to!,
            arguments: routeData.arguments,
            queryParams: routeData.queryParams,
            isStrictMode: true,
          );
        },
      );
    }
  }

  final bool debugPrintWhenRouted;
  final Page<dynamic> Function(MaterialPageArgument arg)? pageBuilder;
  final bool? Function(RouteData? data)? onBack;

  late final VoidCallback _resetDefaultState;

  @override
  bool get canPop {
    if (navigationBuilderMockedInstance != null) {
      navigationBuilderMockedInstance!.canPop;
    }
    // states_builder_rm.ReactiveStatelessWidget.addToObs?.call(this);
    return RouterObjects.canPop;
  }

  RouteData? _routeData;

  set routeData(RouteData value) {
    if (routeData.signature != value.signature ||
        routeData.navigatorKey != value.navigatorKey) {
      _routeData = value;
    }
  }

  @override
  RouteData get routeData {
    if (!_isInitialized) {
      _isInitialized = true;
      _resetDefaultState();
    }
    return _routeData!;
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _isInitialized = false;
      super.dispose();
    }
  }
}
