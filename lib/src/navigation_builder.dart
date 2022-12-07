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

///{@template InjectedNavigator}
/// Injecting a Navigator 2 that holds a [RouteData] state.
///
/// ```dart
///  final myNavigator = RM.injectNavigator(
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
    return InjectedNavigatorImp(
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

  void disposeAll() {
    scaffold.dispose();
    navigate.dispose();
  }

  /// Scaffold without BuildContext.
  final scaffold = scaffoldObject;

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

  ///Get an active [BuildContext].
  ///
  ///The obtained [BuildContext] is one of the [states_rebuilder]'s widgets
  ///context;
  ///
  ///For this reason you have to use at least one of [states_rebuilder]'s widgets.
  static BuildContext? get context {
    // if (_context != null) {
    //   return _context;
    // }

    // if (_contextSet.isNotEmpty) {
    //   final renderObject = _contextSet.last.findRenderObject();
    //   if (renderObject != null && renderObject.attached != true) {
    //     _contextSet.removeLast();
    //     // ignore: recursive_getters
    //     return context;
    //   }
    //   return _contextSet.last;
    // }

    return navigateObject.navigatorState.context;
  }

  /// [RouterDelegate] implementation
  RouterDelegate<PageSettings> get routerDelegate =>
      RouterObjects.rootDelegate!;

  /// [RouteInformationParser] delegate.
  RouteInformationParser<PageSettings> get routeInformationParser =>
      RouterObjects.routeInformationParser!;

  /// Set the route stack. It exposes the current [PageSettings] stack.
  void setRouteStack(
    List<PageSettings> Function(List<PageSettings> pages) stack, {
    String? subRouteName,
  }) {
    if (_mock != null) {
      return _mock!.setRouteStack(stack, subRouteName: subRouteName);
    }
    return navigateObject.setRouteStack(stack, subRouteName: subRouteName);
  }

  /// Get the [PageSettings] stack.
  List<PageSettings> get pageStack {
    if (_mock != null) {
      return _mock!.pageStack;
    }
    return (routerDelegate as RouterDelegateImp).pageSettingsList;
  }

  /// Get the current [RouteData]
  RouteData get routeData => throw UnimplementedError();

  /// Find the page with given routeName and add it to the route stack and trigger
  /// route transition.
  ///
  /// If the page belongs to a sub route the page is added to it and only this
  /// particular sub route is triggered to animate transition.
  ///
  /// It is similar to `_navigate.toNamed` method.
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
    if (_mock != null) {
      return _mock!.to<T>(
        routeName,
        arguments: arguments,
        queryParams: queryParams,
        builder: builder,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
        transitionsBuilder: transitionsBuilder,
      );
    }

    return navigateObject.toNamed<T>(
      routeName,
      builder: builder,
      arguments: arguments,
      queryParams: queryParams,
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
      transitionsBuilder: transitionsBuilder,
    );
  }

  /// Push a pageless route
  ///
  /// Similar to `_navigate.to`
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
    if (_mock != null) {
      return _mock!.toPageless<T>(
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
  //     return _mock!.toReplacementPageless<T, TO>(
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
  bool get canPop => throw UnimplementedError();

  /// Deeply navigate to the given routeName. Deep navigation means that the
  /// root stack is cleaned and pages corresponding to sub paths are added to
  /// the stack.
  ///
  /// Example:
  /// Suppose our navigator is :
  /// ```dart
  ///  final myNavigator = RM.injectNavigator(
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
  /// If we call `myNavigator.to('/page1/page11/page111')`, the route stack is
  /// `['/', '/page1/page11/page111']`.
  ///
  /// In contrast, if we invoke myNavigator.toDeeply('/page1/page11/page111'),
  /// the route stack is `['/', '/page1', '/page1/page11', '/page1/page11/page111']`.
  void toDeeply(
    String routeName, {
    Object? arguments,
    Map<String, String>? queryParams,
    bool fullscreenDialog = false,
    bool maintainState = true,
  }) {
    if (_mock != null) {
      return _mock!.toDeeply(
        routeName,
        arguments: arguments,
        queryParams: queryParams,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
      );
    }

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
    }
  }

  /// Find the page with given routeName and remove the current route and
  /// replace it with the new one.
  ///
  /// It is similar to `_navigate.toReplacementNamed` method.
  Future<T?> toReplacement<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    Map<String, String>? queryParams,
    bool fullscreenDialog = false,
    bool maintainState = true,
  }) {
    if (_mock != null) {
      return _mock!.toReplacement<T, TO>(
        routeName,
        result: result,
        arguments: arguments,
        queryParams: queryParams,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
      );
    }

    return navigateObject.toReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
      queryParams: queryParams,
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
    );
  }

  /// Find the page with given routeName and then remove all the previous routes
  /// until meeting the route with defined route name [untilRouteName].
  /// If no route name is given ([untilRouteName] is null) , all routes will be
  /// removed except the new page route.
  ///
  /// It is similar to `_navigate.toNamedAndRemoveUntil` method.
  Future<T?> toAndRemoveUntil<T extends Object?>(
    String newRouteName, {
    String? untilRouteName,
    Object? arguments,
    Map<String, String>? queryParams,
    bool fullscreenDialog = false,
    bool maintainState = true,
  }) {
    if (_mock != null) {
      return _mock!.toAndRemoveUntil<T>(
        newRouteName,
        untilRouteName: untilRouteName,
        arguments: arguments,
        queryParams: queryParams,
        fullscreenDialog: fullscreenDialog,
        maintainState: maintainState,
      );
    }
    return navigateObject.toNamedAndRemoveUntil<T>(
      newRouteName,
      untilRouteName: untilRouteName,
      arguments: arguments,
      queryParams: queryParams,
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
    );
  }

  /// Navigate back and remove all the previous routes until meeting the route
  /// with defined name
  ///
  /// It is similar to `_navigate.backUntil` method.
  void backUntil(String untilRouteName) {
    if (_mock != null) {
      return _mock!.backUntil(untilRouteName);
    }
    return navigateObject.backUntil(untilRouteName);
  }

  /// Navigate back to the last page, ie Pop the top-most route off the navigator.
  ///
  /// It is similar to `_navigate.back` method.
  void back<T extends Object>([T? result]) {
    if (_mock != null) {
      return _mock!.back<T>(result);
    }
    return navigateObject.back<T>(result);
  }

  Future<T?> backAndToNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    bool fullscreenDialog = false,
    bool maintainState = true,
  }) {
    if (_mock != null) {
      return _mock!.backAndToNamed<T, TO>(
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
  }

  /// {@macro forceBack}
  /// It is similar to `_navigate.forceBack` method.
  void forceBack<T extends Object>([T? result]) {
    if (_mock != null) {
      return _mock!.forceBack<T>(result);
    }
    return navigateObject.forceBack<T>(result);
  }

  /// Remove a pages from the route stack.
  void removePage<T extends Object>(String routeName, [T? result]) {
    if (_mock != null) {
      return _mock!.removePage<T>(routeName, result);
    }
    RouterObjects.removePage<T>(
      routeName: routeName,
      activeSubRoutes: RouterObjects.getActiveSubRoutes(),
      result: result,
    );
  }

  /// Invoke `onNavigate` callback and navigate according the logic defined there.
  void onNavigate() => throw UnimplementedError();

  /// Used in test to simulate a deep link call.
  void deepLinkTest(String url) {
    routeInformationParser.parseRouteInformation(
      RouteInformation(location: url),
    );
    (routerDelegate as RouterDelegateImp).updateRouteStack();
  }

  NavigationBuilder? _mock;

  /// Mock InjectedNavigator
  void injectMock(NavigationBuilder mock) {
    assert(() {
      _mock = mock;
      return true;
    }());
  }

  /// {@macro toDialog}
  Future<T?> toDialog<T>(
    Widget dialog, {
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
    bool postponeToNextFrame = false,
  }) {
    return navigateObject.toDialog<T>(
      dialog,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      useSafeArea: useSafeArea,
      postponeToNextFrame: postponeToNextFrame,
    );
  }

  /// {@macro toCupertinoDialog}
  Future<T?> toCupertinoDialog<T>(
    Widget dialog, {
    bool barrierDismissible = false,
    bool postponeToNextFrame = false,
  }) =>
      navigateObject.toCupertinoDialog<T>(
        dialog,
        barrierDismissible: barrierDismissible,
        postponeToNextFrame: postponeToNextFrame,
      );

  /// {@macro toBottomSheet}
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
  }) =>
      navigateObject.toBottomSheet<T>(
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

  /// {@macro toCupertinoModalPopup}
  Future<T?> toCupertinoModalPopup<T>(
    Widget cupertinoModalPopup, {
    ImageFilter? filter,
    bool? semanticsDismissible,
    bool postponeToNextFrame = false,
  }) =>
      navigateObject.toCupertinoModalPopup<T>(
        cupertinoModalPopup,
        filter: filter,
        semanticsDismissible: semanticsDismissible,
        postponeToNextFrame: postponeToNextFrame,
      );
}

class ReactiveModelImp<T> {
  T Function() creator;

  ReactiveModelImp({
    required this.creator,
  });
  late T _state;
  T? _initialState;
  T get state {
    if (_initialState != null) {
      return _state;
    }
    _initialState = creator();
    return _state = _initialState!;
  }

  void dispose() {
    if (_initialState != null) {
      _state = _initialState!;
    }
  }
}

class InjectedNavigatorImp extends ReactiveModelImp<RouteData>
    with NavigationBuilder {
  InjectedNavigatorImp({
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
  })  : _redirectTo = redirectTo,
        super(
          creator: () => initialRouteData,
          // initialState: initialRouteData,
          // autoDisposeWhenNotUsed: true,
          // stateInterceptorGlobal: null,
        ) {
    _resetDefaultState = () {
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
      RouterObjects.injectedNavigator = this;
    };
  }
  bool _isInitialized = false;

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

  set routeData(RouteData value) {
    if (state.signature != value.signature ||
        state.navigatorKey != value.navigatorKey) {
      _state = value;
    }
  }

  @override
  void dispose() {
    _isInitialized = false;
    // _resetDefaultState();
    super.dispose();
  }

  @override
  bool get canPop {
    if (_mock != null) {
      return _mock!.canPop;
    }
    // states_builder_rm.ReactiveStatelessWidget.addToObs?.call(this);
    return RouterObjects.canPop;
  }

  @override
  RouteData get routeData {
    if (_mock != null) {
      return _mock!.routeData;
    }
    return state;
  }
}