import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../core/controllers/account.dart';
import '../../theme/extensions/base.dart';
import 'widgets/sort_popup.dart';

// ignore: must_be_immutable
class ChatAppBar extends StatefulWidget {
  Widget forSaleChats;
  Widget toBuyChats;

  ChatGroupsSortBy currentSort;
  Function? handleSortChange;

  int forSaleChatsLen;
  int toBuyChatsLet;

  ChatAppBar({
    super.key,
    required this.forSaleChats,
    required this.toBuyChats,
    required this.forSaleChatsLen,
    required this.toBuyChatsLet,
    required this.currentSort,
    this.handleSortChange,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ChatAppBar createState() => _ChatAppBar();
}

class _ChatAppBar extends State<ChatAppBar>
    with SingleTickerProviderStateMixin {
  final accountController = Get.find<AccountController>();
  final scrollController = ScrollController();

  late TabController _controller;
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);

    _controller.addListener(() {
      setState(() {
        _activeTab = _controller.index;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Widget _renderTitle() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'chat.chat',
            style: Theme.of(context).extension<CustomThemeFields>()!.title,
            textAlign: TextAlign.left,
          ).tr(),
          Container(
            margin: const EdgeInsetsDirectional.only(end: 16),
            child: ChatGroupsSortPopup(
              onSort: (ChatGroupsSortBy sortBy) {
                if (widget.handleSortChange != null) {
                  widget.handleSortChange!(sortBy);
                }
              },
              currentSort: widget.currentSort,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSize _buildBottom() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(66),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).extension<CustomThemeFields>()!.background_1,
        ),
        child: Container(
          padding: const EdgeInsets.all(4),
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .extension<CustomThemeFields>()!
                .separator
                .withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  Theme.of(context).extension<CustomThemeFields>()!.separator,
            ),
          ),
          child: TabBar(
            indicatorWeight: 3,
            padding: EdgeInsets.zero,
            dividerColor: Colors.transparent,
            indicatorColor:
                Theme.of(context).extension<CustomThemeFields>()!.fontColor_1,
            controller: _controller,
            labelStyle: Theme.of(context)
                .extension<CustomThemeFields>()!
                .smaller
                .copyWith(
                  fontWeight: FontWeight.w600,
                ),
            labelColor:
                Theme.of(context).extension<CustomThemeFields>()!.fontColor_1,
            unselectedLabelColor:
                Theme.of(context).extension<CustomThemeFields>()!.fontColor_3,
            indicator: BoxDecoration(
              color:
                  Theme.of(context).extension<CustomThemeFields>()!.separator,
              borderRadius: BorderRadius.circular(8),
            ),
            labelPadding: EdgeInsets.zero,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/svg/selling.svg',
                      semanticsLabel: 'Selling',
                      width: 24,
                      height: 24,
                      colorFilter: _activeTab == 0
                          ? ColorFilter.mode(
                              Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .fontColor_1,
                              BlendMode.srcIn,
                            )
                          : ColorFilter.mode(
                              Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .fontColor_3,
                              BlendMode.srcIn,
                            ),
                    ),
                    Container(
                      width: 8,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4),
                      child: const Text('chat.selling').tr(
                        namedArgs: {'no': widget.forSaleChatsLen.toString()},
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/svg/buying.svg',
                      semanticsLabel: 'Buying',
                      width: 24,
                      height: 24,
                      colorFilter: _activeTab == 1
                          ? ColorFilter.mode(
                              Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .fontColor_1,
                              BlendMode.srcIn,
                            )
                          : ColorFilter.mode(
                              Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .fontColor_3,
                              BlendMode.srcIn,
                            ),
                    ),
                    Container(
                      width: 8,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4),
                      child: const Text('chat.buying').tr(
                        namedArgs: {'no': widget.toBuyChatsLet.toString()},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: scrollController,
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          sliver: SliverAppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            pinned: true,
            floating: true,
            centerTitle: false,
            backgroundColor:
                Theme.of(context).extension<CustomThemeFields>()!.background_1,
            toolbarHeight: 74,
            forceElevated: innerBoxIsScrolled,
            title: _renderTitle(),
            bottom: _buildBottom(),
          ),
        ),
      ],
      body: Builder(
        builder: (BuildContext context) {
          return TabBarView(
            controller: _controller,
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 68,
                  ),
                  child: widget.forSaleChats,
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 68,
                  ),
                  child: widget.toBuyChats,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
