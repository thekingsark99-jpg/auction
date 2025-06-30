import 'package:easy_localization/easy_localization.dart';
import 'package:biddo/theme/extensions/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../core/controllers/account.dart';
import '../../core/controllers/ads.dart';
import '../../core/controllers/ai.dart';
import '../../core/controllers/auction.dart';
import '../../core/controllers/categories.dart';
import '../../core/controllers/flash.dart';
import '../../core/controllers/image_picker.dart';
import '../../core/controllers/location.dart';
import '../../core/controllers/main.dart';
import '../../core/controllers/settings.dart';
import '../../core/models/auction.dart';
import '../../core/navigator.dart';
import '../../core/services/auth.dart';
import '../../theme/colors.dart';
import '../../widgets/assets/select_assets_button.dart';
import '../../widgets/common/action_button.dart';
import '../../widgets/common/simple_button.dart';
import '../../widgets/dialogs/go_back_confirmation.dart';
import '../../widgets/dialogs/limitation.dart';
import '../../widgets/dialogs/verify_email.dart';
import '../../widgets/simple_app_bar.dart';

import '../auction-details/index.dart';
import 'dialogs/confirm_auction_creation.dart';
import 'form-sections/category/index.dart';
import 'form-sections/condition.dart';
import 'form-sections/description.dart';
import 'form-sections/location.dart';
import 'form-sections/price.dart';
import 'form-sections/start_end.dart';
import 'form-sections/title.dart';
import 'form-sections/youtube.dart';

class CreateAuctionScreen extends StatefulWidget {
  const CreateAuctionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateAuctionScreenState createState() => _CreateAuctionScreenState();
}

class _CreateAuctionScreenState extends State<CreateAuctionScreen> {
  final _formKey = GlobalKey<FormState>();

  final mainController = Get.find<MainController>();
  final accountController = Get.find<AccountController>();
  final imagePickerController = Get.find<ImagePickerController>();
  final navigatorService = Get.find<NavigatorService>();
  final locationController = Get.find<LocationController>();
  final auctionController = Get.find<AuctionController>();
  final flashController = Get.find<FlashController>();
  final adsController = Get.find<AdsController>();
  final settingsController = Get.find<SettingsController>();
  final authService = Get.find<AuthService>();
  final _descriptionController = TextEditingController();
  final RxInt _descriptionLength = 0.obs;
  final aiController = Get.find<AiController>();
  final categoriesController = Get.find<CategoriesController>();

  final Rx<bool> _pointerDownInner = false.obs;
  bool _createInProgress = false;
  late String googleAPIKey = '';

  var _aiGenerating = false;

  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();

    _descriptionController.text = auctionController.description.value;
    _descriptionLength.value = auctionController.description.value.length;

    _descriptionController.addListener(() {
      auctionController.setDescription(_descriptionController.text);
    });

    googleAPIKey = FlutterConfig.get('GOOGLE_MAPS_API_KEY');

    // If the google API KEY is empty, automatically select a location, so that the user doesn't have to do it manually
    if (googleAPIKey.isEmpty) {
      locationController.selectDefaultLocation();
    }

    loadInterstitialAd();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      var userIsAnonymous = accountController.account.value.isAnonymous;
      var allowAnonymousUsersToCreateAuctions =
          settingsController.settings.value.allowAnonymousUsersToCreateAuctions;

      if (userIsAnonymous && !allowAnonymousUsersToCreateAuctions) {
        showAnonymousUserLimitations();
        return;
      }

      var allowUnvalidatedUsersToCreateAuctions = settingsController
          .settings.value.allowUnvalidatedUsersToCreateAuctions;
      var emailIsVerified =
          authService.userHasEmailVerified(settingsController.settings.value);

      if (!emailIsVerified &&
          !allowUnvalidatedUsersToCreateAuctions &&
          !authService.userHasPhoneNumber()) {
        showEmailNotVerifiedLimitations();
        return;
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    if (_interstitialAd != null) {
      adsController.releaseInterstitialAd(_interstitialAd!);
    }
    super.dispose();
  }

  void showEmailNotVerifiedLimitations([bool? onlyOneLevelBack]) {
    var alert = EmailVerificationNeededDialog(
      onlyOneLevelBack: onlyOneLevelBack,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => alert,
    );
  }

  void showAnonymousUserLimitations() {
    var alert = LimitationDialog(
      title: tr('limitations.anonymous_post'),
      description: tr('limitations.anonymous_description'),
      onOkPressed: () {
        Navigator.of(context).pop();
      },
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => alert,
    );
  }

  Future<void> loadInterstitialAd() async {
    _interstitialAd = await adsController.getInterstitialAd();
  }

  Future<void> _generateAiPrompt() async {
    if (_aiGenerating) {
      return;
    }

    var settings = settingsController.settings.value;
    var emailIsVerified = authService.userHasEmailVerified(settings);
    if (!emailIsVerified &&
        !settings.allowAiResponsesOnUnvalidatedEmails &&
        !authService.userHasPhoneNumber()) {
      showEmailNotVerifiedLimitations(true);
      return;
    }

    setState(() {
      _aiGenerating = true;
    });

    var result = await aiController.generateAuctionDataFromImages();

    setState(() {
      _aiGenerating = false;
    });

    if (result == null) {
      return;
    }

    if (result.category != '') {
      for (var category in categoriesController.categories) {
        var subcategory = category.value.subcategories.firstWhereOrNull(
          (subcategory) =>
              subcategory.value.name['en']?.toLowerCase() ==
              result.category.toLowerCase(),
        );

        if (subcategory == null) {
          continue;
        }

        auctionController.subCategoryId.value = subcategory.value.id;
        auctionController.subCategoryId.value = subcategory.value.id;
        auctionController.subCategoryId.refresh();

        auctionController.mainCategoryId.value = category.value.id;
        auctionController.mainCategoryId.refresh();
      }
    }

    if (result.price != '') {
      auctionController.startingPrice.value = double.parse(result.price);
      auctionController.startingPrice.refresh();

      auctionController.isCustomPriceSelected.value = true;
      auctionController.isCustomPriceSelected.refresh();
    }

    auctionController.setDescription(result.description);
    // auctionController.setCategory(result.category);
    // auctionController.setPrice(result.price);
    auctionController.setTitle(result.title);
  }

  void goBack() {
    if (imagePickerController.assetsAreSelected()) {
      showGoBackConfirmationDialog(() {
        imagePickerController.clear();
        auctionController.clear();
      });
      return;
    }

    Navigator.of(context).pop();
  }

  bool canCreateAuction() {
    if (auctionController.title.value == '') {
      return false;
    }

    if (auctionController.mainCategoryId.value == '') {
      return false;
    }

    if (auctionController.subCategoryId.value == '') {
      return false;
    }

    if (locationController.location.value == '') {
      return false;
    }

    return true;
  }

  Future<void> handleSubmit() async {
    if (_createInProgress) {
      return;
    }

    if (auctionController.title.value == '') {
      flashController.showMessageFlash(tr('create_auction.title_required'));
      return;
    }

    if (auctionController.mainCategoryId.value == '' ||
        auctionController.subCategoryId.value == '') {
      flashController.showMessageFlash(tr('create_auction.category_required'));
      return;
    }

    if (locationController.location.value == '') {
      flashController.showMessageFlash(tr('create_auction.location_required'));
      return;
    }

    if (auctionController.startingPrice.value == 0.0) {
      flashController.showMessageFlash(tr('create_auction.price_required'));
      return;
    }

    if (!canCreateAuction()) {
      return;
    }

    if (settingsController.settings.value.freeAuctionsCount <=
        accountController.accountAuctionsCount.value) {
      showCreateAuctionConfirmDialog(context, handleCreateAuction);
      return;
    }

    handleCreateAuction();
  }

  void showCreateAuctionConfirmDialog(BuildContext context, Function onSubmit) {
    var alert = ConfirmCreateAuctionDialog(
      onSubmit: onSubmit,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> handleCreateAuction() async {
    if (mounted) {
      setState(() {
        _createInProgress = true;
      });
    }

    var createdAuction = await auctionController.create();

    if (mounted) {
      setState(() {
        _createInProgress = false;
      });
    }

    if (createdAuction == null) {
      return;
    }

    auctionController.clear();

    if (_interstitialAd == null) {
      handleAuctionCreated(createdAuction);
      return;
    }

    try {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          handleAuctionCreated(createdAuction);
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          handleAuctionCreated(createdAuction);
        },
      );
      _interstitialAd!.show();
    } catch (e) {
      handleAuctionCreated(createdAuction);
    }
  }

  void handleAuctionCreated(Auction createdAuction) {
    var assetsLen = imagePickerController.getSelectedAssetsCount();

    navigatorService
        .push(
            AuctionDetailsScreen(
              assetsLen: assetsLen,
              auctionId: createdAuction.id,
              isNewAuction: true,
            ),
            NavigationStyle.SharedAxis,
            true)!
        .then((dynamic data) {
      var auctionFromController = auctionController.auctions
          .firstWhereOrNull((auction) => auction.value.id == createdAuction.id);

      if (auctionFromController != null) {
        auctionFromController.refresh();
      }

      imagePickerController.clear();
    });
  }

  void showGoBackConfirmationDialog(Function onSubmit) {
    var alert = GoBackConfirmationDialog(onSubmit: onSubmit);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _renderCost(bool canCreate, int coinsCost, [bool? bold = false]) {
    var style = Theme.of(context)
        .extension<CustomThemeFields>()!
        .smallest
        .copyWith(
          fontWeight: bold == true ? FontWeight.w600 : FontWeight.w400,
          color: canCreate
              ? DarkColors.font_1
              : Theme.of(context).extension<CustomThemeFields>()!.fontColor_1,
        );
    return Row(
      children: [
        Container(
          width: 8,
        ),
        Text('(', style: style),
        SvgPicture.asset(
          'assets/icons/svg/coin.svg',
          height: 20,
          width: 20,
          semanticsLabel: 'Coins',
        ),
        Container(
          width: 4,
        ),
        Text(
          'buy_coins.coins_no',
          style: style,
        ).tr(
          namedArgs: {
            'no': coinsCost.toString(),
          },
        ),
        Text(')', style: style)
      ],
    );
  }

  Widget? _renderBottomNavbar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: Theme.of(context).extension<CustomThemeFields>()!.background_1,
          border: Border(
            top: BorderSide(
              color:
                  Theme.of(context).extension<CustomThemeFields>()!.separator,
              width: 1,
            ),
          ),
        ),
        child: SizedBox(
          height: 76,
          child: Row(
            children: [
              Flexible(
                child: Obx(
                  () {
                    var canCreate = canCreateAuction();
                    return ActionButton(
                      background: !canCreate
                          ? Theme.of(context)
                              .extension<CustomThemeFields>()!
                              .separator
                          : Theme.of(context)
                              .extension<CustomThemeFields>()!
                              .action,
                      height: 42,
                      onPressed: handleSubmit,
                      isLoading: _createInProgress,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'create_auction.create_auction',
                              style: Theme.of(context)
                                  .extension<CustomThemeFields>()!
                                  .title
                                  .copyWith(
                                    color: canCreate
                                        ? DarkColors.font_1
                                        : Theme.of(context)
                                            .extension<CustomThemeFields>()!
                                            .fontColor_1,
                                  ),
                            ).tr(),
                            settingsController
                                        .settings.value.freeAuctionsCount <=
                                    accountController.accountAuctionsCount.value
                                ? _renderCost(
                                    canCreate,
                                    settingsController
                                        .settings.value.auctionsCoinsCost,
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderAiPrompt() {
    if (imagePickerController.galleryAssets.isEmpty &&
        imagePickerController.cameraAssets.isEmpty &&
        imagePickerController.networkAssets.isEmpty) {
      return Container();
    }

    var settings = settingsController.settings.value;
    var usedAiResponses = accountController.account.value.aiResponsesCount ?? 0;
    var coinsToSpend = usedAiResponses < settings.freeAiResponses
        ? 0
        : settings.aiResponsesPriceInCoins;

    return Container(
      width: Get.width,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: GradientBoxBorder(
          width: 1,
          gradient: LinearGradient(
            colors: [
              DarkColors.color_1,
              DarkColors.color_2,
              DarkColors.color_3,
              DarkColors.color_4,
              DarkColors.color_5,
              DarkColors.color_6,
            ],
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      DarkColors.color_1,
                      DarkColors.color_2,
                      DarkColors.color_3,
                      DarkColors.color_4,
                      DarkColors.color_5,
                      DarkColors.color_6,
                    ],
                  ).createShader(bounds);
                },
                child: SvgPicture.asset(
                  'assets/icons/svg/ai.svg',
                  height: 50,
                  semanticsLabel: 'AI',
                  colorFilter: ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Container(width: 8),
              Flexible(
                child: Text(
                  'ai.generate_description',
                  style:
                      Theme.of(context).extension<CustomThemeFields>()!.smaller,
                ).tr(),
              ),
            ],
          ),
          Container(height: 16),
          SimpleButton(
            onPressed: () {
              _generateAiPrompt();
            },
            gradient: LinearGradient(
              colors: [
                DarkColors.color_1,
                DarkColors.color_2,
                DarkColors.color_3,
                DarkColors.color_4,
                DarkColors.color_5,
                DarkColors.color_6,
              ],
            ),
            isLoading: _aiGenerating,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ai.generate',
                  style: Theme.of(context)
                      .extension<CustomThemeFields>()!
                      .smaller
                      .copyWith(
                        color: DarkColors.font_1,
                        fontWeight: FontWeight.w600,
                      ),
                ).tr(),
                Container(width: coinsToSpend > 0 ? 8 : 0),
                coinsToSpend > 0
                    ? _renderCost(
                        true,
                        coinsToSpend,
                        true,
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderBody(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectAssetsButton(),
            if (settingsController.settings.value.aiEnabled)
              Obx(() {
                if (imagePickerController.galleryAssets.isNotEmpty ||
                    imagePickerController.cameraAssets.isNotEmpty ||
                    imagePickerController.networkAssets.isNotEmpty) {
                  return _renderAiPrompt();
                }

                return Container();
              }),
            AuctionFormTitleSection(
              handleTitlePointerDown: () {
                _pointerDownInner.value = true;
              },
            ),
            AuctionFormYoutubeSection(),
            AuctionFormCategorySection(),
            Container(height: 16),
            AuctionFormConditionSection(),
            Container(height: 16),
            AuctionFormPriceSection(),
            Container(height: 16),
            AuctionFormLocationSection(),
            Container(
              height: 16,
            ),
            StartingAndEndingAuctionDatesSection(),
            Container(height: 16),
            AuctionFormDescriptionSection(
              handleTitlePointerDown: () {
                _pointerDownInner.value = true;
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) {
        if (_pointerDownInner.value) {
          _pointerDownInner.value = false;
          return;
        }

        _pointerDownInner.value = false;
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor:
            Theme.of(context).extension<CustomThemeFields>()!.background_1,
        resizeToAvoidBottomInset: true,
        appBar: SimpleAppBar(
            onBack: goBack,
            withSearch: false,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    'create_auction.create_a_new_auction',
                    textAlign: TextAlign.start,
                    style:
                        Theme.of(context).extension<CustomThemeFields>()!.title,
                  ).tr(),
                ),
              ],
            )),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            color:
                Theme.of(context).extension<CustomThemeFields>()!.background_1,
            width: Get.width,
            child: _renderBody(context),
          ),
        ),
        bottomNavigationBar: _renderBottomNavbar(),
      ),
    );
  }
}
