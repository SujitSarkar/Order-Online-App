import 'dart:convert';

SettingsDataModel settingsDataModelFromJson(String str) =>
    SettingsDataModel.fromJson(json.decode(str));

class SettingsDataModel {
  final bool? status;
  final Data? data;
  final String? message;

  SettingsDataModel({
    this.status,
    this.data,
    this.message,
  });

  factory SettingsDataModel.fromJson(Map<String, dynamic> json) =>
      SettingsDataModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );
}

class Data {
  final bool? expandSidebar;
  final bool? stickyHeader;
  final bool? appDebug;
  final String? siteTitle;
  final String? siteLanguage;
  final String? timeZone;
  final String? currency;
  final String? locale;
  final String? currencySymbol;
  final String? countryCode;
  final bool? showCookieBanner;
  final String? cookieBannerMessages;
  final String? footerShortDescription;
  final String? property;
  final String? street;
  final String? city;
  final String? state;
  final String? postcode;
  final String? latitude;
  final String? longitude;
  final String? country;
  final String? companyName;
  final String? companyRegistrationNumber;
  final String? iosAppUrl;
  final String? androidAppUrl;
  final String? twitterUrl;
  final String? tumblrUrl;
  final String? linkedinUrl;
  final String? instagramUrl;
  final String? pinterestUrl;
  final String? facebookUrl;
  final String? tripAdvisor;
  final String? email;
  final String? phone;
  final String? fax;
  final String? landline;
  final bool? orderStatus;
  final String? orderDisableMessage;
  final bool? reservationStatus;
  final String? reservationDisableMessage;
  final String? reservationBufferTime;
  final String? reservationTotalSeats;
  final String? reservationDuration;
  final String? reservationTimeInterval;
  final String? reservationDepositAmount;
  final String? collectionOrderMinimum;
  final String? deliveryOrderMinimum;
  final String? bagChargeAmount;
  final String? serviceChargeAmount;
  final bool? showTipsGivingOption;
  final bool? maintenanceMode;
  final String? maintenanceText;
  final String? ipBasedMaintenance;
  final String? paymentType;
  final String? homePageCaption;
  final String? homePageTagline;
  final String? siteLogoSmall;
  final String? siteLogoLarge;
  final String? favicon;
  final String? metaKeyword;
  final String? metaDescription;
  final String? userAgreementUrl;
  final String? privacyPolicyUrl;
  final String? merchantName;
  final String? sliderImg1;
  final String? sliderImg2;
  final String? sliderImg3;
  final String? sliderImg4;
  final String? sliderImg5;
  final String? sliderImgMobile1;
  final String? sliderImgMobile2;
  final String? sliderImgMobile3;
  final String? sliderImgMobile4;
  final String? sliderImgMobile5;
  final String? sliderVid;
  final String? sliderVidPoster;
  final bool? sliderVidEnable;
  final String? awardImg1;
  final String? awardImg2;
  final String? awardImg3;
  final String? awardImg4;
  final String? galleryImg1;
  final String? galleryImg2;
  final String? galleryImg3;
  final String? galleryImg4;
  final String? galleryImg5;
  final String? galleryImg6;
  final String? galleryImg7;
  final String? galleryImg8;
  final String? galleryImg9;
  final String? galleryImg10;
  final String? galleryImg11;
  final String? galleryImg12;
  final String? aboutTitle;
  final String? aboutDescription;
  final String? aboutImg;
  final String? reservationImg;
  final String? contactMap;
  final String? allergyInformation;
  final String? foodImg1;
  final String? foodImgTitle1;
  final String? foodImg2;
  final String? foodImgTitle2;
  final String? foodImg3;
  final String? foodImgTitle3;
  final String? foodImg4;
  final String? foodImgTitle4;
  final bool? paymentCash;
  final bool? paymentCard;
  final bool? navbarFixed;
  final String? displayEmail;
  final String? promotionalSliderImg1;
  final String? promotionalSliderImg2;
  final String? promotionalSliderImg3;
  final String? promotionalSliderTitle1;
  final String? promotionalSliderTitle2;
  final String? promotionalSliderTitle3;
  final String? promotionalSliderSubtitle1;
  final dynamic promotionalSliderSubtitle2;
  final String? promotionalSliderSubtitle3;
  final bool? promotionalSliderEnable;
  final bool? paymentStripe;
  final String? promotionalImgBackgroundColor;
  final String? promotionalTitleColor;
  final String? promotionalBtnBackgroundColor;
  final String? promotionalBtnTextColor;
  final bool? promotionalSliderBtnShow1;
  final bool? promotionalSliderBtnShow2;
  final bool? promotionalSliderBtnShow3;
  final bool? promotionalSlider1Delete;
  final bool? promotionalSlider2Delete;
  final bool? promotionalSlider3Delete;
  final String? promotionalSliderBtnTitle1;
  final dynamic promotionalSliderBtnTitle2;
  final dynamic promotionalSliderBtnTitle3;
  final String? promotionalSliderBtnLink1;
  final dynamic promotionalSliderBtnLink2;
  final dynamic promotionalSliderBtnLink3;
  final bool? pointsEnabled;
  final String? googleAnalyticsId;
  final String? facebookPixels;
  final String? sas;
  final String? test;
  final bool? asdasd;

  Data({
    this.expandSidebar,
    this.stickyHeader,
    this.appDebug,
    this.siteTitle,
    this.siteLanguage,
    this.timeZone,
    this.currency,
    this.locale,
    this.currencySymbol,
    this.countryCode,
    this.showCookieBanner,
    this.cookieBannerMessages,
    this.footerShortDescription,
    this.property,
    this.street,
    this.city,
    this.state,
    this.postcode,
    this.latitude,
    this.longitude,
    this.country,
    this.companyName,
    this.companyRegistrationNumber,
    this.iosAppUrl,
    this.androidAppUrl,
    this.twitterUrl,
    this.tumblrUrl,
    this.linkedinUrl,
    this.instagramUrl,
    this.pinterestUrl,
    this.facebookUrl,
    this.tripAdvisor,
    this.email,
    this.phone,
    this.fax,
    this.landline,
    this.orderStatus,
    this.orderDisableMessage,
    this.reservationStatus,
    this.reservationDisableMessage,
    this.reservationBufferTime,
    this.reservationTotalSeats,
    this.reservationDuration,
    this.reservationTimeInterval,
    this.reservationDepositAmount,
    this.collectionOrderMinimum,
    this.deliveryOrderMinimum,
    this.bagChargeAmount,
    this.serviceChargeAmount,
    this.showTipsGivingOption,
    this.maintenanceMode,
    this.maintenanceText,
    this.ipBasedMaintenance,
    this.paymentType,
    this.homePageCaption,
    this.homePageTagline,
    this.siteLogoSmall,
    this.siteLogoLarge,
    this.favicon,
    this.metaKeyword,
    this.metaDescription,
    this.userAgreementUrl,
    this.privacyPolicyUrl,
    this.merchantName,
    this.sliderImg1,
    this.sliderImg2,
    this.sliderImg3,
    this.sliderImg4,
    this.sliderImg5,
    this.sliderImgMobile1,
    this.sliderImgMobile2,
    this.sliderImgMobile3,
    this.sliderImgMobile4,
    this.sliderImgMobile5,
    this.sliderVid,
    this.sliderVidPoster,
    this.sliderVidEnable,
    this.awardImg1,
    this.awardImg2,
    this.awardImg3,
    this.awardImg4,
    this.galleryImg1,
    this.galleryImg2,
    this.galleryImg3,
    this.galleryImg4,
    this.galleryImg5,
    this.galleryImg6,
    this.galleryImg7,
    this.galleryImg8,
    this.galleryImg9,
    this.galleryImg10,
    this.galleryImg11,
    this.galleryImg12,
    this.aboutTitle,
    this.aboutDescription,
    this.aboutImg,
    this.reservationImg,
    this.contactMap,
    this.allergyInformation,
    this.foodImg1,
    this.foodImgTitle1,
    this.foodImg2,
    this.foodImgTitle2,
    this.foodImg3,
    this.foodImgTitle3,
    this.foodImg4,
    this.foodImgTitle4,
    this.paymentCash,
    this.paymentCard,
    this.navbarFixed,
    this.displayEmail,
    this.promotionalSliderImg1,
    this.promotionalSliderImg2,
    this.promotionalSliderImg3,
    this.promotionalSliderTitle1,
    this.promotionalSliderTitle2,
    this.promotionalSliderTitle3,
    this.promotionalSliderSubtitle1,
    this.promotionalSliderSubtitle2,
    this.promotionalSliderSubtitle3,
    this.promotionalSliderEnable,
    this.paymentStripe,
    this.promotionalImgBackgroundColor,
    this.promotionalTitleColor,
    this.promotionalBtnBackgroundColor,
    this.promotionalBtnTextColor,
    this.promotionalSliderBtnShow1,
    this.promotionalSliderBtnShow2,
    this.promotionalSliderBtnShow3,
    this.promotionalSlider1Delete,
    this.promotionalSlider2Delete,
    this.promotionalSlider3Delete,
    this.promotionalSliderBtnTitle1,
    this.promotionalSliderBtnTitle2,
    this.promotionalSliderBtnTitle3,
    this.promotionalSliderBtnLink1,
    this.promotionalSliderBtnLink2,
    this.promotionalSliderBtnLink3,
    this.pointsEnabled,
    this.googleAnalyticsId,
    this.facebookPixels,
    this.sas,
    this.test,
    this.asdasd,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        expandSidebar: json["expand_sidebar"],
        stickyHeader: json["sticky_header"],
        appDebug: json["app_debug"],
        siteTitle: json["site_title"],
        siteLanguage: json["site_language"],
        timeZone: json["time_zone"],
        currency: json["currency"],
        locale: json["locale"],
        currencySymbol: json["currency_symbol"],
        countryCode: json["country_code"],
        showCookieBanner: json["show_cookie_banner"],
        cookieBannerMessages: json["cookie_banner_messages"],
        footerShortDescription: json["footer_short_description"],
        property: json["property"],
        street: json["street"],
        city: json["city"],
        state: json["state"],
        postcode: json["postcode"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        country: json["country"],
        companyName: json["company_name"],
        companyRegistrationNumber: json["company_registration_number"],
        iosAppUrl: json["ios_app_url"],
        androidAppUrl: json["android_app_url"],
        twitterUrl: json["twitter_url"],
        tumblrUrl: json["tumblr_url"],
        linkedinUrl: json["linkedin_url"],
        instagramUrl: json["instagram_url"],
        pinterestUrl: json["pinterest_url"],
        facebookUrl: json["facebook_url"],
        tripAdvisor: json["trip_advisor"],
        email: json["email"],
        phone: json["phone"],
        fax: json["fax"],
        landline: json["landline"],
        orderStatus: json["order_status"],
        orderDisableMessage: json["order_disable_message"],
        reservationStatus: json["reservation_status"],
        reservationDisableMessage: json["reservation_disable_message"],
        reservationBufferTime: json["reservation_buffer_time"],
        reservationTotalSeats: json["reservation_total_seats"],
        reservationDuration: json["reservation_duration"],
        reservationTimeInterval: json["reservation_time_interval"],
        reservationDepositAmount: json["reservation_deposit_amount"],
        collectionOrderMinimum: json["collection_order_minimum"],
        deliveryOrderMinimum: json["delivery_order_minimum"],
        bagChargeAmount: json["bag_charge_amount"],
        serviceChargeAmount: json["service_charge_amount"],
        showTipsGivingOption: json["show_tips_giving_option"],
        maintenanceMode: json["maintenance_mode"],
        maintenanceText: json["maintenance_text"],
        ipBasedMaintenance: json["ip_based_maintenance"],
        paymentType: json["payment_type"],
        homePageCaption: json["home_page_caption"],
        homePageTagline: json["home_page_tagline"],
        siteLogoSmall: json["site_logo_small"],
        siteLogoLarge: json["site_logo_large"],
        favicon: json["favicon"],
        metaKeyword: json["meta_keyword"],
        metaDescription: json["meta_description"],
        userAgreementUrl: json["user_agreement_url"],
        privacyPolicyUrl: json["privacy_policy_url"],
        merchantName: json["merchant_name"],
        sliderImg1: json["slider_img_1"],
        sliderImg2: json["slider_img_2"],
        sliderImg3: json["slider_img_3"],
        sliderImg4: json["slider_img_4"],
        sliderImg5: json["slider_img_5"],
        sliderImgMobile1: json["slider_img_mobile_1"],
        sliderImgMobile2: json["slider_img_mobile_2"],
        sliderImgMobile3: json["slider_img_mobile_3"],
        sliderImgMobile4: json["slider_img_mobile_4"],
        sliderImgMobile5: json["slider_img_mobile_5"],
        sliderVid: json["slider_vid"],
        sliderVidPoster: json["slider_vid_poster"],
        sliderVidEnable: json["slider_vid_enable"],
        awardImg1: json["award_img_1"],
        awardImg2: json["award_img_2"],
        awardImg3: json["award_img_3"],
        awardImg4: json["award_img_4"],
        galleryImg1: json["gallery_img_1"],
        galleryImg2: json["gallery_img_2"],
        galleryImg3: json["gallery_img_3"],
        galleryImg4: json["gallery_img_4"],
        galleryImg5: json["gallery_img_5"],
        galleryImg6: json["gallery_img_6"],
        galleryImg7: json["gallery_img_7"],
        galleryImg8: json["gallery_img_8"],
        galleryImg9: json["gallery_img_9"],
        galleryImg10: json["gallery_img_10"],
        galleryImg11: json["gallery_img_11"],
        galleryImg12: json["gallery_img_12"],
        aboutTitle: json["about_title"],
        aboutDescription: json["about_description"],
        aboutImg: json["about_img"],
        reservationImg: json["reservation_img"],
        contactMap: json["contact_map"],
        allergyInformation: json["allergy_information"],
        foodImg1: json["food_img_1"],
        foodImgTitle1: json["food_img_title_1"],
        foodImg2: json["food_img_2"],
        foodImgTitle2: json["food_img_title_2"],
        foodImg3: json["food_img_3"],
        foodImgTitle3: json["food_img_title_3"],
        foodImg4: json["food_img_4"],
        foodImgTitle4: json["food_img_title_4"],
        paymentCash: json["payment_cash"],
        paymentCard: json["payment_card"],
        navbarFixed: json["navbar_fixed"],
        displayEmail: json["display_email"],
        promotionalSliderImg1: json["promotional_slider_img_1"],
        promotionalSliderImg2: json["promotional_slider_img_2"],
        promotionalSliderImg3: json["promotional_slider_img_3"],
        promotionalSliderTitle1: json["promotional_slider_title_1"],
        promotionalSliderTitle2: json["promotional_slider_title_2"],
        promotionalSliderTitle3: json["promotional_slider_title_3"],
        promotionalSliderSubtitle1: json["promotional_slider_subtitle_1"],
        promotionalSliderSubtitle2: json["promotional_slider_subtitle_2"],
        promotionalSliderSubtitle3: json["promotional_slider_subtitle_3"],
        promotionalSliderEnable: json["promotional_slider_enable"],
        paymentStripe: json["payment_stripe"],
        promotionalImgBackgroundColor: json["promotional_img_background_color"],
        promotionalTitleColor: json["promotional_title_color"],
        promotionalBtnBackgroundColor: json["promotional_btn_background_color"],
        promotionalBtnTextColor: json["promotional_btn_text_color"],
        promotionalSliderBtnShow1: json["promotional_slider_btn_show_1"],
        promotionalSliderBtnShow2: json["promotional_slider_btn_show_2"],
        promotionalSliderBtnShow3: json["promotional_slider_btn_show_3"],
        promotionalSlider1Delete: json["promotional_slider_1_delete"],
        promotionalSlider2Delete: json["promotional_slider_2_delete"],
        promotionalSlider3Delete: json["promotional_slider_3_delete"],
        promotionalSliderBtnTitle1: json["promotional_slider_btn_title_1"],
        promotionalSliderBtnTitle2: json["promotional_slider_btn_title_2"],
        promotionalSliderBtnTitle3: json["promotional_slider_btn_title_3"],
        promotionalSliderBtnLink1: json["promotional_slider_btn_link_1"],
        promotionalSliderBtnLink2: json["promotional_slider_btn_link_2"],
        promotionalSliderBtnLink3: json["promotional_slider_btn_link_3"],
        pointsEnabled: json["points_enabled"],
        googleAnalyticsId: json["google_analytics_id"],
        facebookPixels: json["facebook_pixels"],
        sas: json["sas"],
        test: json["test"],
        asdasd: json["asdasd"],
      );
}
