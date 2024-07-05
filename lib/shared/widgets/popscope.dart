import 'package:flutter/material.dart';

class PopScope extends StatelessWidget {
  final Widget child;

  const PopScope({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Handle the back button press logic here
        // If there are no pages to pop, you can show a dialog or do something else
        if (Navigator.of(context).canPop()) {
          return true;
        } else {
          // Show a dialog or perform another action
          showExitConfirmationDialog(context);
          return false;
        }
      },
      pages: [
        MaterialPage(child: child),
      ],
    );
  }

  void showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Exit the app
              // SystemNavigator.pop(); // Uncomment this line to actually exit the app
            },
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }
}
