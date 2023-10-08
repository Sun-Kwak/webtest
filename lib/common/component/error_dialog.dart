import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:web_test2/common/const/colors.dart';

class ErrorDialog extends StatelessWidget {
  final String error;

  const ErrorDialog._(this.error, {Key? key}) : super(key: key);

  static Future<void> show(BuildContext context, String errorMessage) {
    return showDialog(
      context: context,
      builder: (_) => ErrorDialog._(errorMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(error),
      actions: [
        TextButton(
          child: const Text('확인'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class LoadingSheet extends StatelessWidget {
  const LoadingSheet._({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (_) => const LoadingSheet._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Center(
        child: LoadingAnimationWidget.flickr(
          leftDotColor: PRIMARY_COLOR,
          rightDotColor: CONSTRAINT_PRIMARY_COLOR,
          size: 50,
        ),
      ),
    );
  }
}

// LoadingAnimationWidget.flickr(
// leftDotColor: PRIMARY_COLOR,
// rightDotColor: CONSTRAINT_PRIMARY_COLOR,
// size: 80,
