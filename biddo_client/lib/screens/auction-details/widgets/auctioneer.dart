import 'package:biddo/core/models/auction.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:biddo/theme/extensions/base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/account.dart';
import '../../../core/controllers/chat.dart';
import '../../../core/controllers/flash.dart';
import '../../../core/navigator.dart';
import '../../../theme/colors.dart';
import '../../../widgets/common/account_info.dart';
import '../../../widgets/common/section_heading.dart';
import '../../../widgets/common/simple_button.dart';
import '../../chat/channel.dart';
import '../../profile/details/index.dart';

class AuctionAuctioneer extends StatefulWidget {
  final Auction auction;

  AuctionAuctioneer({
    super.key,
    required this.auction,
  });

  @override
  State<AuctionAuctioneer> createState() => _AuctionAuctioneerState();
}

class _AuctionAuctioneerState extends State<AuctionAuctioneer> {
  final navigatorService = Get.find<NavigatorService>();
  final chatController = Get.find<ChatController>();
  final flashController = Get.find<FlashController>();
  final accountController = Get.find<AccountController>();

  var _loadingDirectChat = false;

  Future<void> openDirectChatWithAccount() async {
    if (_loadingDirectChat) {
      return;
    }

    setState(() {
      _loadingDirectChat = true;
    });

    try {
      var chatGroup = await chatController.getChatGroupWithAccount(
        widget.auction.auctioneer!.id,
        widget.auction,
      );
      if (chatGroup == null) {
        flashController.showMessageFlash(tr('profile.cannot_load_chat_group'));
        return;
      }

      navigatorService.push(
        ChatChannel(chatGroup: chatGroup),
        NavigationStyle.SharedAxis,
      );
    } catch (error) {
      flashController.showMessageFlash(tr('profile.cannot_load_chat_group'));
    } finally {
      if (mounted) {
        setState(() {
          _loadingDirectChat = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.auction.auctioneer?.id == null) {
      return Container();
    }

    var createdByMsg = tr("auction_details.details.created_by");
    return Column(
      children: [
        SectionHeading(
          title: createdByMsg,
          withMore: false,
          sufix: Obx(
            () => accountController.account.value.id ==
                    widget.auction.auctioneer!.id
                ? Container()
                : SimpleButton(
                    background: Theme.of(context)
                        .extension<CustomThemeFields>()!
                        .action,
                    isLoading: _loadingDirectChat,
                    width: 150,
                    height: 30,
                    onPressed: () {
                      openDirectChatWithAccount();
                    },
                    child: Text(
                      'profile.send_message',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .extension<CustomThemeFields>()!
                          .smaller
                          .copyWith(color: DarkColors.font_1),
                    ).tr(),
                  ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: InkWell(
            onTap: () {
              navigatorService.push(
                ProfileDetailsScreen(
                  accountId: widget.auction.auctioneer!.id,
                ),
                NavigationStyle.SharedAxis,
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: AccountInfo(
                    account: widget.auction.auctioneer,
                    small: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
