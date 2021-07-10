import 'package:qmanager_flutter_updated/model/UserModel.dart';

class AppConstant {
//========== MUST CHECK VALUES FOR PUBLISHING IN STORE =================//

  //Base URL Staging
  //static String API_BASE_URL = "http://ilomadev.com/qmanager/api/";
  //static String IMG_BASE_URL = "http://ilomadev.com/qmanager/public/images/";

  //Base URL iLoma Production
//  static String API_BASE_URL = "http://ilomadev.com/qmanager_production/api/";
//  static String IMG_BASE_URL =
//      "http://ilomadev.com/qmanager_production/public/images/";

//  //Base URL Staging
  // static String API_BASE_URL = "https://cvbuildertobeu.com/qmanager/api/";
  // static String IMG_BASE_URL = "https://cvbuildertobeu.com/qmanager/public/images/";

  //Base URL Production
  static String API_BASE_URL =
      "https://qmanager.to-be-u.com/qmanager_demo/api/";
  static String IMG_BASE_URL =
      "https://qmanager.to-be-u.com/qmanager_demo/public/images/";

  static String CURRENT_IOS_VERSION = "1.0.3";
  static String CURRENT_ANDROID_VERSION = "1.0.2";

//============ END OF HIGH IMPORTANT VALUES =========================//

//  static final String API_LOGIN = API_BASE_URL + "v1/user/login";

  static final String API_LOGIN = API_BASE_URL + "v2/user/login";

//  static final String API_SIGN_UP = API_BASE_URL + "v1/user/register";

  static final String API_SIGN_UP = API_BASE_URL + "v2/user/register";

  static final String API_FORGOT_PASS =
      API_BASE_URL + "v1/user/forgot_password";
  static final String API_UPDATE_PASS =
      API_BASE_URL + "v1/user/update_password";
  static final String API_CITY_LIST = API_BASE_URL + "v1/get-city";
  static final String API_STATE_LIST = API_BASE_URL + "v1/get-states";

  static final String API_COUNTRY_LIST = API_BASE_URL + "v1/get-country";

//  static final String API_SHOP_LIST = API_BASE_URL + "v1/outlet/get_shoplist";
  static final String API_SHOP_LIST = API_BASE_URL + "v2/outlet/get_shoplist";

//  static final String API_UPCOMING_BOOKING_LIST =
//      API_BASE_URL + "v1/booking/get_upcoming_booking_list";

  static final String API_UPCOMING_BOOKING_LIST =
      API_BASE_URL + "v2/booking/get_upcoming_booking_list";

//  static final String API_PAST_BOOKING_LIST =
//      API_BASE_URL + "v1/booking/get_past_booking_list";

  static final String API_PAST_BOOKING_LIST =
      API_BASE_URL + "v2/booking/get_past_booking_list";

//  static final String API_BOOKING_DETAIL =
//      API_BASE_URL + "v2/booking/get_booking_details";

  static final String API_BOOKING_DETAIL =
      API_BASE_URL + "v3/booking/get_booking_details";

//  static final String API_OUTLET_DETAIL =
////      API_BASE_URL + "v1/outlet/outlet_details";

  static final String API_OUTLET_DETAIL =
      API_BASE_URL + "v2/outlet/outlet_details";

  static final String API_ADD_BOOKING = API_BASE_URL + "v1/booking/add_booking";
  static final String API_CANCEL_BOOKING =
      API_BASE_URL + "v1/booking/booking_cancelled";
  static final String API_TRANSFER_BOOKING =
      API_BASE_URL + "v1/booking/booking_transfer";
  static final String API_BOOKING_VISITED =
      API_BASE_URL + "v1/booking/booking_visited";

//  static final String API_UPDATE_PROFILE =
//      API_BASE_URL + "v1/user/update_profile";

  static final String API_UPDATE_PROFILE =
      API_BASE_URL + "v2/user/update_profile";

  static final String API_APP_VERSION = API_BASE_URL + "v1/get_app_version";

  static final String API_UPDATE_DEVICE_TOKEN =
      API_BASE_URL + "v1/user/update_device_token";

  static final String API_NOTIFICATION_LIST =
      API_BASE_URL + "v1/notification/get_notification";
  static final String API_NOTIFICATION_COUNT =
      API_BASE_URL + "v1/notification/notification_count";

  static final String API_LOGOUT = API_BASE_URL + "v1/user/logout";

  //Constants
  static bool IS_TEST = false;
  static int PAGE_LIMIT = 10;
  static bool SHOULD_RELOAD = false;
  static bool SHOULD_CART_COUNT_RELOAD = false;
  static UserModel userModel;

  static int REQUEST_TIMEOUT = 1000 * 60;

  static String APPSTORE_ID = "1518570715";

  static String TOPIC = "QM_";

  //URLS
  static final String OUTLET_THUMB_PLACEHOLDER = IMG_BASE_URL + "img_dummy.png";
  static final String VENDOR_THUMB_PLACEHOLDER =
      IMG_BASE_URL + "vendor_profile_dummy.png";

  static final String OUTLET_BANNER_PLACEHOLDER =
      IMG_BASE_URL + "outlet_banner_dummy.jpg";

  static final String PRIVACY_POLICY_URL =
      "https://qmanager.to-be-u.com/privacy-policy";
}
