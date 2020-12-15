class Apis {
  static String BASE_URL ='https://lacasa.nqat.me/public/api/v1/';
  static String Base_Url1= 'https://nqatlacasa.herokuapp.com/api/v1';
  
//      "http://203.88.157.74:8001/loyaltyProgram_API/public/api/v1/";
  static String signup = BASE_URL + "signup";
  static String isEmailAvailable = BASE_URL + "isEmailAvailable";
  static String isMobileAvailable = BASE_URL + "isMobileAvailable";
  static String sendOtp = BASE_URL + "send-otp";
  static String customerLogin = BASE_URL + "login";
  static String forgotPassword = BASE_URL + "forgotPassword";
  static String resetPassword = BASE_URL + "resetPassword";
  static String getCampaigns = BASE_URL + "getCampaigns";
  static String customerRefreshAuthToken = BASE_URL + "customer/refresh";
  static String getAllCampaigns = BASE_URL + "staff/getAllCampaigns";
  static String offers = BASE_URL + "offers";
  static String getAllOffers = BASE_URL + "getAllOffers";
  static String offerComplainOptions = BASE_URL + "offer/getClaimOptions";
  static String earnClaimOptions = BASE_URL + "earn/getClaimOptions";
  static String getRedeemOptions = BASE_URL + "reward/getRedeemOptions";
  static String contactUs = BASE_URL + "campaign/contact";
  static String getTotalPoints = BASE_URL + "get-total-points";
  static String getPointsHistory = BASE_URL + "get-point-history";
  static String getOfferHistory = BASE_URL + "get-offer-history";
  static String getRewards = BASE_URL + "get-rewards";
  static String getRedeemRewards = BASE_URL + "campaign/getRewards";
  static String verifyMerchantCode = BASE_URL + "verify-merchant-code";
  static String verifyCustomerCode = BASE_URL + "verify-customer-code";
  static String getClaimPointsToken = BASE_URL + "get-claim-points-token";
  static String getRedeemRewardToken = BASE_URL + "get-redeem-reward-token";
  static String getClaimOfferToken = BASE_URL + "offer/getClaimOfferToken";
  static String updateProfile = BASE_URL + "updateProfile";
  static String getCustomerDetails = BASE_URL + "getCustomerDetails";
  static String getAllIndustries = BASE_URL + "getIndustries";
  static String getOffersByIndustry = BASE_URL + "getOffersByIndustry";
  static String processMerchantEntry = BASE_URL + "earn/processMerchantEntry";
  static String processMerchantEntryReward =
      BASE_URL + "reward/processMerchantEntry";
  static String getRedeemRewardQrToken = BASE_URL + "reward/getRedeemQrToken";
  // customer earn
  static String customerEarnGetPointsQrToken =
      BASE_URL + "earn/getClaimPointsQrToken";
  static String customerEarnProcessMerchantEntry =
      BASE_URL + "earn/processMerchantEntry";
  static String customerEarnVeerifyEnteredCode =
      BASE_URL + "earn/getClaimPointsQrToken";

  //staff collection
  static String staffLogin = BASE_URL + "staff/login";
  static String staffUserInfo = BASE_URL + "staff/getInfo";
  static String staffForgotPassword = BASE_URL + "staff/forgotPassword";
  static String staffUpdateProfile = BASE_URL + "staff/updateProfile";
  static String staffRefreshAuthToken = BASE_URL + "staff/refresh";
  static String staffGetOfferHistory = BASE_URL + "staff/getRecentOfferHistory";
  static String staffCreditPoints = BASE_URL + "staff/earn/creditPoints";
  static String staffGenerateCode = BASE_URL + "staff/earn/generateCode";

  static String staffGenerateMerchantCode =
      BASE_URL + "staff/earn/generateMerchantCode";
//  static String staffForgotPassword = BASE_URL + "staff/getRecentOfferHistory";
//  static String staffGetOfferHistory = BASE_URL + "staff/getRecentOfferHistory";
//  static String staffGetOfferHistory = BASE_URL + "staff/getRecentOfferHistory";
  static String staffGetRecentPointHistory =
      BASE_URL + "staff/getRecentPointHistory";
  static String getPointsFromPurchaseAmount =
      BASE_URL + "getPointsFromPurchaseAmount";
  static String staffGetRewards = BASE_URL + "staff/reward/getRewards";
  static String staffOfferClaimByCustomerNumber =
      BASE_URL + "staff/offer/claimByCustomerNumber";
  static String staffRewardRedeemByCustomerNumber =
      BASE_URL + "staff/reward/redeemByCustomerNumber";
  static String staffOfferValidateQrCodeFormData =
      BASE_URL + "staff/offer/validateQrCodeFormData";
  static String staffGenCodeFromPurchaseAmount =
      BASE_URL + "staff/earn/generateCode";
  static String staffCreditWithCustomerNumber =
      BASE_URL + "staff/earn/creditPoints";
  static String staffGetActiveOffers = BASE_URL + "staff/offer/getActiveOffers";
  static String staffClaimOfferByCustomerNumber =
      BASE_URL + "staff/offer/claimByCustomerNumber";
  static String staffValidateOfferQR =
      BASE_URL + "staff/offer/validateQrCodeFormData";
  static String staffValidateRedeemRewardQR =
      BASE_URL + "staff/reward /validateQrCodeFormData";
  static String staffValidatePointsQR =
      BASE_URL + "staff/earn/validateQrCodeFormData";
}
