import 'package:easy_localization/easy_localization.dart';
import 'package:biddo/theme/extensions/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../../../core/controllers/flash.dart';
import '../../../../core/controllers/review.dart';
import '../../../../core/models/review.dart';
import '../../../../core/navigator.dart';
import '../../../../core/services/lang_detector.dart';
import '../../../../theme/colors.dart';
import '../../../../utils/generic.dart';
import '../../../../widgets/common/user_avatar.dart';
import '../../../auction-details/index.dart';
import '../index.dart';

class ReviewItem extends StatefulWidget {
  final Review review;

  ReviewItem({
    super.key,
    required this.review,
  });

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  final navigatorService = Get.find<NavigatorService>();
  final flashController = Get.find<FlashController>();
  final reviewController = Get.find<ReviewsController>();
  final languageDetectorService = Get.find<LanguageDetectorService>();

  var _translatedDescription = '';
  var _translationInProgress = false;
  var _showTranslatedDetails = false;

  Future<void> handleTranslate() async {
    if (_translationInProgress) {
      return;
    }

    if (_showTranslatedDetails) {
      setState(() {
        _showTranslatedDetails = false;
      });
      return;
    }

    setState(() {
      _translationInProgress = true;
    });

    try {
      var translated = await reviewController.translate(
        widget.review.id,
        context.locale.toString(),
      );

      if (translated == null) {
        flashController.showMessageFlash(tr('generic.short_error'));
        return;
      }

      setState(() {
        _translatedDescription = translated;
        _showTranslatedDetails = true;
      });
    } catch (error) {
      flashController.showMessageFlash(tr('generic.short_error'));
    } finally {
      setState(() {
        _translationInProgress = false;
      });
    }
  }

  Widget _renderTranslateAction() {
    var currentLanguage = context.locale.toString();

    var descriptionLanguage =
        languageDetectorService.detectLanguage(widget.review.description);

    var translationEnabled =
        (descriptionLanguage != null && descriptionLanguage != currentLanguage);

    if (!translationEnabled) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        handleTranslate();
      },
      child: Container(
        height: 17,
        margin: EdgeInsets.only(top: 16, bottom: 8),
        child: Row(
          children: [
            _translationInProgress
                ? const SpinKitThreeBounce(
                    color: DarkColors.font_1,
                    size: 17,
                  )
                : Text(
                    _showTranslatedDetails
                        ? 'generic.see_original'
                        : 'generic.translate',
                    style: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .smallest
                        .copyWith(color: Colors.blue),
                  ).tr(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 8,
      ),
      padding: const EdgeInsets.all(8),
      width: Get.width,
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).extension<CustomThemeFields>()!.separator),
        color: Theme.of(context)
            .extension<CustomThemeFields>()!
            .separator
            .withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              navigatorService.push(
                ProfileDetailsScreen(
                  accountId: widget.review.reviewer!.id,
                ),
                NavigationStyle.SharedAxis,
              );
            },
            child: Row(
              children: [
                UserAvatar(
                  account: widget.review.reviewer!,
                  small: true,
                ),
                Container(
                  width: 16,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              GenericUtils.generateNameForAccount(
                                  widget.review.reviewer!),
                              style: Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .smaller
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 4,
                      ),
                      Text(
                        DateFormat.yMMMd().format(widget.review.createdAt),
                        style: Theme.of(context)
                            .extension<CustomThemeFields>()!
                            .smallest,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 16,
          ),
          RatingBar(
            initialRating: widget.review.stars.toDouble(),
            minRating: widget.review.stars.toDouble(),
            maxRating: widget.review.stars.toDouble(),
            itemCount: 5,
            itemSize: 16,
            ratingWidget: RatingWidget(
              full: SvgPicture.asset('assets/icons/svg/star-filled.svg',
                  semanticsLabel: 'Star',
                  colorFilter: ColorFilter.mode(
                    Colors.amber,
                    BlendMode.srcIn,
                  )),
              half: Container(),
              empty: SvgPicture.asset(
                'assets/icons/svg/star-filled.svg',
                semanticsLabel: 'Star',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).extension<CustomThemeFields>()!.fontColor_1,
                  BlendMode.srcIn,
                ),
              ),
            ),
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            onRatingUpdate: (rating) {},
          ),
          Container(
            height: 16,
          ),
          widget.review.description != null && widget.review.description != ''
              ? ReadMoreText(
                  _showTranslatedDetails
                      ? _translatedDescription
                      : widget.review.description!,
                  trimLines: 3,
                  trimLength: 200,
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .extension<CustomThemeFields>()!
                      .subtitle,
                  trimExpandedText: tr('generic.see_less'),
                  trimCollapsedText: tr('generic.see_more'),
                  moreStyle: Theme.of(context)
                      .extension<CustomThemeFields>()!
                      .smaller
                      .copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                  lessStyle: Theme.of(context)
                      .extension<CustomThemeFields>()!
                      .smaller
                      .copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                )
              : Container(),
          _renderTranslateAction(),
          Container(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ScaleTap(
                  onPressed: () {
                    if (widget.review.auctionId != null) {
                      navigatorService.push(
                        AuctionDetailsScreen(
                          assetsLen: 0,
                          auctionId: widget.review.auctionId!,
                        ),
                        NavigationStyle.SharedAxis,
                      );
                    }
                  },
                  child: Text(
                    'profile.see_review_auction',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .smaller
                        .copyWith(
                          color: Colors.blue,
                        ),
                  ).tr(),
                ),
              ),
            ],
          ),
          Container(
            height: 8,
          ),
        ],
      ),
    );
  }
}
