import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void customNavigate(BuildContext context, Widget destination) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}

void customReplacementNavigate(context, String path) {
  GoRouter.of(context).pushReplacement(path);
}
