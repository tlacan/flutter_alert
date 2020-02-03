// TODO: remove this dependency!
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
// TODO: remove this dependency!
import 'package:flutter/material.dart';

import 'package:flutter_alert/flutter_alert.dart';

/// Shows an alert dialog with the official flutter cupertino package.
void showCupertinoAlert({
  /// A build context. Required.
  @required BuildContext context,

  /// The title of the modal dialog.
  String title,

  /// The body (or content) of the modal dialog.
  /// The text was automatically rendered in a ScrollView.
  String body,

  /// A List of actions. For each action there was shown one button.
  /// If there was no action defined, a default action with a
  /// (localized) "OK" button was shown.
  List<AlertAction> actions,

  List<Widget> customContent,

  /// Allow you to define if the alert dialog is closable when
  /// the users taps beside the alert dialog.
  /// Default is only true when cancelable is set to true
  /// and the platform is not iOS.
  bool barrierDismissible,

  /// Automatically adds a (localized) "Cancel" button to the list
  /// of buttons. Currently its not possible to handle the cancel
  /// button.
  /// Only if this option was set to true. The default is false.
  bool cancelable = false,
}) {
  if (actions == null || actions.isEmpty) {
    actions = [
      AlertAction(
          text: MaterialLocalizations.of(context).okButtonLabel,
          onPressed: () {})
    ];
  }
  if (barrierDismissible == null) {
    barrierDismissible = cancelable && !Platform.isIOS;
  }
  if (cancelable) {
    actions.add(AlertAction(
        text: MaterialLocalizations.of(context)
                .cancelButtonLabel
                .substring(0, 1) +
            MaterialLocalizations.of(context)
                .cancelButtonLabel
                .substring(1)
                .toLowerCase(),
        onPressed: () {}));
  }

  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
          title: _buildTitle(title),
          content: _buildBody(body, customContent),
          actions: actions
              .map((AlertAction action) =>
                  _buildCupertinoActionButton(context, action))
              .toList(),
        ),
  );
}

Widget _buildTitle(String title) {
  if (title == null || title.isEmpty) {
    return null;
  }
  return Text(title);
}

Widget _buildBody(String body, List<Widget> customContent) {
  if (body == null || body.isEmpty) {
    return null;
  }
  if (customContent == null) {
    return SingleChildScrollView(child: Text(body));
  }
  List<Widget> content = [Text(body)];
  content.addAll(customContent);
  return Material(child:
          SingleChildScrollView(child: 
            Column(
              children: content,
            )
          ),
          color: Colors.transparent,
        );
}

Widget _buildCupertinoActionButton(BuildContext context, AlertAction action) {
  VoidCallback onPressed = () {
    if (action.automaticallyPopNavigation) {
      NavigatorState navigatorState = Navigator.of(context);
      if (navigatorState.canPop()) {
        navigatorState.pop();
      }
    }
    if (action.onPressed != null) {
      action.onPressed();
    }
  };

  return CupertinoDialogAction(
    child: Text(
      action.text != null ? action.text : "",
      style: action.isDefaultAction
          ? TextStyle(fontWeight: FontWeight.bold)
          : null,
    ),
    isDefaultAction: action.isDefaultAction,
    isDestructiveAction: action.isDestructiveAction,
    onPressed: onPressed,
  );
}
