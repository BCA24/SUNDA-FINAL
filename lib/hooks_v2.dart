import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'pages/agency_login_page.dart';
import 'package:houzi_package/models/search/map_marker_data.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_properties_related_widgets/latest_featured_properties_widget/properties_carousel_list_widget.dart';
import 'package:houzi_package/providers/state_providers/locale_provider.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/configurations/app_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/houzi_main.dart';
import 'package:houzi_package/files/hooks_files/hooks_v2_interface.dart';
import 'package:houzi_package/l10n/l10n.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/models/drawer/drawer_menu_item.dart';
import 'package:houzi_package/models/realtor_model.dart';
import 'package:houzi_package/models/search/map_marker_data.dart';
import 'package:houzi_package/pages/crm_pages/crm_activities/activities_from_board.dart';
import 'package:houzi_package/pages/crm_pages/crm_deals/deals_from_board.dart';
import 'package:houzi_package/pages/crm_pages/crm_inquiry/inquiries_from_board.dart';
import 'package:houzi_package/pages/crm_pages/crm_leads/leads_from_board.dart';
import 'package:houzi_package/pages/home_page_screens/home_elegant_related/related_widgets/home_elegant_sliver_app_bar.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_drawer_widgets/home_screen_drawer_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_realtors_related_widgets/home_screen_realtors_list_widget.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_widgets/home_screen_sliver_app_bar_widgets/default_right_bar_widget.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/all_agents.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/settings_page.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/phone_sign_in_widgets/user_get_phone_number.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_profile.dart';
import 'package:houzi_package/pages/map_view.dart';

import 'package:houzi_package/pages/property_details_related_pages/pd_widgets_listing.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';
import 'package:houzi_package/widgets/explore_by_type_design_widgets/explore_by_type_design.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';

import 'package:houzi_package/pages/property_details_related_pages/bottom_buttons_action_bar.dart';
import 'package:houzi_package/pages/property_details_related_pages/pd_widgets_listing.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';
import 'package:houzi_package/widgets/custom_segment_widget.dart';
import 'package:houzi_package/widgets/explore_by_type_design_widgets/explore_by_type_design.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

import 'package:intl_phone_field/countries.dart';

// Import your custom page
import 'caricom_region_main_page.dart';
import 'services/caribbean_api_service.dart';
import 'pages/agency_login_page.dart';
import 'services/agency_auth_service.dart';
import 'services/postgresql_auth_service.dart';

class HooksV2 implements HooksV2Interface {
  @override
  Map<String, dynamic> getHeaderMap() {
    Map<String, dynamic> map = {
      "app-secret": "2#4*dv3@4pK9W3",
      // "secret_key": "",
    };
    return map;
  }

  @override
  Map<String, dynamic> getPropertyDetailPageIconsMap() {
    Map<String, dynamic> _iconMap = {
      // "Air Conditioning": Icons.ac_unit_outlined,
      // "Air Conditioning": Image.asset("assets/IMAGE_NAME"),
    };

    return _iconMap;
  }

  @override
  Map<String, dynamic> getElegantHomeTermsIconMap() {
    Map<String, dynamic> _iconMap = {
      // "for-rent": Icons.vpn_key_outlined,
    };

    return _iconMap;
  }

  @override
  FontsHook getFontHook() {
    FontsHook fontsHook = (Locale locale) {
      // Use Montserrat as primary font for SuriStay Caribbean branding
      return "Montserrat";
    };

    return fontsHook;
  }

  @override
  PropertyItemHeightHook getPropertyItemHeightHook() {
    PropertyItemHeightHook propertyItemHeightHook = (String designName) {
      return null;
    };
    return propertyItemHeightHook;
  }

  @override
  PropertyItemHookV2 getPropertyItemHookV2() {
    PropertyItemHookV2 propertyItemHookV2 = (
        {required article,
        required designName,
        required heroId,
        required onTap}) {
      return null;
    };

    return propertyItemHookV2;
  }

  /// Deprecated Method, use getPropertyItemHookV2() instead
  @override
  PropertyItemHook getPropertyItemHook() {
    PropertyItemHook propertyItemHook =
        (BuildContext context, Article article) {
      return null;
    };

    return propertyItemHook;
  }

  @override
  TermItemHook getTermItemHook() {
    TermItemHook termItemHook = (List metaDataList) {
      return null;
    };

    return termItemHook;
  }

  @override
  AgentItemHook getAgentItemHook() {
    AgentItemHook agentItemHook = (BuildContext context, Agent item) {
      return null;
    };
    return agentItemHook;
  }

  @override
  AgencyItemHook getAgencyItemHook() {
    AgencyItemHook agencyItemHook = (BuildContext context, Agency agency) {
      return null;
    };

    return agencyItemHook;
  }

  @override
  PropertyPageWidgetsHook getWidgetHook() {
    PropertyPageWidgetsHook detailsHook = (
      BuildContext context,
      Article article,
      String hook,
    ) {
      return null;
    };

    return detailsHook;
  }

  @override
  LanguageHook getLanguageCodeAndName() {
    LanguageHook languageHook = () {
      Map<String, dynamic> englishLanguageMap = {
        "languageName": "English",
        "languageCode": "en"
      };

      Map<String, dynamic> arabicLanguageMap = {
        "languageName": "Arabic",
        "languageCode": "ar"
      };

      Map<String, dynamic> frenchLanguageMap = {
        "languageName": "French",
        "languageCode": "fr"
      };

      List<dynamic> languageList = [
        englishLanguageMap,
        arabicLanguageMap,
        frenchLanguageMap,
      ];

      return languageList;
    };

    return languageHook;
  }

  @override
  EditProfileShowFieldHook getEditProfileShowFieldHook() {
    EditProfileShowFieldHook editProfileShowFieldHook = (String fieldName) {
      return null; 
    };
    return editProfileShowFieldHook;
  }

  @override
  DefaultLanguageCodeHook getDefaultLanguageHook() {
    DefaultLanguageCodeHook defaultLanguageCodeHook = () {
      return "en";
    };

    return defaultLanguageCodeHook;
  }

  @override
  DefaultHomePageHook getDefaultHomePageHook() {
    DefaultHomePageHook defaultHomePageHook = () {
      // Use home_0 (Home Carousel) as the base, then replace with our custom content
      return "home_0";
    };

    return defaultHomePageHook;
  }

  @override
  DefaultCountryCodeHook getDefaultCountryCodeHook() {
    DefaultCountryCodeHook defaultCountryCodeHook = () {
      return "US";
    };

    return defaultCountryCodeHook;
  }

  @override
  CustomCountryHook getCustomCountryHook() {
    CustomCountryHook customCountryHook = () {
      return null;
    };
    return customCountryHook;
  }

  @override
  SettingsHook getSettingsItemHook() {
    SettingsHook settingsHook = (BuildContext context) {
      List<dynamic> settingsItemHookList = [];
      return settingsItemHookList;
    };

    return settingsHook;
  }

  @override
  ProfileHook getProfileItemHook() {
    ProfileHook profileHook = (BuildContext context) {
      List<Widget> profileItemHookList = [];
      return profileItemHookList;
    };
    return profileHook;
  }

  @override
  HomeRightBarButtonWidgetHook getHomeRightBarButtonWidgetHook() {
    HomeRightBarButtonWidgetHook homeRightBarButtonWidgetHook =
        (BuildContext context) {
      Widget? rightBarButtonHook;
      return rightBarButtonHook;
    };

    return homeRightBarButtonWidgetHook;
  }

  @override
  MarkerTitleHook getMarkerTitleHook() {
    MarkerTitleHook markerTitleHook = (BuildContext context, Article article) {
      String markerTitle = article.title!;
      return markerTitle;
    };

    return markerTitleHook;
  }

  @override
  MarkerIconHook getMarkerIconHook() {
    MarkerIconHook markerIconHook = (BuildContext context, Article article) {
      return null;
    };

    return markerIconHook;
  }

  @override
  CustomMarkerHook getCustomMarkerHook() {
    CustomMarkerHook markerIconHook = (BuildContext context, Article article) {
      MapMarkerData markerData = MapMarkerData(
          text: article.getCompactPriceForMap(),
          backgroundColor: Color(0xFFE4002B), // SuriStay vibrant red
          textColor: Colors.white);
      return markerData;
    };

    return markerIconHook;
  }

  @override
  PriceFormatterHook getPriceFormatterHook() {
    PriceFormatterHook priceFormatterHook =
        (String propertyPrice, String firstPrice) {
      return null;
    };

    return priceFormatterHook;
  }

  @override
  CompactPriceFormatterHook getCompactPriceFormatterHook() {
    CompactPriceFormatterHook compactPriceFormatterHook = (String inputPrice) {
      return null;
    };

    return compactPriceFormatterHook;
  }

  @override
  TextFormFieldCustomizationHook getTextFormFieldCustomizationHook() {
    TextFormFieldCustomizationHook textFormFieldCustomizationHook = () {
      Map<String, dynamic> textFormFieldCustomizationMap = {
        'labelTextStyle': null,
        'hintTextStyle': null,
        'additionalHintTextStyle': null,
        'backgroundColor': null,
        'focusedBorderColor': null,
        'hideBorder': null,
        'borderRadius': null,
      };

      return textFormFieldCustomizationMap;
    };

    return textFormFieldCustomizationHook;
  }

  @override
  TextFormFieldWidgetHook getTextFormFieldWidgetHook() {
    TextFormFieldWidgetHook textFormFieldWidgetHook = (
      context,
      labelText,
      hintText,
      additionalHintText,
      suffixIcon,
      initialValue,
      maxLines,
      readOnly,
      obscureText,
      controller,
      keyboardType,
      inputFormatters,
      validator,
      onSaved,
      onChanged,
      onFieldSubmitted,
      onTap,
    ) {
      Widget? textFormFieldWidget;
      return textFormFieldWidget;
    };

    return textFormFieldWidgetHook;
  }

  @override
  CustomSegmentedControlHook getCustomSegmentedControlHook() {
    CustomSegmentedControlHook customSegmentedControlHook = (
      BuildContext context,
      List<dynamic> itemList,
      int selectionIndex,
      Function(int) onSegmentChosen,
    ) {
      return null;
    };

    return customSegmentedControlHook;
  }

  @override
  DrawerHeaderHook getDrawerHeaderHook() {
    DrawerHeaderHook drawerHeaderHook = (
      BuildContext context,
      String appName,
      String appIconPath,
      String? userProfileName,
      String? userProfileImageUrl,
    ) {
      // Custom SuriStay drawer header with Caribbean gradient
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF006633), Color(0xFF2EC4B6)], // Dark green to turquoise gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: DrawerHeader(
          decoration: BoxDecoration(color: Colors.transparent),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset('assets/icon/suristay_logo.png', height: 40),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SuriStay',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Caribbean',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFFCC00), // Bright yellow
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (userProfileName != null) ...[
                SizedBox(height: 8),
                Text(
                  'Welcome, $userProfileName',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    };

    return drawerHeaderHook;
  }

  @override
  DrawerHook getDrawerItems() {
    DrawerHook drawerHook = (BuildContext context) {
      // Return empty list to use default drawer - we'll handle logout differently
      return [];
    };
    return drawerHook;
  }

  @override
  HidePriceHook getHidePriceHook() {
    HidePriceHook hidePriceHook = () {
      bool hidePropertyPrice = false;
      return hidePropertyPrice;
    };

    return hidePriceHook;
  }

  @override
  HideEmptyTerm hideEmptyTerm() {
    HideEmptyTerm shouldHide = (String termName) {
      return false;
    };
    return shouldHide;
  }
  
  @override
  HomeSliverAppBarBGImageHook getHomeSliverAppBarBGImageHook() {
    return (BuildContext context) {
      return null;
    };
  }

  @override
  HomeSliverAppBarBodyHook getHomeSliverAppBarBodyHook() {
    HomeSliverAppBarBodyHook _homeSliverAppBarBodyHook = (context) {
      Map<String, dynamic>? _bodyHookMap;
      double? _bodyWidgetHeight;
      Widget? _bodyWidget;

      _bodyHookMap = {
        "height": _bodyWidgetHeight,
        "widget": _bodyWidget,
      };
      return _bodyHookMap;
    };
    return _homeSliverAppBarBodyHook;
  }

  MembershipPlanHook getMembershipPlanHook() {
    MembershipPlanHook membershipPlanHook =
        (BuildContext context, List<dynamic> membershipPackageList) {
      return null;
    };

    return membershipPlanHook;
  }

  @override
  DrawerWidgetsHook getDrawerWidgetsHook() {
    DrawerWidgetsHook drawerWidgetsHook =
        (BuildContext context, String? hookName) {
      return null;
    };

    return drawerWidgetsHook;
  }

  // THIS IS THE CRITICAL METHOD - This replaces the entire home content
  @override
  HomeWidgetsHook getHomeWidgetsHook() {
    HomeWidgetsHook homeWidgetsHook =
        (BuildContext context, String? hookName, bool isRefreshed) {
      
      // DEBUG: Print what hook name we're receiving
      print('🔥🔥🔥 HomeWidgetsHook CALLED! 🔥🔥🔥');
      print('🔥 hookName: "$hookName"');
      print('🔥 hookName type: ${hookName.runtimeType}');
      print('🔥 isRefreshed: $isRefreshed');
      print('🔥 context: $context');
      
      // Replace the entire home page content with our Caribbean page
      if (hookName == "home_screen_body" || hookName == "home_0_body" || hookName == "main_body") {
        print('🎯 REPLACING HOME BODY WITH CARIBBEAN PAGE!');
        return CaricomRegionMainPage();
      }
      
      // For any other hooks, return our Caribbean page as well to ensure it shows
      print('� REPLACING ANY HOOK WITH CARIBBEAN PAGE!');
      return CaricomRegionMainPage();
    };

    return homeWidgetsHook;
  }

  PaymentHook getPaymentHook() {
    PaymentHook hook = (
      List<String> productIds,
      String? membershipPackageId,
      String? propertyId,
      bool isMembership,
      bool isFeaturedForPerListing,
    ) {
      return null;
    };

    return hook;
  }

  @override
  PaymentSuccessfulHook getPaymentSuccessfulHook() {
    PaymentSuccessfulHook hook = (BuildContext context, bool success) {};
    return hook;
  }

  @override
  MembershipPackageUpdatedHook getMembershipPackageUpdatedHook() {
    MembershipPackageUpdatedHook hook = (BuildContext context, bool updated) {};
    return hook;
  }

  @override
  MembershipPayWallDesignHook getMembershipPayWallDesignHook() {
    MembershipPayWallDesignHook hook = (BuildContext context) {
      return "ListView";
    };
    return hook;
  }

  @override
  AddPlusButtonInBottomBarHook getAddPlusButtonInBottomBarHook() {
    AddPlusButtonInBottomBarHook hook = (BuildContext context) {
      return null;
    };
    return hook;
  }

  @override
  NavbarWidgetsHook getNavbarWidgetsHook() {
    NavbarWidgetsHook navbarWidgetsHook = (
      BuildContext context,
      String? hookName,
    ) {
      return null;
    };

    return navbarWidgetsHook;
  }

  @override
  ClusterMarkerIconHook getCustomizeClusterMarkerIconHook() {
    ClusterMarkerIconHook customizedClusterMarkerIconHook = () {
      return null;
    };

    return customizedClusterMarkerIconHook;
  }

  @override
  CustomClusterMarkerIconHook getCustomClusterMarkerIconHook() {
    CustomClusterMarkerIconHook customClusterMarkerIconHook =
        (BuildContext context, int clusterSize) {
      return null;
    };

    return customClusterMarkerIconHook;
  }

  @override
  MinimumPasswordLengthHook getMinimumPasswordLengthHook() {
    MinimumPasswordLengthHook minimumPasswordLengthHook = () {
      return 8;
    };
    return minimumPasswordLengthHook;
  }

  @override
  AgentProfileConfigurationsHook getAgentProfileConfigurationsHook() {
    AgentProfileConfigurationsHook agentProfileConfigurationsHook = (hook) {
      return null;
    };
    return agentProfileConfigurationsHook;
  }

  @override
  AddPropertyActionHook? getAddPropertyActionHook() {
    // Return null to let the default Add Property functionality work
    // This should prevent any interference with the normal flow
    print('� AddPropertyActionHook disabled - using default behavior');
    return null;
  }

  @override
  DrawerMenuItemDesignHook? getDrawerMenuItemDesignHook() {
    DrawerMenuItemDesignHook drawerMenuItemDesignHook = ({
      required String label,
      required IconData iconData,
      required String selectedItem,
      required VoidCallback? onTap,
    }) {
      try {
        // Get current user info safely
        bool isLoggedIn = HiveStorageManager.readData(key: USER_LOGGED_IN) ?? false;
        String userRole = HiveStorageManager.getUserRole();
        
        print('🔍 DrawerMenuItemDesignHook - label: "$label", isLoggedIn: $isLoggedIn, userRole: "$userRole"');
        
        // Extra debug for Login items
        if (label.toLowerCase().contains('login')) {
          print('🔍 LOGIN ITEM DETECTED - userRole: "$userRole", checking guest condition...');
        }
        
        // Hide Add Property items for guests (ONLY AGENCIES CAN ADD PROPERTIES!)
        if (label.toLowerCase().contains('add property') || label.toLowerCase().contains('quick add')) {
          print('🔍 ADD PROPERTY CHECK - userRole: "$userRole", expected buyer: "$USER_ROLE_BUYER_VALUE", expected agency: "$USER_ROLE_AGENCY_VALUE"');
          
          // ONLY agencies can access Add Property features
          if (userRole != USER_ROLE_AGENCY_VALUE) {
            print('🚫 HIDING menu item "$label" - user is not agency (role: $userRole, logged: $isLoggedIn)');
            return SizedBox.shrink();
          } else {
            print('✅ Showing Add Property for agency user: $userRole');
          }
        }
        
        // Hide agency-specific items for guests  
        if (userRole == USER_ROLE_BUYER_VALUE || !isLoggedIn) {
          if (label.contains('CRM Dashboard') || label.contains('Property Request')) {
            print('🚫 HIDING agency menu item "$label" for guest');
            return SizedBox.shrink();
          }
        }
        
        // Replace Login with Logout for logged in users
        if (label.toLowerCase().contains('login')) {
          print('🔍 LOGIN ITEM - userRole: "$userRole", isLoggedIn: $isLoggedIn');
          
          // For any logged in user (guest or agency), show logout
          if (isLoggedIn && (userRole == USER_ROLE_BUYER_VALUE || userRole == USER_ROLE_AGENCY_VALUE)) {
            print('✅ Showing LOGOUT for logged in user (role: $userRole)');
            return Builder(
              builder: (BuildContext ctx) {
                return ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    print('🚀 LOGOUT CLICKED FROM DRAWER');
                    // Clear session and update Provider
                    HiveStorageManager.clearData();
                    UserLoggedProvider().loggedOut();
                    // Close drawer first, then navigate
                    Navigator.pop(ctx);
                    Navigator.of(ctx).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => AgencyLoginPage()),
                      (route) => false,
                    );
                  },
                );
              },
            );
          } else {
            print('✅ Showing Agency LOGIN for not logged in user');
            return Builder(
              builder: (BuildContext ctx) {
                return ListTile(
                  leading: Icon(Icons.login, color: Colors.green),
                  title: Text(
                    'Agency Login',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    print('🚀 AGENCY LOGIN CLICKED FROM DRAWER');
                    Navigator.pop(ctx);
                    Navigator.of(ctx).push(
                      MaterialPageRoute(builder: (context) => AgencyLoginPage()),
                    );
                  },
                );
              },
            );
          }
        }
        
        // For all other cases, return null to use default design
        return null;
      } catch (e) {
        print('❌ Error in DrawerMenuItemDesignHook: $e');
        // Return null to use default design on error
        return null;
      }
    };
    
    return drawerMenuItemDesignHook;
  }

    @override
  UserLoginActionHook? getUserLoginActionHook() {
    // Redirect default Houzi login to our custom Agency Login page
    // This prevents WordPress API calls
    UserLoginActionHook hook = ({
      required BuildContext context,
      required void Function() defaultLoginFunc,
      required GlobalKey<FormState> formKey,
      required String loginNonce,
      required String password,
      required String usernameEmail,
    }) {
      print('🔒 Login intercepted - redirecting to Agency Login page');
      print('📧 Username/Email: $usernameEmail');
      
      // Navigate to Agency Login page instead of using WordPress auth
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AgencyLoginPage()),
      );
    };
    
    return hook;
  }

  @override
  DefaultAppThemeModeHook? getDefaultAppThemeModeHook() {
    DefaultAppThemeModeHook defaultAppThemeModeHook = () {
      return "light";
    };

    return defaultAppThemeModeHook;
  }

  @override
  MessageApiRefreshTimeHook? getMessageApiRefreshTimeHook() {
    MessageApiRefreshTimeHook? messageApiRefreshTimeHook = () {
      return 5;
    };

    return messageApiRefreshTimeHook;
  }

  @override
  ThreadApiRefreshTimeHook? getThreadApiRefreshTimeHook() {
    ThreadApiRefreshTimeHook? threadApiRefreshTimeHook = () {
      return 5;
    };

    return threadApiRefreshTimeHook;
  }
}
