import 'package:flutter/material.dart';

PreferredSizeWidget myAppBar({Function? onBackButton}) {
  return AppBar(
    leading: onBackButton != null
        ? IconButton(
            onPressed: () {
              onBackButton();
            },
            icon: const Icon(Icons.arrow_back_ios),
          )
        : const Text(''),
    centerTitle: true,
    title: const Text('Super Lista'),
  );
}
