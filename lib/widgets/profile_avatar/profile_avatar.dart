import 'package:cached_network_image/cached_network_image.dart';
import 'package:coozy_cafe/config/app_color/app_color.dart';
import 'package:coozy_cafe/utlis/components/string_image_path.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final bool isActive;
  final bool hasBorder;

  const ProfileAvatar({
    Key? key,
    required this.imageUrl,
    this.isActive = false,
    this.hasBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: CachedNetworkImage(
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: CircleAvatar(
                radius: hasBorder ? 17.0 : 20.0,
                backgroundColor: Colors.grey[200],
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: hasBorder ? 17.0 : 20.0,
              backgroundColor: Colors.grey.shade200,
              child: Image.asset(
                StringImagePath.place_holder_profile_user,
                fit: BoxFit.fill,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            fit: BoxFit.fill,
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) {
              return CircleAvatar(
                radius: hasBorder ? 17.0 : 20.0,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: imageProvider,
              );
            },
          ),
        ),
        isActive
            ? Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Container(
                  height: 15.0,
                  width: 15.0,
                  decoration: BoxDecoration(
                      color: AppColor.online,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2.0,
                        color: Colors.white,
                      )),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
