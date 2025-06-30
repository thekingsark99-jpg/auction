import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:get/get.dart';

import '../../../core/models/account.dart';
import '../../../core/navigator.dart';
import '../../../theme/extensions/base.dart';
import '../../../widgets/common/image_error.dart';
import '../../profile/details/index.dart';

class CommentAccountAvatar extends StatelessWidget {
  final Account account;
  final bool? small;

  CommentAccountAvatar({required this.account, this.small});

  final navigatorService = Get.find<NavigatorService>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigatorService.push(
          ProfileDetailsScreen(
            accountId: account.id,
          ),
          NavigationStyle.SharedAxis,
        );
      },
      child: Container(
        width: small == true ? 30 : 40,
        height: small == true ? 30 : 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color:
                Theme.of(context).extension<CustomThemeFields>()!.background_2,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          child: account.picture == ''
              ? Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: Svg(
                        'assets/icons/svg/user.svg',
                      ),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: account.picture,
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  maxWidthDiskCache: small == true ? 30 : 40,
                  maxHeightDiskCache: small == true ? 30 : 40,
                  errorWidget: (context, url, error) =>
                      const ImageErrorWidget(),
                ),
        ),
      ),
    );
  }
}
