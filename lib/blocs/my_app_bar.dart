import 'package:flutter/material.dart';

PreferredSizeWidget myAppBar({Function? onBackButton}) {
  return AppBar(
    leading: onBackButton != null
        ? IconButton(
            onPressed: () {
              onBackButton();
            },
            icon: Icon(Icons.arrow_back_ios),
          )
        : Text(''),
    centerTitle: true,
    title: Text('Super Lista'),
  );
}
