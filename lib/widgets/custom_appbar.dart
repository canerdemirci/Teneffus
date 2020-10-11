import 'package:flutter/material.dart';
import 'package:teneffus/constants.dart';

AppBar customAppBar(String title, bool appTitle) => AppBar(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(.6),
      centerTitle: appTitle ? true : false,
      title: Text(title, style: appTitle ? appMainTitleStyle : appTitleStyle),
    );
