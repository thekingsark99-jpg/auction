import 'package:biddo/core/controllers/bid.dart';
import 'package:biddo/widgets/common/simple_button.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:biddo/theme/extensions/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/controllers/account.dart';
import '../../../core/controllers/auction.dart';
import '../../../core/controllers/currencies.dart';
import '../../../core/controllers/flash.dart';
import '../../../core/controllers/settings.dart';
import '../../../core/models/auction.dart';
import '../../../core/services/auth.dart';
import '../../../theme/colors.dart';
import '../../../widgets/dialogs/limitation.dart';
import '../../../widgets/dialogs/verify_email.dart';
import '../dialogs/promote_auction.dart';
import '../dialogs/create_bid.dart';
import 'min_sell_price.dart';

class AuctionDetailsBottomNavBar extends StatelessWidget {
  final accountController = Get.find<AccountController>();
  final flashController = Get.find<FlashController>();
  final auctionController = Get.find<AuctionController>();
  final bidController = Get.find<BidController>();
  final settingsController = Get.find<SettingsController>();
  final authService = Get.find<AuthService>();
  final currenciesController = Get.find<CurrenciesController>();

  final Rx<Auction> auction;
  final Function handleBidCreated;
  final Function handlePromote;

  AuctionDetailsBottomNavBar({
    super.key,
    required this.auction,
    required this.handleBidCreated,
    required this.handlePromote,
  });

  void openPromoteAuctionDialog(BuildContext context) {
    var alert = PromoteAuctionDialog(
      onPromote: handlePromote,
    );

    showDialog(
      context: navigator!.context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAnonymousUserLimitations() {
    var alert = LimitationDialog(
      title: tr('limitations.anonymous_bid'),
      description: tr('limitations.anonymous_description'),
    );

    showDialog(
      context: navigator!.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showEmailNotVerifiedLimitations(BuildContext context) {
    var alert = EmailVerificationNeededDialog(
      onlyOneLevelBack: true,
      afterValidation: () {
        openCreateBidDialog(context);
      },
    );

    showDialog(
      context: navigator!.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void openCreateBidDialog(BuildContext context) {
    var userIsAnonymous = accountController.account.value.isAnonymous;
    var allowAnonymousUsersToCreateAuctions =
        settingsController.settings.value.allowAnonymousUsersToCreateBids;

    if (userIsAnonymous && !allowAnonymousUsersToCreateAuctions) {
      showAnonymousUserLimitations();
      return;
    }

    var allowUnvalidatedUsersToCreateBids =
        settingsController.settings.value.allowUnvalidatedUsersToCreateBids;
    var emailIsVerified =
        authService.userHasEmailVerified(settingsController.settings.value);

    if (!userIsAnonymous &&
        !emailIsVerified &&
        !allowUnvalidatedUsersToCreateBids &&
        !authService.userHasPhoneNumber()) {
      showEmailNotVerifiedLimitations(context);
      return;
    }

    var bidsThatAreNotRejected = (auction.value.bids)
        .where((element) => element.value.isRejected != true)
        .toList();

    var bidWithHighestPrice = bidsThatAreNotRejected.isNotEmpty
        ? bidsThatAreNotRejected.reduce((curr, next) =>
            currenciesController.convertPrice(
                        curr.value.price!, curr.value.initialCurrencyId) >
                    currenciesController.convertPrice(
                        next.value.price!, next.value.initialCurrencyId)
                ? curr
                : next)
        : null;

    if (bidWithHighestPrice != null &&
        bidWithHighestPrice.value.bidder?.id ==
            accountController.account.value.id) {
      flashController.showMessageFlash(
        tr("auction_details.create_bid.already_have_highest_bid"),
        FlashMessageType.error,
      );
      return;
    }

    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor:
          Theme.of(context).extension<CustomThemeFields>()!.background_2,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: CreateBidDetails(
              auction: auction.value,
              onConfirm: (double price, String description) async {
                bidController.clear();

                bidController.setPrice(price);
                bidController.setDescription(description);
                var createdBid = await bidController.create(
                  auction.value.id,
                );

                if (createdBid != null) {
                  flashController.showMessageFlash(
                    tr("auction_details.create_bid.bid_created"),
                    FlashMessageType.success,
                  );

                  handleBidCreated(createdBid);
                } else {
                  flashController.showMessageFlash(
                    tr("auction_details.create_bid.error_creating"),
                    FlashMessageType.error,
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentAccountIsOwner =
        accountController.account.value.id == auction.value.auctioneer?.id;

    var auctionIsClosed = auction.value.acceptedBidId != null ||
        auction.value.expiresAt != null &&
            auction.value.expiresAt!.isBefore(DateTime.now());

    if (auctionIsClosed) {
      return Text('');
    }

    var auctionDidNotStart =
        auction.value.startAt != null && auction.value.startedAt == null;
    var currentLanguage = context.locale.toString();

    if (auctionDidNotStart) {
      return Container(
        height: 100,
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color:
                  Theme.of(context).extension<CustomThemeFields>()!.separator,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'starting_soon_auctions.starts_at',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .smaller,
                  ).tr(),
                ),
                Text(
                  DateFormat('d MMM, h:mm a', currentLanguage)
                      .format(auction.value.startAt!),
                  style:
                      Theme.of(context).extension<CustomThemeFields>()!.smaller,
                ),
              ],
            ),
            Container(
              height: 8,
            ),
            Text(
              'starting_soon_auctions.add_to_fav',
              style: Theme.of(context).extension<CustomThemeFields>()!.smallest,
            ).tr(),
          ],
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 100,
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color:
                    Theme.of(context).extension<CustomThemeFields>()!.separator,
              ),
            ),
          ),
          child: LayoutGrid(
            columnSizes: [0.8.fr, 1.2.fr],
            rowSizes: [82.px, 82.px],
            rowGap: 8,
            columnGap: 8,
            children: [
              MinSellPriceInfo(
                auction: auction,
              ),
              SizedBox(
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SimpleButton(
                      background: currentAccountIsOwner
                          ? Theme.of(context)
                              .extension<CustomThemeFields>()!
                              .fontColor_1
                          : Theme.of(context)
                              .extension<CustomThemeFields>()!
                              .action,
                      onPressed: () {
                        currentAccountIsOwner
                            ? openPromoteAuctionDialog(context)
                            : openCreateBidDialog(context);
                      },
                      height: 42,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            currentAccountIsOwner
                                ? Container(
                                    margin: EdgeInsetsDirectional.only(end: 8),
                                    child: SvgPicture.asset(
                                      'assets/icons/svg/coin.svg',
                                      height: 24,
                                      width: 24,
                                      semanticsLabel: 'Coins',
                                    ),
                                  )
                                : Container(),
                            Text(
                              currentAccountIsOwner
                                  ? 'promote_auction.promote_auction'
                                  : 'auction_details.create_bid.title',
                              style: Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .smaller
                                  .copyWith(
                                    color: currentAccountIsOwner
                                        ? Theme.of(context)
                                            .extension<CustomThemeFields>()!
                                            .background_1
                                        : DarkColors.font_1,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ).tr(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
