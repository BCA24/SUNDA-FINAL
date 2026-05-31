import 'package:flutter/material.dart';
import 'package:houzi/hooks_v2.dart';
import 'package:houzi_package/houzi_main.dart' as houzi_package;
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';

// Import SuriStay colors
import 'constants/suristay_colors.dart';

Map<String, dynamic> getHooks() {
  HooksV2 hooksV2 = HooksV2();
  Map<String, dynamic> hooksMap = {
    "propertyDetailPageIcons": hooksV2.getPropertyDetailPageIconsMap(),
    "elegantHomeTermsIcons": hooksV2.getElegantHomeTermsIconMap(),
    "headers": hooksV2.getHeaderMap(),
    "drawerItems": hooksV2.getDrawerItems(),
    "customCountryHook": hooksV2.getCustomCountryHook(),
    "widgetItems": hooksV2.getWidgetHook(),
    "propertyItem": hooksV2.getPropertyItemHook(),
    "propertyItemV2": hooksV2.getPropertyItemHookV2(),
    "propertyItemHeightHook": hooksV2.getPropertyItemHeightHook(),
    "termItem": hooksV2.getTermItemHook(),
    "agentItem": hooksV2.getAgentItemHook(),
    "agencyItem": hooksV2.getAgencyItemHook(),
    "languageNameAndCode": hooksV2.getLanguageCodeAndName(),
    "defaultLanguageCode": hooksV2.getDefaultLanguageHook(),
    "defaultHomePage": hooksV2.getDefaultHomePageHook(),
    "defaultCountryCode": hooksV2.getDefaultCountryCodeHook(),
    "settingsOption": hooksV2.getSettingsItemHook(),
    "profileItem": hooksV2.getProfileItemHook(),
    "homeRightBarButtonWidget": hooksV2.getHomeRightBarButtonWidgetHook(),
    "markerTitle": hooksV2.getMarkerTitleHook(),
    "markerIcon": hooksV2.getMarkerIconHook(),
    "customMapMarker": hooksV2.getCustomMarkerHook(),
    "priceFormatter": hooksV2.getPriceFormatterHook(),
    "compactPriceFormatter": hooksV2.getCompactPriceFormatterHook(),
    "textFormFieldCustomizationHook": hooksV2.getTextFormFieldCustomizationHook(),
    "editProfileShowFieldHook": hooksV2.getEditProfileShowFieldHook(),
    "textFormFieldWidgetHook": hooksV2.getTextFormFieldWidgetHook(),
    "customSegmentedControlHook": hooksV2.getCustomSegmentedControlHook(),
    "drawerHeaderHook": hooksV2.getDrawerHeaderHook(),
    "hidePriceHook": hooksV2.getHidePriceHook(),
    "hideEmptyTerm": hooksV2.hideEmptyTerm(),
    "homeSliverAppBarBodyHook": hooksV2.getHomeSliverAppBarBodyHook(),
    "homeSliverAppBarBGImageHook": hooksV2.getHomeSliverAppBarBGImageHook(),
    "drawerWidgetsHook": hooksV2.getDrawerWidgetsHook(),
    "membershipPlanHook": hooksV2.getMembershipPlanHook(),
    "paymentHook": hooksV2.getPaymentHook(),
    "membershipPackageUpdatedHook": hooksV2.getMembershipPackageUpdatedHook(),
    "paymentSuccessfulHook": hooksV2.getPaymentSuccessfulHook(),
    "addPlusButtonInBottomBarHook": hooksV2.getAddPlusButtonInBottomBarHook(),
    "navbarWidgetsHook": hooksV2.getNavbarWidgetsHook(),
    "clusterMarkerIconHook": hooksV2.getCustomizeClusterMarkerIconHook(),
    "customClusterMarkerIconHook": hooksV2.getCustomClusterMarkerIconHook(),
    "membershipPayWallDesignHook": hooksV2.getMembershipPayWallDesignHook(),
    "minimumPasswordLengthHook": hooksV2.getMinimumPasswordLengthHook(),
    "agentProfileConfigurationsHook": hooksV2.getAgentProfileConfigurationsHook(),
    "userLoginActionHook": hooksV2.getUserLoginActionHook(),
    "addPropertyActionHook": hooksV2.getAddPropertyActionHook(),
    "drawerMenuItemDesignHook": hooksV2.getDrawerMenuItemDesignHook(),
    "defaultAppThemeModeHook": hooksV2.getDefaultAppThemeModeHook(),
    "messageApiRefreshTimeHook": hooksV2.getMessageApiRefreshTimeHook(),
    "threadApiRefreshTimeHook": hooksV2.getThreadApiRefreshTimeHook(),
    "fonts": hooksV2.getFontHook(),
    "homeWidgetsHook": hooksV2.getHomeWidgetsHook(),
  };
  return hooksMap;
}

Future<void> main() async {
  // EARLY DEBUG
  print('🚀🚀🚀 MAIN STARTING 🚀🚀🚀');
  
  Map<String, dynamic> hooks = getHooks();
  
  // DEBUG: Check if our hook is properly registered
  print('🔧 Total hooks: ${hooks.length}');
  print('🔧 homeWidgetsHook exists: ${hooks.containsKey("homeWidgetsHook")}');
  if (hooks.containsKey("homeWidgetsHook")) {
    print('🔧 homeWidgetsHook is not null: ${hooks["homeWidgetsHook"] != null}');
  }
  
  print('🚀 Starting Houzi app...');
  await houzi_package.main('assets/configurations/configurations.json', hooks);
}
