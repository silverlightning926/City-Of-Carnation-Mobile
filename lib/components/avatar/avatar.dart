import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/extends/input_text.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    required this.radius,
    required this.name,
    required this.fontsize,
    this.random = false,
    this.count,
    this.img,
  }) : super(key: key);

  final double radius;
  final String name;
  final double fontsize;
  final bool random;
  final int? count;
  final String? img;

  @override
  Widget build(BuildContext context) {
    return img == null
        ? NoImage(
            radius: radius,
            name: name,
            count: count,
            fontsize: fontsize,
            random: random)
        : WithImage(radius: radius, img: img!);
  }
}

class WithImage extends StatelessWidget {
  const WithImage({
    Key? key,
    required this.radius,
    required this.img,
  }) : super(key: key);

  final double radius;
  final String img;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: CachedNetworkImageProvider(img),
      backgroundColor: Colors.transparent,
    );
  }
}

// if no image
class NoImage extends StatelessWidget {
  const NoImage({
    Key? key,
    required this.radius,
    required this.name,
    required this.count,
    required this.fontsize,
    required this.random,
  }) : super(key: key);

  final double radius;
  final String name;
  final int? count;
  final double fontsize;
  final bool random;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.purple,
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, 2),
            blurRadius: 10,
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 3,
          )
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        child: Text(
          name == '' ? '' : InitialName.parseName(name, count).toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: fontsize,
              ),
        ),
      ),
    );
  }
}
