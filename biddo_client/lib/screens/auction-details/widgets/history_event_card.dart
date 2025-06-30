import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/models/auction.dart';
import '../../../theme/extensions/base.dart';

class AuctionHistoryEventCard extends StatelessWidget {
  final AuctionHistoryEvent event;

  AuctionHistoryEventCard({required this.event});

  Widget _renderEventTitle(BuildContext context) {
    var title = '';
    switch (event.type) {
      case 'ADD_TO_FAVORITES':
        title = tr(
          'auction_history.add_to_fav',
          namedArgs: {'name': event.details['accountName']},
        );
      case 'REMOVE_FROM_FAVORITES':
        title = tr(
          'auction_history.remove_from_fav',
          namedArgs: {'name': event.details['accountName']},
        );
      case 'UPDATE_AUCTION':
        title = tr('auction_history.update');

      case 'VIEW_AUCTION':
        title = tr(
          'auction_history.view',
          namedArgs: {'name': event.details['accountName']},
        );

      case 'PROMOTE_AUCTION':
        title = tr('auction_history.promote');

      case 'COINS_REFUNDED':
        title = tr('auction_history.coins_refunded');

      case 'PLACE_BID':
        title = tr(
          'auction_history.bid_placed',
          namedArgs: {'name': event.details['accountName']},
        );

      case 'ACCEPT_BID':
        title = tr('auction_history.you_accepted_bid');

      case 'REJECT_BID':
        title = tr('auction_history.you_rejected_bid');
    }

    return Text(
      title,
      style: Theme.of(context).extension<CustomThemeFields>()!.smaller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).extension<CustomThemeFields>()!.separator,
        ),
        color: Theme.of(context)
            .extension<CustomThemeFields>()!
            .background_2
            .withOpacity(0.3),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Date Badge
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).extension<CustomThemeFields>()!.action,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('MMM').format(event.createdAt),
                    style: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .smaller
                        .copyWith(
                          color: Colors.white,
                        ),
                  ),
                  Text(
                    DateFormat('dd').format(event.createdAt),
                    style: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .smaller
                        .copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            // Event Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _renderEventTitle(context),
                  SizedBox(height: 4),
                  Text(
                    DateFormat('d MMM, h:mm a').format(event.createdAt),
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
    );
  }
}
