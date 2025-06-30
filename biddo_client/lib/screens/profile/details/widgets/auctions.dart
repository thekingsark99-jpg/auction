import 'package:easy_localization/easy_localization.dart';
import 'package:biddo/theme/extensions/base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masonry_grid/masonry_grid.dart';

import '../../../../core/models/account.dart';
import '../../../../core/models/auction.dart';
import '../../../../core/navigator.dart';
import '../../../../theme/colors.dart';
import '../../../../widgets/auction-card/index.dart';
import '../../../../widgets/common/section_heading.dart';
import '../../../../widgets/common/simple_button.dart';
import '../all-auctions/index.dart';

class AccountAuctions extends StatelessWidget {
  final int? auctionsCount;
  final Account? account;
  final List<Auction>? auctions;
  final String? title;
  final bool? withSeeMore;
  final bool? withTitleSufix;

  final navigationService = Get.find<NavigatorService>();

  AccountAuctions({
    super.key,
    this.auctionsCount,
    required this.auctions,
    this.account,
    this.title,
    this.withSeeMore = true,
    this.withTitleSufix = true,
  });

  Widget _renderAuctionsList(BuildContext context, List<Auction> auctionsList) {
    return auctionsList.isNotEmpty
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                MasonryGrid(
                  column: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: [
                    for (var auction in auctionsList)
                      GestureDetector(
                        onTap: () {
                          navigationService.push(
                            AllAccountAuctionsScreen(
                              auctionsCount:
                                  auctionsCount ?? auctions?.length ?? 0,
                              account: account!,
                            ),
                            NavigationStyle.SharedAxis,
                          );
                        },
                        child: AuctionCard(
                          auction: auction.obs,
                        ),
                      ),
                  ],
                ),
                Container(
                  height: (auctionsCount ?? auctions?.length ?? 0) > 5 ? 16 : 0,
                ),
                (auctionsCount ?? auctions?.length ?? 0) > 5
                    ? SimpleButton(
                        background: Theme.of(context)
                            .extension<CustomThemeFields>()!
                            .action,
                        child: Text(
                          'home.auctions.see_all',
                          style: Theme.of(context)
                              .extension<CustomThemeFields>()!
                              .smaller
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: DarkColors.font_1,
                              ),
                        ).tr(namedArgs: {
                          'no': (auctionsCount ?? auctions?.length ?? 0)
                              .toString()
                        }),
                        onPressed: () {
                          navigationService.push(
                            AllAccountAuctionsScreen(
                              auctionsCount:
                                  auctionsCount ?? auctions?.length ?? 0,
                              account: account!,
                            ),
                            NavigationStyle.SharedAxis,
                          );
                        },
                      )
                    : Container(),
              ],
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'profile.no_auctions',
              style: Theme.of(context).extension<CustomThemeFields>()!.smaller,
              textAlign: TextAlign.start,
            ).tr(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Theme.of(context).extension<CustomThemeFields>()!.background_1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
            title: title ?? tr('home.auctions.auctions'),
            titleSufix: withTitleSufix == true
                ? '(${auctionsCount ?? auctions?.length ?? 0})'
                : null,
            withMore: withSeeMore ?? true,
            onPressed: () {
              if (account == null) {
                return;
              }

              navigationService.push(
                AllAccountAuctionsScreen(
                  auctionsCount: auctionsCount ?? auctions?.length ?? 0,
                  account: account!,
                ),
                NavigationStyle.SharedAxis,
              );
            },
          ),
          auctions != null
              ? _renderAuctionsList(context, auctions!)
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('profile.no_auctions',
                          style: Theme.of(context)
                              .extension<CustomThemeFields>()!
                              .smaller)
                      .tr(),
                ),
        ],
      ),
    );
  }
}
