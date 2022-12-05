part of 'navigation_builder.dart';

// class _RouteFullWidget extends StatefulWidget {
//   final Map<String, RouteSettingsWithChildAndData> pages;

//   final Animation<double>? animation;
//   final void Function()? initState;
//   final void Function()? dispose;

//   const _RouteFullWidget({
//     Key? key,
//     required this.pages,
//     this.animation,
//     this.initState,
//     this.dispose,
//   }) : super(key: key);

//   @override
//   _RouteFullWidgetState createState() => _RouteFullWidgetState();
// }

Widget get routeNotDefinedAssertion {
  return Builder(
    builder: (_) {
      assert(() {
        NavigationBuilderLogger.log(
          'NO sub-routes is defined',
          'You are trying to use a sub-route inside the builder '
              'of RouteWidget But the parameter "routes" of RouteWidget '
              'is not defined\n'
              'Do not use the exposed route widget or define routes '
              'parameters',
        );
        return false;
      }());

      return const SizedBox();
    },
  );
}

Widget getWidgetFromPages({
  required Map<String, RouteSettingsWithChildAndData> pages,
  Animation<double>? animation,
}) {
  Widget getChild({
    required List<String> keys,
    required Widget? route,
    required Widget? lastSubRoute,
  }) {
    var key = keys.last;
    final lastPage = pages[key]!;
    var c = lastPage.child;
    if (c is RouteWidget && c.builder != null) {
      return c;
    }
    return SubRoute._(
      route: route,
      lastSubRoute: lastSubRoute,
      routeData: lastPage.routeData,
      animation: animation,
      transitionsBuilder: lastPage.child is RouteWidget
          ? (lastPage.child as RouteWidget).transitionsBuilder
          : null,
      shouldAnimate: true,
      key: Key(key),
      child: () {
        if (c is RouteWidget && c.builder != null) {
          return c;
        }

        assert(c != null, '"${lastPage.name}" route is not found');
        return lastPage._getChildWithBuilder();
      }(),
    );
  }

  var keys = pages.keys.toList();
  return getChild(keys: keys, route: null, lastSubRoute: null);
}
