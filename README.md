
<h1> navigation_builder </h1>


[![pub package](https://img.shields.io/pub/v/navigation_builder.svg)](https://pub.dev/packages/navigation_builder)
![actions workflow](https://github.com/GIfatahTH/navigation_builder/actions/workflows/config.yml/badge.svg)
[![codecov](https://codecov.io/gh/GIfatahTH/navigation_builder/branch/master/graph/badge.svg)](https://codecov.io/gh/GIfatahTH/navigation_builder)



This package was original a part of `navigation_builder` package. As requested by many users, I extract it to its own independent package.

Coming from 'navigation_builder', all you need to do is to:
* use `NavigationBuilder.create` instead of `NavigationBuilder.create`


# Setting Navigator (The global Picutre)
To set navigator 2 you only need to define a global `NavigationBuilder` final variable and use `MaterialApp.router` or `CupertinoApp.router` widgets like this:

```dart
final myNavigator = NavigationBuilder.create(
  // Put your route map here
  routes: {
    ... 
  },
  onNavigate: (RouteData data) {
    // Optional 
  },
  onNavigateBack: (RouteData data) {
    // Optional   
  }
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: myNavigator.routerConfig,
    );
  }
}
```

* To navigate imperatively: (Imperative in the look but declarative in behind the scene)

  ```dart
  myNavigator.to('/page1');
  myNavigator.to('/page1', arguments: 'myArgument', queryParams: {'id':'1'});
  myNavigator.toReplacement('/page1');
  myNavigator.toAndRemoveUntil('/page2', untilRouteName: '/page1');
  myNavigator.toDeeply('/page1');

  myNavigator.routeData; // Get information of the current route
  myNavigator.canPop;
  myNavigator.pageStack; // get the route stack

  myNavigator.back();
  myNavigator.forceBack();
  myNavigator.backAndToNamed('/page1');
  myNavigator.backUntil('/page1');
  ```

* To navigate declaratively:

  ```dart
  myNavigator.onNavigate();
  myNavigator.removePage('/page1');
  myNavigator.setRouteStack(
    (pages){
      // exposes a copy of the current route stack
      return [...newPagesList];
    }
  )
  ```

* To navigate to pageless routes, show dialogs and snackBars without `BuildContext`:

  ```dart
  myNavigator.toPageless(MyPageWidget());
  ```

* TO show dialogs and bottomSheets: 

  ```dart
  myNavigator.toDialog(Dialog());
  myNavigator.toCupertinoDialog(CupertinoAlertDialog());
  myNavigator.toBottomSheet(MyWidget());
  myNavigator.toCupertinoModalPopup(MyWidget());
  ```

* TO show Scaffold related popups: 

  ```dart
  myNavigator.scaffold.showSnackBar(SnackBar());
  myNavigator.scaffold.hideCurrentSnackBar();
  myNavigator.scaffold.removeCurrentSnackBar();

  myNavigator.scaffold.openDrawer();
  myNavigator.scaffold.closeDrawer();
  myNavigator.scaffold.openEndDrawer();
  myNavigator.scaffold.closeEndDrawer();

  myNavigator.scaffold.showMaterialBanner(MaterialBanner());
  myNavigator.scaffold.hideCurrentMaterialBanner();
  myNavigator.scaffold.removeCurrentMaterialBanner();

  myNavigator.scaffold.showBottomSheet(MyWidget());
  ```

* TO Mock the NavigationBuilder for test: 

  ```dart
    myNavigator.injectMock(mock);
  ```


> For more simple and practical examples of navigation, please refer to the navigation's set of [examples](https://github.com/GIfatahTH/navigation_builder/blob/dev/example)


# Table of Contents 
## Table of Contents <!-- omit in toc --> 
- [**NavigationBuilder**](#navigationBuilder)  
  - [routes](#routes)  
  - [initialLocation](#initiallocation)  
  - [unknownRoute](#unknownroute)  
  - [builder](#builder)  
  - [pageBuilder](#pagebuilder)  
  - [shouldUseCupertinoPage](#shouldusecupertinopage)  
  - [transitionsBuilder](#transitionsbuilder)  
  - [transitionDuration](#transitionduration)  
  - [onNavigate](#onnavigate)  
  - [onNavigateBack](#onnavigateback)  
  - [debugPrintWhenRouted](#debugprintwhenrouted)  
- [**Navigation**](#navigation)  
  - [Imperative navigation](#imperative-navigation)  
  - [Declarative navigation](#declarative-navigation)  
  - [Pageless navigation](#pageless-navigation)  
    - [Push a Widget route](#push-a-widget-route)  
    - [Dialogs and Sheets](#dialogs-and-sheets)  
    - [Show bottom sheets, snackBars and drawers that depend on the Scaffold](#show-bottom-sheets,-snackBars-and-drawers-that-depend-on-the-scaffold)  
- [**NavigationBuilder reactivity**](#navigationBuilder-reactivity)  
- [**Page transition animation**](#page-transition-animation)  
    - [Global level transition](#global-level-transition)  
    - [Route level transition](#route-level-transition)  
    - [Navigation call level transition](#navigation-call-level-transition)  
    - [Customized primary and secondary animation](#customized-primary-and-secondary-animation)  
- [**Nested routes**](#nested-routes)  
- [**Redirection**](#redirection)   
    - [Route level redirection](#route-level-redirection)  
    - [Global redirection](#global-redirection)  
    - [Cyclic redirection](#cyclic-redirection)  


## NavigationBuilder
### routes
The first step to set Navigator 2 API is to define how route names are mapped to their corresponding pages using `NavigationBuilder.create` method:

```dart
  final NavigationBuilder myNavigator = NavigationBuilder.create(
     // Define your routes map
     routes: {
       '/': (RouteData data) => Home(),
        // redirect all paths that starts with '/home' to '/' path
       '/home/*': (RouteData data) => data.redirectTo('/'),
       '/page1': (RouteData data) => Page1(),
       '/page1/page11': (RouteData data) => Page11(),
       '/page2/:id': (RouteData data) {
         // Extract path parameters from dynamic links
         final id = data.pathParams['id'];
         // Or inside Page2 you can use `context.routeData.pathParams['id']`
         return Page2(id: id);
        },
       '/page3/:kind(all|popular|favorite)': (RouteData data) {
         // Use custom regular expression
         final kind = data.pathParams['kind'];
         return Page3(kind: kind);
        },
       '/page4': (RouteData data) {
         // Extract query parameters from links
         // Ex link is `/page4?age=4`
         final age = data.queryParams['age'];
         // Or inside Page4 you can use `context.routeData.queryParams['age']`
         return Page4(age: age);
        },
        '/page5/bookId': (RouteData data) {
          // As deep link can have data out of boundary.
          try {
            final bookId = data.queryParams['bookId'];
            final book = books[int.parse(bookId)];
            return Page5(book: book);
          } catch {
            // bookId can be a non valid number or it can be greater than books length.
            // Dispay the unknownRoute widget
            return data.unknownRoute;
          }
        },
        // Using sub routes
        '/page6': (RouteData data) => RouteWidget(
              builder: (Widget routerOutlet) {
                return MyParentWidget(
                  child: routerOutlet;
                  // Or inside MyParentWidget you can use `context.routerOutlet`
                )
              },
              routes: {
                '/': (RouteData data) => Page6(),
                '/page51': (RouteData data) => Page61(),
              },
            ),
     },
   );
```

The first parameter is `routes` which is of type `Map<String, Widget Function(RouteData)>`.

The map entries of the `routes` parameter can be:
* Simple routes such as:
    ```dart
        '/': (RouteData data) => Home(),
        '/page1': (RouteData data) => Page1(),
    ```

* Simple nested routes:
    ```dart
        '/': (RouteData data) => Home(),
        '/page1': (RouteData data) => Page1(),
        '/page1/page11': (RouteData data) => Page11(),
        '/page1/page11/page111': (RouteData data) => Page111(),
        '/page1/page11/page111/page1111': (RouteData data) => Page1111(),
    ```   
    When the app first starts and if the initial location is set to `/page1/page11/page111/page1111`, the route stack will hold `['/', '/page1', '/page1/page11', '/page1/page11/page111', '/page1/page11/page111/page111']`. That is, the five pages are inflated on top of each other.

    But if you are in page `'/'` and you navigate to `/page1/page11/page111/page1111` using `myNavigator.to` method, the route stack will hold only two pages: `['/', '/page1/page11/page111/page111']`.

    You can navigate to `/page1/page11/page111/page1111` and inflate all intermediate routes using `myNavigator.toDeeply`. For more information see [**Imperative navigation**](#imperative-navigation) .

    You can simplify the routes above using `RouteWidget`:
    ```dart
        '/': (RouteData data) => Home(),
        '/page1': (RouteData data) => RouteWidget(
            routes: {
                '/': (RouteData data) => Page1(),
                '/page11': (RouteData data) => RouteWidget(
                    routes: {
                        '/': (RouteData data) => Page11(),
                        '/page111': (RouteData data) => Page111(),
                        '/page111/page1111': (RouteData data) => Page1111(),
                    },
                ),
            }
        ),
    ```
    Both way of writing routes are equivalent.

* Dynamic link routes:
    ```dart
        '/': (RouteData data) => Home(),
        '/books/': (RouteData data) => Books(),
        '/books/:bookId': (RouteData data) {
            final bookId = data.pathParam['bookId'];
            return BooksDetails(bookId: bookId),
            // Or just return BooksDetails() without parameters and get the book id using:
            // `context.routeData.pathParam['bookId']` inside the builder method of BooksDetails.
        },
        '/books/:bookId/authors': (RouteData data) => data.redirectTo('/authors'),
        '/authors': (RouteData data) {
            // As we are redirected here from '/books/:bookId/authors' we can get the book id.
            final bookId = data.pathParam['bookId'];

            // The location we are redirected from.
            // For example `books/1/authors`
            final redirectedFrom = data.redirectedFrom.location; 
            return Authors();
        },
        '/authors/:authorId': (RouteData data) {
            final authorId = data.pathParam['authorId'];
            return AuthorDetails();
        },
    ```   

    From the exposed `RouteData` we can get useful routing information. Let's suppose we are navigating to `books/1` url:
    * `RouteData.location`: holds the current location we are navigating to. (`books/1` in our example).
    * `RouteData.path`: the current resolved route path.(`books/:bookId` in our example).
    * `RouteData.baseLocation`: the base parent location.(`/` in our example). <!-- [see later]() -->
    * `RouteData.pathParams`: a map of extracted path parameters.(`{'bookId'; '1'}` in our example).
    * `RouteData.queryParams`: a map of extracted query parameters.(`{}` in our example). But if the navigation url is `books/1?q=1`, the `queryParams` equals `{'q': '1'}`;
    * `RouteData.redirectedFrom`: the `RouteData` we are redirected from.(`null` in our example). But if we are navigating to `books/1/authors` we will be redirected to `/authors` route. From their we `redirectedFrom.location` will be equal to `books/1/authors`. See[**Redirection**](#redirection) for more information
    
* Custom Regular expression routes:
    ```dart
        '/page3/:kind(all|popular|favorite)': (RouteData data) {
            // Use custom regular expression
            final kind = data.pathParams['kind'];
            // Or in any child of Page3, you can use context.pathParams
            return Page3(kind: kind);
        },
    ```   
    You can pass path parameters using regular expression.
    `/page/:name(ANY_VALID_REG_EXPRESSION)`
    What's between parenthesis is the regular expression.

    If the regular expression is invalid, the route is considered unknown.

    A star (*) matches all sub paths:
    - `/*` or just `*`, matches all location urls.
    - `/page1/*`, matches all location urls that starts with `/page1`.

* `RouteWidget`:    
   `RouteWidget` is used for multiple reasons: 
   * For organization:
        Let's take this routes map:  
        ```dart
        routes: {
               '/': (RouteData data) => Home(),
               '/page1': (RouteData data) => Page1(),
               '/page1/page11': (RouteData data) => Page11(),
               '/page1/page11/page111': (RouteData data) => Page111(),
               '/page1/page11/page111/page1111': (RouteData data) => Page1111(),
        }
        ```
        You can simplify the routes above using `RouteWidget`:
         
        ```dart
        routes: {
            '/': (RouteData data) => Home(),
            // '/page1' is considered the route name of this sub route.
            '/page1': (RouteData data) => RouteWidget(
                routes: {
                    // '/' here means the home page of '/page1' route, which is '/page1'
                    '/': (RouteData data) => Page1(),
                    '/page11': (RouteData data) => RouteWidget(
                        routes: {
                            '/': (RouteData data) => Page11(),
                            '/page111': (RouteData data) => Page111(),
                            '/page111/page1111': (RouteData data) => Page1111(),
                        },
                    ),
                }
            ),
        }
        ```
        Both way of writing routes are equivalent.
    
    * For custom page transition animation:
        You can dedicate a particular page transition to a specified route.
        ```dart
        final myNavigator = NavigationBuilder.create(
          // Default transition
          transitionDuration: RM.transitions.leftToRight(),
          routes: {
            '/': (_) => HomePage(),
            '/Page1': (_) => RouteWidget(
                  builder: (_) => Page1(),
                  // You can use one of the predefined transitions
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    // Custom transition implementation
                    return ...;
                  },
                ),
            '/page2': (_) => Page2(),
          },
        );
        ```
        pages `'/'` and `'/page2'` will use the default transition whereas `'/page1'` will use its own defined custom page transition. See [**Page transition animation**](#page-transition-animation)  section for detailed information.
    * For sub routes (nested routes):
        ```dart
            // '/page5' is the name of the sub route
            '/page5': (RouteData data) => RouteWidget(
              builder: (Widget routerOutlet) {
                return MyParentWidget(
                  child: routerOutlet;
                  // Or inside MyParentWidget you can use `context.routerOutlet`
                )
              },
              routes: {
                '/': (RouteData data) => Page5(),
                '/page51': (RouteData data) => Page51(),
              },
            ),
        ```
        Each sub route has its own stack of pages.
        The builder method is used to wrap the route outlet inside another widget. Only the outlet widget  will be animated on page transition. See [**Nested routes**](#nested-routes) for more information.

To navigate imperatively:

  ```dart
  myNavigator.to('/page1');
  myNavigator.toReplacement('/page1', argument: 'myArgument');
  myNavigator.toAndRemoveUntil('/page1', queryParam: {'id':'1'});
  myNavigator.back();
  myNavigator.backUntil('/page1');
  myNavigator.removePage('/page1');
  ```

To navigate declaratively:

  ```dart
  myNavigator.setRouteStack(
    (pages){
      // exposes a copy of the current route stack
      return [...newPagesList];
    }
  )
  ```

To navigate to pageless routes, show dialogs and snackBars without `BuildContext`:

  ```dart
  myNavigator.toPageless(HomePage());
  myNavigator.to(HomePage());

  myNavigator.toDialog(AlertDialog( ... ));
  myNavigator.back();// TO close the dialog


  // set the BuildContext that will be used to find the scaffold.
  myNavigator.scaffold.context= context; 
  myNavigator.scaffold.snackbar(SnackBar( ... ));
  myNavigator.scaffold.showDrawer();
  myNavigator.scaffold.closeDrawer();
  ```
For more information on navigation see [**Navigation**](#navigation)

### initialLocation
  By default when the app first tarts it will route to `'/'`. You can change this default behavior by setting the `initialLocation`.
   Let's take this route
   
```dart
routes: {
    '/': (RouteData data) => Home(),
    '/page1': (RouteData data) => Page1(),
    '/page1/page11': (RouteData data) => Page11(),
    '/page1/page11/page111': (RouteData data) => Page111(),
    '/page1/page11/page111/page1111': (RouteData data) => Page1111(),
}
```   

When the app first starts and if the initial location is set to `/page1/page11/page111/page1111`, the route stack will hold `['/', '/page1', '/page1/page11', '/page1/page11/page111', '/page1/page11/page111/page111']`. That is, the five pages are inflated on top of each other.

The same thing happens in deep linking. <!-- [see later]() -->

### unknownRoute
By default if the location fails to resolve to any of the known routes, a 404 widget is displayed. 

You can set your custom 404 widget using the parameter `unknownRoute`. It exposes the location url to go to.

As deep link can have data out of boundary, you can check for the validity of the extracted data and dispay the `unknownRoute` if data is not valid.
```dart
  final NavigationBuilder myNavigator = NavigationBuilder.create(
     routes: {
        '/': (RouteData data) => Home(),
        '/page1/bookId': (RouteData data) {
          try {
            final bookId = data.queryParams['bookId'];
            final book = books[int.parse(bookId)];
            return Page1(book: book);
          } catch {
            // bookId can be a non valid number or it can be greater than books length.
            // Dispay the unknownRoute widget
            return data.unknownRoute;
          }
        },
     },
   );
```

You can set the parameter `ignoreUnknownRoutes` to true to ignore all unknown routes and the app stays in the last known route.

```dart
  final NavigationBuilder myNavigator = NavigationBuilder.create(
    ignoreUnknownRoutes: true,
     routes: {
        '/': (RouteData data) => Home(),
        ... 
     },
   );
```
### builder
The builder parameters is used to wrap the router outlet widget with other widgets. 

In the following example the entire app is wrapped with a `Scaffold` that has an `AppBar` where the title displays the current location the app is in.
```dart
 final myNavigator = NavigationBuilder.create(
   builder: (Widget routeOutlet) {
      // If you extract this Scaffold to a Widget class, you do not
      // need to use the Builder widget
     return Scaffold(
       appBar: AppBar(
         title:Builder( // Needed only to get a child BuildContext
             builder: (context) {
               final location = context.routeData.location;
               return Text('Routing to: $location');
             },
         ),
       ),
       body: routeOutlet,
     );
   },
   routes: {
     '/': (_) => HomePage(),
     '/Page1': Page1(),
   },
 );
```

The builder callback exposes the route outlet widget. You can also obtain the route outlet widget in any of the child widget tree using `context.routeOutlet` relying of the `InheritedWidget` mechanism.

Notice that the `NavigationBuilder` is a reactive state so we can listen to it using `ReactiveStatelessWidget`. See [**NavigationBuilder reactivity**](#navigationBuilder-reactivity).

### pageBuilder
By default pages are wrapped with the appropriate `MaterialPage` ro `CupertinoPage` depending on whether you use `MaterialApp.router` or `CupertinoApp.router`.
In case you want to provide your own `Page` implementation you can use `pageBuilder` parameter.

```dart
pageBuilder: (MaterialPageArgument arg) {
   return MaterialPage(
     key: arg.key,
     child: arg.child,
     name: arg.name,
     arguments: arg.arguments,
     maintainState: arg.maintainState,
     fullscreenDialog: arg.fullscreenDialog,
   );
},
```
The pageBuilder exposes `MaterialPageArgument` object.
```dart
MaterialPageArgument({
  LocalKey? key,
  required Widget child,
  String? name,
  Object? arguments,
  required bool maintainState,
  required bool fullscreenDialog,
})
```
### shouldUseCupertinoPage
By default pages are wrapped with the appropriate `MaterialPage` ro `CupertinoPage` depending on whether you use `MaterialApp.router` or `CupertinoApp.router`.

If you want to use `MaterialApp.router` and wrap the pages with `CupertinoPage` , set `shouldUseCupertinoPage` to true. 

You can use `pageBuilder` for more customization.
### transitionsBuilder
By default, depending on the target platform, Flutter choses the adequate page transition animation for all routes.

You can provide you own page transition to override the default transition for all routes using `transitionsBuilder`

```dart
 final myNavigator = NavigationBuilder.create(
   transitionsBuilder: (context, animation, secondaryAnimation, child) {
     return // Your page transition implementation
   },
   routes: {
     ... 
   },
 );
```

You can also use one of the predefined transitions using `RM.transitions`

```dart
 final myNavigator = NavigationBuilder.create(
   transitionsBuilder: RM.transitions.leftToRight(),
   routes: {
     ... 
   },
 );
```

You can also force pages to transit without animation using `RM.transitions.none()`

```dart
 final myNavigator = NavigationBuilder.create(
   transitionsBuilder: RM.transitions.none(),
   routes: {
     ... 
   },
 );
```

The `transitionsBuilder` defined here will be use for all routes. In case you want, you have the ability to override this global behavior for a particular route or just for a particular call of navigation.See [**Page transition animation**](#page-transition-animation) for detailed discussion.

### transitionDuration
Define a duration for the transition animation.
### onNavigate
This is a call back that fires every time a location is successfully resolved and just before navigation.
You can use this callback for globule redirection.

It exposes the current state of the `NavigationBuilder` (`RouteData`).

Let's take this example:
```dart
  final myNavigator = NavigationBuilder.create(
    onNavigate: (RouteData data) {
      final toLocation = data.location;
      if (toLocation == '/homePage' && userIsNotSigned) {
        return data.redirectTo('/signInPage');
      }
      if (toLocation == '/signInPage' && userIsSigned) {
        return data.redirectTo('/homePage');
      }
      //You can also check query or path parameters
      if (data.queryParams['userId'] == '1') {
        return data.redirectTo('/superUserPage');
      }
    },
    routes: {
      '/signInPage': (RouteData data) => SignInPage(),
      '/homePage': (RouteData data) => HomePage(),
    },
  );
```
If the app is navigating to `'/homePage'` and if the user is not signed yet, the app is redirected to navigate to the sign in page.

Also if the app is navigating to `'/signInPage'` and if the user is already signed, the app is redirected to navigate to the home screen. 

You can check for any property the `RouteData` exposes.
Head to [**Redirection**](#redirection)  section for more information.

See `onNavigate` en action following this [example](https://github.com/GIfatahTH/navigation_builder/blob/dev/example/lib/ex08_on_navigate_redirection_from.dart).

### onNavigateBack
This callback is fired every time a route is removed and the app navigate back.
It can be used to prevent leaving a page unless data is validated.

 ```dart
  final myNavigator = NavigationBuilder.create(
    onNavigateBack: (RouteData data) {
      if(data == null){
        // onNavigateBack is called with null data when the hard back button of Android 
        // device is pressed with no page to go back to (the tack route length is one)

        // Typically here we display a dialog to let the user to choose between staying 
        // in the app or exiting

        // return true, the app exists
        // return false the app stay alive

        return false;
      }
      final backFrom = data.location;
      if (backFrom == '/SingInFormPage' && formIsNotSaved) {
        myNavigator.toDialog(
          AlertDialog(
            content: Text('The form is not saved yet! Do you want to exit?'),
            actions: [
              ElevatedButton(
                onPressed: () => myNavigator.forceBack(),
                child: Text('Yes'),
              ),
              ElevatedButton(
                onPressed: () => myNavigator.back(),
                child: Text('No'),
              ),
            ],
          ),
        );

        return false;
      }
    },
    routes: {
      '/SingInFormPage': (RouteData data) => SingInFormPage(),
      '/homePage': (RouteData data) => HomePage(),
    },
  );
 ```

Here if the app is navigating back from sign in form page and if the form is not saved yet, the back navigation is cancelled and a `Dialog` is popped asking for back navigation confirmation.

If the user chooses No, the app stays in the sign form page. In contrast if the user choose YES, the app is forcefully popped and both the `Dialog` and the sign in form page are removed from the routing stack.

Here is a working [example](https://github.com/GIfatahTH/navigation_builder/blob/dev/example/lib/ex10_on_back_navigation.dart) using `onNavigateBack`.

### debugPrintWhenRouted
If set to true, a message is printed in the console informing us about the state of the navigation.



This is the full `NavigationBuilder.create` API
```dart
NavigationBuilder injectNavigator({
  required Map<String, Widget Function(RouteData)> routes,
  String? initialLocation,
  Widget Function(String)? unknownRoute,
  Widget Function(Widget)? builder,
  Page<dynamic> Function(MaterialPageArgument)? pageBuilder,
  bool shouldUseCupertinoPage = false,
  Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)? transitionsBuilder,
  Duration? transitionDuration,
  Redirect? Function(RouteData)? onNavigate,
  bool? Function(RouteData)? onNavigateBack,
  bool debugPrintWhenRouted = false,
  bool ignoreUnknownRoutes =false,
})
```

## Navigation
After defining `NavigationBuilder` variable and setting `MaterialApp.router`, your app is ready for navigation witch can be done imperatively or declaratively.
### Imperative navigation
To navigate imperatively, we use one of the methods defined in our `NavigationBuilder` object which we suppose to name `myNavigator`: 

* `myNavigator.to('/page1')`:  
Here '`/page1'` route will be added on top of the route stack.
  If you are used to Navigator 1 API, `myNavigator.to('/page1')` is exactly equivalent to `myNavigator.toNamed('/page1')`. You still can use both with Navigator 2.
  ```dart
  Future<T?> to<T extends Object?>(
    String routeName, {
    Object? arguments,
    Map<String, String>? queryParams,
    bool fullscreenDialog = false,
    bool maintainState = true,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)? transitionsBuilder,
  })
  ```
  You can pass `arguments` or `queryParams` to the route. You can also decide whether the route is `fullscreenDialog` and whether to `maintainsState` or not.
  You can also override the global page transition with the one you define here via the `transitionBuilder` parameter. The `transitionBuilder` defined here will be applied to this particular navigation call. Any further call of `myNavigator.to` method will use the default page transition.

  You can wait for results from the push route:
  ```dart
      onPressed: ()async {
       final result = await myNavigator.to('/page1');
       //  On page `'/page1'`, if you call `myNavigator.back('This is the result')`
       print(result); // prints 'This is the result'
      }
  ```

  This is a working [example](https://github.com/GIfatahTH/navigation_builder/blob/dev/example/lib/ex02_imperative_navigation.dart).

* `myNavigator.toDeeply('/page1/page11')`: Deeply navigate to the given routeName. Deep navigation means that the root stack is cleaned and pages corresponding to sub paths are added to the stack.
  Suppose our navigator is :
  ```dart
   final myNavigator = NavigationBuilder.create(
     routes: {
       '/': (RouteData data) => HomePage(),
       '/page1': (RouteData data) => Page1(),
       '/page1/page11': (RouteData data) => Page11(),
       '/page1/page11/page111': (RouteData data) => Page111(),
     },
   );
  ```
  On app start up, the route stack is `['/']`.
  If we call `myNavigator.to('/page1/page11/page111')`, the route stack is `['/', '/page1/page11/page111']`.
  In contrast, if we invoke `myNavigator.toDeeply('/page1/page11/page111')`, the route stack is `['/', '/page1', '/page1/page11', '/page1/page11/page111']`.

  This is a working [example](https://github.com/GIfatahTH/navigation_builder/blob/dev/example/lib/ex04_to_deeply_1.dart).

* `myNavigator.toReplacement('/page1')`:  Here '`/page1'` route will be added on top of the route stack and the last page will be removed.
  This is exactly equivalent to `myNavigator.toReplacementNamed('/page1')`. You still can use both with Navigator 2.
  ```dart
  Future<T?> toReplacement<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    Map<String, String>? queryParams,
    bool fullscreenDialog = false,
    bool maintainState = true,
  })
  ```

* `myNavigator.toAndRemoveUntil('/page1')`:  Here '`/page1'` route will be added on top of the route stack and all the previous routes until meeting the route with defined route name `untilRouteName` are removed.
  If the argument `untilRouteName` is not defined, all previous pages are removed.
  This is exactly equivalent to `myNavigator.toNamedAndRemoveUntil('/page1')`. You still can use both with Navigator 2.
  ```dart
  Future<T?> toAndRemoveUntil<T extends Object?>(
    String newRouteName, {
    String? untilRouteName,
    Object? arguments,
    Map<String, String>? queryParams,
    bool fullscreenDialog = false,
    bool maintainState = true,
  })
  ```
    
* `myNavigator.back()`:  Pop the top-most route off the route stack.
  You can pass a result to complete the future that had been returned from pushing the popped route.
  This is exactly equivalent to `myNavigator.back()`. You still can use both with Navigator 2.
  ```dart
  void back<T extends Object>([T? result])
  ```

* `myNavigator.forceBack()`:  Pop the top-most route off the route stack with all pageless route associated with it and without calling `onNavigateBack` hook.
  This is exactly equivalent to `myNavigator.forceBack()`.
  ```dart
  void forceBack<T extends Object>([T? result])
  ```

  **The difference between `back` and `forceBack`:**
  `back` invokes `onNavigateBack` hook and pops the top most route carelessly its a page or pageless route. For example, if a `Dialog` (a `Dialog` is an example pageless route) is displayed and we invoke `back`, only the Dialog is popped off.
  In Contrast `forceBack` does not invoke `onNavigateBack` hook and pops the top most page route with all pageless routes associated with it. For example, if a `Dialog` is displayed and we invoke `forceBack`, the dialog and the top most page route are popped off.

  Here is an example where we want to prevent the user from leaving the from page before save data:
   ```dart
  final myForm = RM.injectForm();

  //
  final myNavigator = NavigationBuilder.create(
    onNavigateBack: (RouteData data) {
      final backFrom = data.location;

      // an InjectedForm is dirty when data is modified and not saved yet
      if (backFrom == '/SingInFormPage' && myForm.isDirty) {
        myNavigator.toDialog(
          AlertDialog(
            content: Text('The form is not saved yet! Do you want to exit?'),
            actions: [
              ElevatedButton(
                // Pop off hte Dialog and exit the SingInFormPage
                onPressed: () => myNavigator.forceBack(),
                child: Text('Yes'),
              ),
              ElevatedButton(
                // Pop off hte Dialog and stay in the SingInFormPage
                onPressed: () => myNavigator.back(),
                child: Text('No'),
              ),
            ],
          ),
        );

        return false;
      }
    },
    routes: {
      '/SingInFormPage': (RouteData data) => SingInFormPage(),
      '/homePage': (RouteData data) => HomePage(),
    },
  );
  ```

  Here is The working [example](https://github.com/GIfatahTH/navigation_builder/blob/dev/example/lib/ex09_on_navigate_signin.dart).

* `myNavigator.backUntil('/page1')`:  Navigate back and remove all the previous routes until meeting the route with defined name.
  This is exactly equivalent to `myNavigator.backUntil('/page1')`.
  ```dart
  void backUntil(String untilRouteName)
  ```
### Declarative navigation

In declarative navigation you have access to a copy of the route stack and you have the freedom to return a new stack the way you like.

```dart
myNavigator.setRouteStack(
  (pages){
    // exposes a copy of the current route stack
    return [...newPagesList];
  }
)
```

By default the exposes copy of route stack is that of the root route stack. If you are working with nested routes, each sub route will have its own stack.

To declaratively set the stack of a sub route use the `subRouteName` parameter.


```dart
myNavigator.setRouteStack(
  (pages){
    // exposes a copy of the current route stack
    return [...newPagesList];
  },
  subRouteName: '/page1',
)
```

Here is The working [example](https://github.com/GIfatahTH/navigation_builder/blob/dev/example/lib/ex01_declarative_navigation.dart).

### Pageless navigation
Here is a quote from [Flutter documentation](https://docs.google.com/document/d/1Q0jx0l4-xymph9O6zLaOY4d_f7YFpNWX_eGbzYxr9wY/edit#heading=h.8ekjskfa3zkl):

>> The section introduces the concept of Pages to the Navigator and divides the Routes managed by the Navigator into two groups: Some Routes are backed by a Page, others are not. The latter are called pageless Routes. 

### Push a Widget route
```dart
 myNavigator.toPageless(NextPage()); 
 myNavigator.to(NextPage()); 
```
You can specify a name to the route  (e.g., "/settings"). It will be used with `backUntil`, `toAndRemoveUntil`, `toAndRemoveUntil`, and `toNamedAndRemoveUntil`.
```dart
 myNavigator.to(NextPage(), name: '/routeName');

 // calling backUntil:
myNavigator.backUntil('/routeName'); // Flutter: popUntil
```
### Dialogs and Sheets
Dialogs when displayed are pushed into the route stack. It is for this reason, in navigation_builder, dialogs are treated as navigation:

In Flutter to show a dialog:
```dart
showDialog<T>(
    context: myNavigator.navigationContext,
    builder: (_) => Dialog(),
);
```
In navigation_builder to show a dialog:

```dart
myNavigator.navigationContext.toDialog(Dialog());
// To close the dialog
myNavigator.back();
```
For sure, navigation_builder is less boilerplate, but it is also more intuitive.
In navigation_builder we make it clear that we are navigating to the dialog, so to close a dialog, we just pop it from the route stack.

So navigation_builder follows the naming convention as in Flutter SDK, with the change from `show` in Flutter to` to` in navigation_builder.

#### Show a material dialog:
```dart
 myNavigator.toDialog(DialogWidget()); // Flutter: showDialog
 // To close the dialog
myNavigator.back();
```

#### Show a cupertino dialog:
```dart
 myNavigator.toCupertinoDialog(CupertinoDialogWidget()); // Flutter: showCupertinoDialog
 // To close the dialog
myNavigator.back();
```

#### Show a Cupertino dialog:
```dart
 myNavigator.toBottomSheet(BottomSheetWidget()); // Flutter: showModalBottomSheet
 // To close the bottom sheet
myNavigator.back();
```

#### Show a Cupertino dialog:
```dart
 myNavigator.toCupertinoModalPopup(CupertinoModalPopupWidget()); // Flutter: showCupertinoModalPopup
 // To close the CupertinoModalPopup
myNavigator.back();
```

For all other dialogs, menus, bottom sheets, not mentioned here, you can use is as defined by flutter using `myNavigator.navigationContext`:
example:
```dart
 showSearch(
     context: myNavigator.navigationContext, 
     delegate: MyDelegate(),
 )
```
### Show bottom sheets, snackBars and drawers that depend on the Scaffold

Some side effects require a BuildContext of a scaffold child widget.

With navigation_builder to be able to display them outside the widget tree without explicitly specifying the BuildContext, we need to tell states_rebuild which BuildContext to use first.

This can be done either:

```dart
    onPressed: () {
       myNavigator.scaffold.context= context;
       myNavigator.scaffold.showBottomSheet(...);
    }
```

To hide or remove a SnackBar:
```dart
    onPressed: () {
        myNavigator.scaffold.hideCurrentSnackBar();
        myNavigator.scaffold.removeCurrentSnackBar();
    }
```

### Show a persistent bottom-sheet:
```dart
 myNavigator.scaffold.showBottomSheet(BottomSheetWidget()); // Flutter: Scaffold.of(context).showBottomSheet
```

To close a persistent bottom-sheet :
```dart
    onPressed: () {
        myNavigator.back();
    }
```
### Show a snackbar:
```dart
 myNavigator.scaffold.showSnackBar(SnackBarWidget()); // Flutter: Scaffold.of(context).showSnackBar
```
### Open a drawer:
```dart
 myNavigator.scaffold.openDrawer(); // Flutter: Scaffold.of(context).openDrawer
```
To close a drawer :
```dart
    onPressed: () {
        myNavigator.scaffold.closeDrawer()
        // Or just call back
        myNavigator.back();
    }
```
### Open an end drawer:
```dart
 myNavigator.scaffold.openEndDrawer(); // Flutter: Scaffold.of(context).openEndDrawer
```

To close a drawer :
```dart
    onPressed: () {
        myNavigator.scaffold.closeEndDrawer()
        // Or just call back
        myNavigator.back();
    }
```


For anything, not mentioned here, you can use the scaffoldState exposed by navigation_builder.

Head [Here](https://github.com/GIfatahTH/navigation_builder/blob/dev/example/lib/ex19_dialogs.dart) to see different level of page transition animation example.


## Page transition animation
Pages are transited using the default `Flutter` animation depending on the target platform.

Page transition can be customized for there levels:

## Global level transition
  While defining `NavigationBuilder` object, you can set your custom page transition animation to be used for all route transitions.
  ```dart
   final myNavigator = NavigationBuilder.create(
     transitionsBuilder: (context, animation, secondaryAnimation, child) {
       return // Your page transition implementation
     },
     routes: {
       ... 
     },
   );
  ```

## Route level transition
   You can dedicate a particular page transition to a specific route while other routes still use the default page transition.
  ```dart
      final myNavigator = NavigationBuilder.create(
        // Default transition
        transitionDuration: RM.transitions.leftToRight(),
        routes: {
          '/': (_) => HomePage(),
          '/Page1': (_) => RouteWidget(
                builder: (_) => Page1(),
                // You can use one of the predefined transitions
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    // Custom transition implementation
                  return ...;
                },
              ),
          '/page2': (_) => Page2(),
        },
      );
  ```
    Pages `'/'` and `'/page2'` will use the default transition whereas `'/page1'` will use its own defined custom page transition.

## Navigation call level transition
   You can customize the page transition for a particular navigation call:
  ```dart
    myNavigator.to(
      '/page1',
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Custom transition implementation
        return ...;
      },
    )
  ```   
    The defined transition here will be used once for this navigation call.Any further call of `myNavigator.to` method will use the default page transition or the route transition in case it is used.

You are free to defined the transition you want using the parameters exposed by `transitionBuilder`.  For example:
```dart
final myNavigator = NavigationBuilder.create(
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation.drive(
        CurveTween(curve: Curves.easeIn),
      ),
      child: child,
    );
  },
  routes: {
    ...
  },
);
```

You can also use one of the predefined page transitions:

```dart
NavigationBuilder.transitions.bottomToUp();
NavigationBuilder.transitions.upToBottom();
NavigationBuilder.transitions.leftToRight();
NavigationBuilder.transitions.rightToLeft();
NavigationBuilder.transitions.none(); // Pages are transited instantly without animation
```

Other predefined page transitions can be added in the future.

Head [Here](https://github.com/GIfatahTH/navigation_builder/blob/dev/example/lib/ex11_page_transition1.dart) to see different level of page transition animation example.

## Customized primary and secondary animation

You can get the page animation and secondary animation form any page using `context.animation` and `context.secondaryAnimation` relying on `InheritedWidget` principle.

You can use the obtained animations to customize the incoming page animation.

Here is an [**example**](https://github.com/GIfatahTH/navigation_builder/blob/dev/example/lib/12_page_transition2.dart) using this concept inspired form ResoCoder's tutorial, [**Flutter custom staggered page transition animation**]( https://resocoder.com/2020/05/26/flutter-custom-staggered-page-transition-animation-tutorial/).


<!-- // TODO -->
## Nested routes

## Redirection
Route redirection can be done in two levels, at route level and in global level.

If a route is redirected in both route and global level, the route level takes the priority over the global redirection.
### Route level redirection

```dart
  final NavigationBuilder myNavigator = NavigationBuilder.create(
     // Define your routes map
     routes: {
       '/': (RouteData data) => data.redirectTo('/home'),
       '/home': (RouteData data) => Home(),
        // redirect all paths that starts with '/home' to '/home' path
       '/home/*': (RouteData data) => data.redirectTo('/home'),
       // redirect dynamic links
       '/books/:bookId/authors': (RouteData data) => data.redirectTo('/authors'),
       '/authors': (RouteData data) {
            // As we are redirected here from '/books/:bookId/authors' we can get the book id.
           final bookId = data.pathParam['bookId'];

            // The location we are redirected from.
            // For example `books/1/authors`
           final redirectedFrom = data.redirectedFrom.location; 
           // Or inside Authors widget we use context.routeData.redirectedFrom.location
           return Authors();
        },
     },
   );
```

From the route you are redirected to, you can obtain information about the route you are redirected from via `RouteData.redirectedFrom` field.

For example, from the route `/books/:bookId/authors` we are redirected to the `/authors` route. From the latter route we can get the bookId and display the author of the book.

### Global redirection
Global redirections are done inside `OnNavigate` callBack.
```dart
  final myNavigator = NavigationBuilder.create(
    onNavigate: (RouteData data) {
      final toLocation = data.location;
      if (toLocation != '/signInPage' && userIsNotSigned) {
        return data.redirectTo('/signInPage');
      }
      if (toLocation == '/signInPage' && userIsSigned) {
        return data.redirectTo('/homePage');
      }
      //You can also check query or path parameters
      if (data.queryParams['userId'] == '1') {
        return data.redirectTo('/superUserPage');
      }
    },
    routes: {
      '/signInPage': (RouteData data) => SignInPage(),
      '/homePage': (RouteData data) => HomePage(),
    },
  );
```


If the user is not signed in and if he is navigating to any page other than the sign in page, he will be redirected to the sign in page.

Form the sign in page, the user must sign in first to be able to continue. 

From the `/signInPage` page we can get the location the user is redirected from and let him navigate to it.

Here is what may the sign in method look like:
```dart
void signIn(String name, String password) async {
  final success = await repository.signIn(name, password);
  if(success){
    // Here the user is successfully signed in.
    final locationRedirectedFrom = context.routeData.redirectedFrom?.location;

    if(locationRedirectedFrom != null){
      // If the app is redirected form any location (deep link for example), it will continue navigate to it.
      myNavigator.to(locationRedirectedFrom);
    }else{
      // If the app accesses the 'signInPage' directly without redirection, it will navigate to the home page for example.
      myNavigator.to('homePage');
    }
  }
}
```

Here is The full example [**example**](https://github.com/GIfatahTH/navigation_builder/blob/dev/example/lib/09_on_navigate_signin.dart) 

### Cyclic redirection
Do not fear cyclic redirection. If it happens the unknownRoute is pushed.

```dart
final navigator = NavigationBuilder.create(
  routes: {
    '/': (data) => data.redirectTo('/home'),
    '/home': (data) => const HomePage(),
    // page1 redirect to itself
    '/page1': (data) => data.redirectTo('/page1'),
    // page2 redirect to page3 and page3 redirect back to page2
    '/page2': (data) => data.redirectTo('/page3'),
    '/page3': (data) => data.redirectTo('/page2'),
    // /page4 route is redirect form onNavigate callback to page5
    // and page5 redirect locally to page4
    '/page4': (data) => const PageWidget(title: 'Never Reached Page'),
    '/page5': (data) => data.redirectTo('/page4'),
  },
  onNavigate: (data) {
    final location = data.location;
    if (location == '/page4') {
      return data.redirectTo('/page5');
    }
  },
);
```

Here is the working [**example**](https://github.com/GIfatahTH/navigation_builder/blob/dev/example/lib/ex07_on_navigate_cyclic_redirect.dart) 

<!-- // TODO -->
## `myNavigator.canPop`
<!-- // TODO -->
## `myNavigator.routeData`
<!-- // TODO -->
## `myNavigator.injectMock`

