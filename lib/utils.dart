import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Utils {
  static showSnack(BuildContext context, String msg, {Duration? duration}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: duration ?? const Duration(milliseconds: 4000),
    ));
  }

  static showErrorSnack(BuildContext context, String msg,
      {Duration? duration}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
          duration: duration ?? const Duration(milliseconds: 4000)),
    );
  }

  static showSuccessSnack(BuildContext context, String msg,
      {Duration? duration}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: Colors.green,
          duration: duration ?? const Duration(milliseconds: 4000)),
    );
  }
}

class NoRecord extends StatelessWidget {
  final String? reason;
  final Widget? icon;

  const NoRecord({super.key, this.icon, this.onRefresh, this.reason});

  final AsyncCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return onRefresh == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon ??
                    Image.asset(
                      'assets/icons/not_found.png',
                      height: 160,
                      width: 160,
                    ),
                const SizedBox(height: 8),
                Text(reason ?? 'No Record Found',
                    style: const TextStyle(fontSize: 28)),
              ],
            ),
          )
        : RefreshIndicator(
            onRefresh: onRefresh!,
            child: Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon ??
                        Image.asset(
                          'assets/icons/not_found.png',
                          height: 160,
                          width: 160,
                        ),
                    const SizedBox(height: 8),
                    Text(reason ?? 'No Record Found',
                        style: const TextStyle(fontSize: 28)),
                  ],
                ),
              ),
            ));
  }
}
