import 'package:flutter/material.dart';

import 'avatar.dart';

class ProfilePicture extends StatelessWidget {
  final String name;

  final String? role;
  final double radius;
  final double fontsize;

  final bool tooltip;

  final int? count;

  final String? img;
  const ProfilePicture({
    Key? key,
    required this.name,
    required this.radius,
    required this.fontsize,
    this.role,
    this.tooltip = false,
    this.count,
    this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Avatar(
      radius: radius,
      name: name,
      fontsize: fontsize,
      count: count,
      img: img,
    );
  }
}
