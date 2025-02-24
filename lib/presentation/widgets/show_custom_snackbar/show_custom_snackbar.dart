import 'package:flutter/material.dart';

showCustomSnackbar(BuildContext context, String message,
    {bool isError = false}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          isError ? Icons.error : Icons.check_circle,
          color: Colors.white,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ))
      ],
    ),
    backgroundColor: isError? Colors.black12: Colors.black87,
    duration: const Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    ),
    margin: const EdgeInsets.symmetric(horizontal: 60,vertical: 60),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
