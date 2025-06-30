import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:biddo/theme/extensions/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../../core/controllers/flash.dart';
import '../../../core/controllers/review.dart';
import '../../../core/models/auction.dart';
import '../../../core/models/review.dart';
import '../../../core/navigator.dart';
import '../../../core/services/lang_detector.dart';
import '../../../theme/colors.dart';
import '../../../utils/generic.dart';
import '../../../widgets/common/user_avatar.dart';
import '../../profile/details/index.dart';

class AuctionReview extends StatefulWidget {
  final Rx<Auction> auction;
  final Review? review;

  AuctionReview({
    super.key,
    required this.auction,
    required this.review,
  });

  @override
  State<AuctionReview> createState() => _AuctionReviewState();
}

class _AuctionReviewState extends State<AuctionReview> {
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
        widget.review!.id,
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

    var descriptionLanguage = languageDetectorService
        .detectLanguage(widget.review?.description ?? '');

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
        // height: 17,
        margin: EdgeInsets.only(top: 16),
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
    // ignore: unnecessary_null_comparison
    if (widget.review == null) {
      return Container();
    }

    var addedReviewMsg = tr('auction_details.reviews.added_a_review');
    var noDescriptionMsg = tr('auction_details.no_description_provided');

    var seeLess = tr("generic.see_less");
    var seeMore = tr("generic.see_more");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                Theme.of(context).extension<CustomThemeFields>()!.fontColor_1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context)
              .extension<CustomThemeFields>()!
              .separator
              .withOpacity(0.3),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              UserAvatar(
                account: widget.review?.reviewer,
                small: true,
                size: 40,
              ),
              Container(
                width: 8,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: GenericUtils.generateNameForAccount(
                              widget.review!.reviewer,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (widget.review?.reviewer?.id == null) {
                                  return;
                                }

                                navigatorService.push(
                                  ProfileDetailsScreen(
                                    accountId: widget.review!.reviewer!.id,
                                  ),
                                  NavigationStyle.SharedAxis,
                                );
                              },
                            style: Theme.of(context)
                                .extension<CustomThemeFields>()!
                                .smaller
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          TextSpan(
                            text: addedReviewMsg,
                            style: Theme.of(context)
                                .extension<CustomThemeFields>()!
                                .smaller,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 4,
                    ),
                    Text(
                      DateFormat.yMMMd().format(widget.review!.createdAt),
                      style: Theme.of(context)
                          .extension<CustomThemeFields>()!
                          .smallest,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 16,
          ),
          RatingBar(
            initialRating: widget.review!.stars.toDouble(),
            minRating: widget.review!.stars.toDouble(),
            maxRating: widget.review!.stars.toDouble(),
            itemCount: 5,
            ignoreGestures: true,
            itemSize: 32,
            ratingWidget: RatingWidget(
              full: SvgPicture.asset(
                'assets/icons/svg/star-filled.svg',
                semanticsLabel: 'Star',
                colorFilter: ColorFilter.mode(
                  Colors.amber,
                  BlendMode.srcIn,
                ),
              ),
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
            height: 8,
          ),
          ReadMoreText(
            _showTranslatedDetails
                ? _translatedDescription
                : widget.review!.description == null ||
                        widget.review!.description!.isEmpty
                    ? noDescriptionMsg
                    : widget.review!.description!,
            trimLines: 2,
            trimLength: 100,
            textAlign: TextAlign.left,
            style: Theme.of(context).extension<CustomThemeFields>()!.subtitle,
            trimExpandedText: seeLess,
            trimCollapsedText: seeMore,
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
          ),
          _renderTranslateAction(),
          Container(
            height: 8,
          ),
        ]),
      ),
    );
  }
}
