import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  // Navigate to a new screen (push)
  void push(Widget page) {
    Navigator.of(this).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Navigate to a new screen by name (pushNamed)
  void pushNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  // Navigate to a new screen and remove the current one (pushReplacement)
  void pushReplacement(Widget page) {
    Navigator.of(this).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Navigate to a new screen by name and remove the current one (pushReplacementNamed)
  void pushReplacementNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }

  // Navigate to a new screen and clear all previous screens (pushAndRemoveUntil)
  void pushAndRemoveUntil(Widget page) {
    Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }

  // Navigate to a new screen by name and clear all previous screens (pushNamedAndRemoveUntil)
  void pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamedAndRemoveUntil(routeName, (route) => false,
        arguments: arguments);
  }

  // Pop the current screen
  void pop([Object? result]) {
    Navigator.of(this).pop(result);
  }

  // Pop the current screen until a condition is met (popUntil)
  void popUntil(bool Function(Route<dynamic>) predicate) {
    Navigator.of(this).popUntil(predicate);
  }

  // Check if can pop (canPop)
  bool canPop() {
    return Navigator.of(this).canPop();
  }

  // Pop current screen and return a result (maybePop)
  Future<bool> maybePop([Object? result]) {
    return Navigator.of(this).maybePop(result);
  }
}
/*
*
* // Push a new screen (navigate to a new screen)
context.push(MyNewScreen());

/* Example:
Navigates to a new screen by passing the Widget (MyNewScreen).
This pushes the screen onto the navigation stack, allowing you to go back to the previous one.
*/

// Push a screen by route name
context.pushNamed('/home');

/* Example:
Navigates to a new screen using its route name (e.g., '/home').
Useful when you manage routes via a route table.
*/

// Push and replace the current screen (remove the current screen and push a new one)
context.pushReplacement(MyNewScreen());

/* Example:
Replaces the current screen with a new one, so you can't go back to the previous one.
Ideal for cases like a login screen that shouldn't be accessible after logging in.
*/

// Push and replace by route name
context.pushReplacementNamed('/home');

/* Example:
Replaces the current screen by using the route name instead of a widget.
Good for navigating between named routes when replacing the screen.
*/

// Push and remove all previous screens (clear the navigation stack)
context.pushAndRemoveUntil(MyNewScreen());

/* Example:
Pushes a new screen and removes all previous screens from the stack.
This is useful when you want to reset the navigation, such as after logging out and returning to the login screen.
*/

// Push and remove until the condition is met (by route name)
context.pushNamedAndRemoveUntil('/login');

/* Example:
Pushes a named route and removes all previous routes until a condition is met.
In this case, it removes all previous routes and only keeps the '/login' route.
*/

// Pop the current screen (go back)
context.pop();

/* Example:
Pops the top screen from the navigation stack, going back to the previous screen.
Useful for actions like closing modals or going back in navigation.
*/

// Pop until a specific route is found
context.popUntil((route) => route.isFirst);

/* Example:
Pops the current screen and keeps popping screens until a certain condition is met.
In this case, it will keep popping until the first screen in the stack is reached.
*/

// Check if the current screen can pop (is there something to go back to?)
if (context.canPop()) {
  context.pop();
}

/* Example:
Checks if the current screen can be popped (i.e., if there is a previous screen to go back to).
Useful for handling back button behavior.
*/

// Pop current screen and return a result (conditional pop)
context.maybePop();

/* Example:
Attempts to pop the current screen but might fail if the pop isn't allowed.
Returns a Future that resolves to `true` if the pop was successful, `false` otherwise.
*/
 */
