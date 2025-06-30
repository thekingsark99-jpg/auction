import 'package:biddo/screens/profile/widgets/watch_add_for_coins.dart';
import 'package:biddo/theme/extensions/base.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/account.dart';
import '../../core/controllers/main.dart';
import '../../core/controllers/settings.dart';
import '../../core/navigator.dart';
import '../../widgets/common/no_internet_connection.dart';
import '../../widgets/common/section_heading.dart';
import '../../widgets/dialogs/send_us_a_message.dart';
import 'sections/auctions.dart';
import 'sections/bids.dart';
import 'sections/legal.dart';
import 'sections/preferences.dart';
import 'sections/profile.dart';
import 'sections/sign_out.dart';
import 'sections/verification.dart';
import 'settings_item.dart';
import 'widgets/buy_coins_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final accountController = Get.find<AccountController>();
  final mainController = Get.find<MainController>();
  final navigatorService = Get.find<NavigatorService>();
  final settingsController = Get.find<SettingsController>();

  Future<void> _reloadData() {
    return accountController.loadAccountStats();
  }

  Widget _renderMoreInformation() {
    return Column(
      children: [
        SectionHeading(
          title: tr('profile.more.title'),
          withMore: false,
        ),
        SettingsItem(
          title: 'profile.more.send_message.title',
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const SendUsAMessageDialog();
              },
            );
          },
        ),
      ],
    );
  }

  Widget renderContent() {
    return SingleChildScrollView(
      child: Container(
        width: Get.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.only(bottom: 16),
                color: Theme.of(context)
                    .extension<CustomThemeFields>()!
                    .background_1,
                child: ProfileSection(),
              ),
            ),
            ProfileBuyCoinsCard(),
            Container(
              height: 16,
            ),
            ProfileAuctionsSection(),
            Container(
              height: 16,
            ),
            ProfileBidsSection(),
            WatchAddForCoinsCard(),
            Container(
              height: 16,
            ),
            ProfilePreferencesSection(),
            Container(
              height: 16,
            ),
            settingsController.settings.value.allowValidationRequest
                ? ProfileVerificationSection()
                : Container(),
            settingsController.settings.value.allowValidationRequest
                ? Container(
                    height: 16,
                  )
                : Container(),
            ProfileLegalSection(),
            Container(
              height: 16,
            ),
            _renderMoreInformation(),
            Container(
              height: 16,
            ),
            ProfileSignOut(),
            Container(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).extension<CustomThemeFields>()!.background_1,
      body: SafeArea(
        child: Obx(
          () => mainController.connectivity.contains(ConnectivityResult.none)
              ? const NoInternetConnectionScreen()
              : RefreshIndicator(
                  color: Theme.of(context)
                      .extension<CustomThemeFields>()!
                      .fontColor_1,
                  backgroundColor: Theme.of(context)
                      .extension<CustomThemeFields>()!
                      .separator,
                  onRefresh: () async {
                    await _reloadData();
                  },
                  child: renderContent(),
                ),
        ),
      ),
    );
  }
}
