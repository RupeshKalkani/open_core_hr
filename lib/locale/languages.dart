import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) =>
      Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get lblSelectDateRange;

  String get lblOrganization;

  String get lblStart;

  String get lblEnd;

  String get lblNoRequestsFound;

  String get lblRequestedBy;

  String get lblCallNow;

  String get lblCreatedOn;

  String get lblFileForwardedSuccessfully;

  //Long words

  String get lblDoYouWantToLogoutFromTheApp;

  String get lblAreYouSureYouWantToDelete;

  String get lblLanguageChanged;

  String get lblLoggedOutSuccessfully;

  String get lblCommentsIsRequired;

  String get lblVerificationFailedPleaseTryAgain;

  String get lblThisDeviceIsNotRegisteredClickOnRegisterToAddItToYourAccount;

  String
      get lblThisDeviceIsAlreadyRegisteredWithOtherAccountPleaseContactAdministrator;

  String get lblEnterYourPhoneNumberToSendAnOTP;

  String
      get lblWeHaveSendA4DigitVerificationCodeToYourPhonePleaseEnterTheCodeBelowTtoVerifyItsYou;

  String get lblPasswordSuccessfullyChanged;

  String get lblPleaseAllowAllTheTimeInSettings;

  String get lblPleaseEnableAllowAllTheTimeInSettings;

  String get lblPleaseEnablePhysicalActivityPermissionInSettings;

  String get lblToEnableAutomaticAttendance;

  String get lblToTrackTheDistanceTravelled;

  String get lblToMarkClientVisits;

  String get lblToProcessTheSalary;

  String
      get lblLocationWillBeTrackedTnTheBackgroundAndAlsoEvenWhenTheAppIsClosedOrNotInUse;

  String
      get lblImportantGiveLocationAccuracyToPreciseAndAllowAllTheTimeSoThatTheAppCanFunctionProperly;

  String get lblCollectsPhysicalActivityData;

  String get lblToCheckTheDeviceStateToEnableTrackingWhenTravelling;

  String get lblYourAccountIsBanned;

  String get lblEnableAutoStart;

  String get lblFollowTheStepsAndEnableTheAutoStartOfThisApp;

  String get lblYourDeviceHasAdditionalBatteryOptimization;

  String
      get lblFollowTheStepsAndDisableTheOptimizationsToAllowSmoothFunctioningOfThisApp;

  String get lblAreYouSureYouWantToCheckOut;

  String get lblLoadingPleaseWait;

  String get lblPleaseSetUpYourTouchId;

  String get lblPleaseReEnableYourTouchId;

  String get lblAuthenticateWithFingerprintOrPasswordToProceed;

  String get lblFingerprintOrPinVerificationIsRequiredForCheckInAndOut;

  String get lblCityIsRequired;

  String get lblAddressIsRequired;

  String get lblPleasePickALocation;

  String get lblContactPersonNameIsRequired;

  String get lblPhoneNumberIsRequired;

  String get lblNameIsRequired;

  String get lblClientAdded;

  String get lblRemarksIsRequired;

  String get lblAmountIsRequired;

  String get lblSomethingWentWrongWhileUploadingTheFile;

  String get lblPleaseAllowMotionTracking;

  String get lblTrackingStartedAt;

  String get lblActivityCount;

  String get lblLocationCount;

  String get lblLastLocation;

  String get lblRefresh;

  String get lblDeviceStatusUpdateInterval;

  String get lblBackgroundServiceStatus;

  String get lblBackgroundLocationTracker;

  String get lblDeviceStatus;

  String get lblRunning;

  String get lblStopped;

  String get lblRefreshAppConfiguration;

  String get lblSettingsRefreshed;

  //Ends

  String get lblEnterValidDate;

  String get lblEnterDateInValidRange;

  String get lblYouCannotSelectOlderDates;

  String get lblLeaveTo;

  String get lblPleaseTryAgainLater;

  String get lblPleaseTryAgain;

  String get lblLeaveFrom;

  String get lblChoose;

  String get lblFromDate;

  String get lblClaimed;

  String get lblYou;

  String get lblYourAccountIsActive;

  String get lblBanned;

  String get lblYouReBanned;

  String get lblKindlyContactAdministrator;

  String get lblPleaseTypeAMessageFirst;

  String get lblOpenSecuritySettings;

  String get lblFingerprintAuthentication;

  String get lblCancel;

  String get lblTodayAttendance;

  String get lblNotifications;

  String get lblRegisterNow;

  String get lblSun;

  String get lblMon;

  String get lblTue;

  String get lblWed;

  String get lblThu;

  String get lblFri;

  String get lblSat;

  String get lblVerified;

  String get lblSearchByAddress;

  String get lblAllSet;

  String get lblActivityAccess;

  String get lblCollectsLocationData;

  String get lblNewPassword;

  String get lblPasswordIsRequired;

  String get lblSendOTP;

  String get lblVerifyOTP;

  String get lblChange;

  String get lblInvalidPassword;

  String get lblExpenseType;

  String get lblNoMessages;

  String get lblTypeYourMessage;

  String get lblPickAddress;

  String get lblConfirm;

  String get lblSearchHere;

  String get lblCheckOut;

  String get lblVerifyIdentity;

  String get lblScanYourFingerprintToCheckIn;

  String get lblAreYouSureYouWantToCheckIn;

  String get lblAllDoneForToday;

  String get lblClient;

  String get lblVerificationFailed;

  String get lblVerificationPending;

  String get lblYourDeviceVerificationIsPending;

  String get lblNewDevice;

  String get lblVisits;

  String get lblImageIsRequired;

  String get lblSubmittedSuccessfully;

  String get lblToday;

  String get lblExpenseStatus;

  String get lblAttendanceInAt;

  String get lblAttendanceOutAt;

  String get lblNoRequests;

  String get lblPrivacyPolicy;

  String get lblLeave;

  String get lblChangeLanguage;

  //Login
  String get lblLogin;

  String get lblSignIn;

  String get lblSignOut;

  String get lblUserName;

  String get lblPassword;

  String get lblRememberMe;

  String get lblForgotPassword;

  String get lblVerification;

  String get lblAccount;

  String get lblDarkMode;

  String get lblNotification;

  String get lblArabic;

  String get lblEnglish;
  //Other

  String get lblDocumentation;

  String get lblChangeLog;

  String get lblShareApp;

  String get lblRateUs;

  String get lblSettings;

  String get lblLanguage;

  String get lblSupportLanguage;

  String get lblDefaultTheme;

  String get lblDashboard;

  String get lblSetupConfiguration;

  String get lblVersionHistory;

  String get lblShareWithFriends;

  String get lblRateGooglePlayStore;

  String get lblContactUs;

  String get lblGetInTouchWithUs;

  String get lblAboutUs;

  String get lblSupport;

  String get lblVersion;

  String get lblAboutUsDescription;

  String get lblHome;

  String get lblAttendanceStatus;

  String get lblCheckInToBegin;

  String get lblCheckIn;

  String get lblExpense;

  String get lblCreateExpense;

  String get lblDate;

  String get lblLeaveType;

  String get lblAmount;

  String get lblRemarks;

  String get lblChooseImage;

  String get lblSubmit;

  String get lblGoodMorning;

  String get lblName;

  String get lblTodayDate;

  String get lblShift;

  String get lblAttendanceInformation;

  String get lblKM;

  String get lblDays;

  String get lblPresent;

  String get lblHalfDay;

  String get lblAbsent;

  String get lblWeeklyOff;

  String get lblOnLeave;

  String get lblAvailableLeave;

  String get lblDistance;

  String get lblTravelled;

  String get lblApproved;

  String get lblPending;

  String get lblRejected;

  String get lblLeaveRequest;

  String get lblFrom;

  String get lblTo;

  String get lblNoRequest;

  String get lblComments;

  String get lblClients;

  String get lblCreateClient;

  String get lblEmail;

  String get lblPhoneNumber;

  String get lblContactPerson;

  String get lblAddress;

  String get lblCity;

  String get lblLogout;

  String get lblClickToAddImage;

  String get lblUsername;

  String get lblByLoggingInYouAreAgreedToThePrivacyPolicy;

  String get lblClickHereToReadPrivacyPolicy;

  String get lblDeviceVerification;

  String get lblVerificationCompleted;

  String get lblYourDeviceVerificationIsSuccessfullyCompleted;

  String get lblOk;

  String get lblWelcomeBack;

  String get lblLocationAccess;

  String get lblVerifying;

  String get lblPleaseWait;

  String get lblEnablePermission;

  String get lblLogOut;

  String get lblConfirmation;

  String get lblYes;

  String get lblNo;

  String get lblSuccessfullyCheckIn;

  String get lblMarkVisit;

  String get lblVisitHistory;

  String get lblRequestSuccessfullySubmitted;

  String get lblChats;

  String get lblSuccessfullyCheckOut;

  String get lblHoldOn;

  String get lblNote;

  String get lblTasks;

  String get lblNoticeBoard;

  String get lblMore;

  String get lblTaskSystemIsNotEnabled;

  String get lblUpcoming;

  String get lblHold;

  String get lblCompleted;

  String get lblNoRunningTask;

  String get lblTaskHeldSuccessfully;

  String get lblTaskCompletedSuccessfully;

  String get lblNoUpcomingTasks;

  String get lblTaskStartedSuccessfully;

  String get lblTaskResumedSuccessfully;

  String get lblNoTasksAreOnHold;

  String get lblNoCompletedTasks;

  String get lblResumeTask;

  String get lblAreYouSureYouWantToResumeThisTask;

  String get lblTaskId;

  String get lblStatus;

  String get lblTitle;

  String get lblStartedOn;

  String get lblDetails;

  String get lblResume;

  String get lblComplete;

  String get lblUpdates;

  String get lblHoldTask;

  String get lblAreYouSureYouWantToHoldThisTask;

  String get lblCompleteTask;

  String get lblAreYouSureYouWantToCompleteThisTask;

  String get lblAreYouSureYouWantToStartThisTask;

  String get lblTime;

  String get lblDescription;

  String get lblClose;

  String get lblStartTask;

  String get lblReset;

  String get lblApply;

  String get lblAttendanceHistory;

  String get lblRange;

  String get lblInTime;

  String get lblOutTime;

  String get lblInvalidInput;

  String get lblAttach;

  String get lblCamera;

  String get lblPhoto;

  String get lblVideo;

  String get lblFile;

  String get lblFailedToLoadImage;

  String get lblLocation;

  String get lblShare;

  String get lblForward;

  String get lblPickALocation;

  String get lblSelectChatToForwardTo;

  String get lblMessageForwardedSuccessfully;

  String get lblAudio;

  String get lblCopy;

  String get lblNewChat;

  String get lblNewGroup;

  String get lblSearch;

  String get lblEmergencyNotificationWillBeSentIn;

  String get lblSOSAlert;

  String get lblSOS;

  String get lblAreYouSureYouWantToExit;

  String get lblExitApp;

  String get lblPhone;

  String get lblActivity;

  String get lblUnableToDownloadTheFile;

  String get lblLocationInfo;

  String get lblAttachFile;

  String get lblTakePhoto;

  String get lblProfile;

  String get lblViewImage;

  String get lblFailedToSendSOS;

  String get lblAdminIsNotified;

  String get lblProceed;

  String get lblYourDeviceIsRestrictedToUseThisAppPleaseContactAdmin;

  String get lblSelectOrganization;

  String get lblNoOrganizationFound;

  String get lblSelectAOrganization;

  String get lblPleaseSelectAOrganization;

  String get lblOrganizations;

  String get lblChooseYourOrganizationFromTheListBelow;

  String get lblNoImageAvailableForThisVisit;

  String get lblDesignation;

  String get lblUnableToGetUserInfo;

  String get lblPaused;

  String get lblPause;

  String get lblUnableToGetLocationPleaseEnableLocationServices;

  String get lblTaskPausedSuccessfully;

  String get lblAreYouSureYouWantToPauseThisTask;

  String get lblMap;

  String get lblCall;

  String
      get lblForAnyQueriesCustomizationsInstallationOrFeedbackPleaseContactUsAt;

  String get lblThisWillOnlyTakeAFewSeconds;

  String get lblSettingThingsUpPleaseWait;

  String get lblSettingUp;

  String get lblScanQRCode;

  String get lblModules;

  String get lblEnabled;

  String get lblDisabled;

  String get lblPlaceQRCodeInTheScanWindow;

  String get lblProgress;

  String get lblNoTargetsFound;

  String get lblIncentiveAmount;

  String get lblIncentivePercentage;

  String get lblIncentiveDetails;

  String get lblPleaseAllowAllPermissionsToContinue;

  String get lblCreate;

  String get lblAchieved;

  String get lblTarget;

  String
      get lblNotificationPermissionEnsuresYouReceiveUpdatesOnAttendanceTasksAndOtherImportantEventsInRealTime;

  String get lblEnableNotificationsToKeepYouUpdatedWithImportantUpdates;

  String
      get lblActivityPermissionIsUsedToDetectYourPhysicalMovementsAndTravelEnablingTheAppToTrackAttendanceVisitsAndActivityStates;

  String get lblAllowAccessToYourActivityForAttendanceAndTravelTracking;

  String
      get lblLocationPermissionIsRequiredForTrackingAttendanceRecordingClientVisitsAndCalculatingDistancesTraveledEvenWhenTheAppIsNotInUse;

  String get lblToEnsureProperFunctionalityTheFollowingPermissionsAreRequired;

  String
      get lblAllowAccessToYourLocationForAttendanceAndTravelTrackingEvenWhenTheAppIsClosed;

  String get lblNext;

  String get lblForDate;

  String get lblHolidays;

  String get lblAllow;

  String get lblPermissions;

  String get lblMoreDetails;

  String get lblOrder;

  String get lblNoPayslipsFound;

  String get lblAddOrder;

  String get lblNetPay;

  String get lblYear;

  String get lblMonth;

  String get lblPayslips;

  String get lblLeaveTaken;

  String get lblWorkingDays;

  String get lblDownloadPayslip;

  String get lblRemove;

  String get lblEarnings;

  String get lblDeductions;

  String get lblNoRecordsFound;

  String get lblAddedToCart;

  String get lblRemovedFromCart;

  String get lblSubCategories;

  String get lblNoNotificationsFound;

  String get lblScanFace;

  String get lblFailedToInitiateChat;

  String get lblFailedToCreateGroupChat;

  String get lblSalesTargets;

  String get lblPayslip;

  String get lblCreateGroup;

  String get lblNoUsersFound;

  String get lblErrorFetchingData;

  String get lblErrorSearchingUsers;

  String get lblEnterGroupName;

  String get lblPleaseEnterAGroupNameAndSelectUsers;

  String get lblSearchUsers;

  String get lblLoanRequestCancelledSuccessfully;

  String get lblLeaveRequestCancelledSuccessfully;

  String get lblPleaseSelectFromDateFirst;

  String get lblPleaseSelectToDate;

  String get lblPleaseSelectFromDate;

  String get lblTodaysClientVisits;

  String get lblSomethingWentWrong;

  String get lblPeriod;

  String get lblFullDate;

  String get lblScanQRCodeToMarkAttendance;

  String get lblFaceRecognitionIsEnabled;

  String get lblOpenAttendance;

  String get lblDynamicQRCodeIsEnabled;

  String get lblNoHolidaysFoundForThisYear;

  String get lblFilterByYear;

  String get lblNoDesignation;

  String get lblGroupMembers;

  String get lblGroupInfo;

  String get lblFailedToLoadParticipants;

  String get lblNoDescription;

  String get lblExpenseRequestCancelledSuccessfully;

  String get lblAreYouSureYouWantToCancelThisRequest;

  String get lblNoDocumentRequestsFound;

  String get lblDownloadingFilePleaseWait;

  String get lblSelectStatus;

  String get lblEmployeeCode;

  String get lblDigitalIDCard;

  String get lblUnableToRegisterDevice;

  String get lblDeviceSuccessfullyRegistered;

  String get lblNoClientsFoundFor;

  String get lblTypeToSearchClients;

  String get lblNoClientsFound;

  String get lblNoChatsFound;

  String get lblTypeAMessage;

  String get lblFailedToSendMessage;

  String get lblFailedToSendAttachment;

  String get lblYesterday;

  String get lblMessageCopied;

  String get lblSharedFrom;

  String get lblNoMessagesYet;

  String get lblNoChatsAvailableToForward;

  String get lblChooseClient;

  String get lblImageNotAvailable;

  String get lblViewLocationInMaps;

  String get lblDocument;

  String get lblViewDocument;

  String get lblDownloadDocument;

  String get lblAdmin;

  String get lblSharedComments;

  String get lblStartedTheTask;

  String get lblPausedTheTask;

  String get lblResumedTheTask;

  String get lblCompletedTheTask;

  String get lblSharedAnImage;

  String get lblSharedADocument;

  String get lblSharedALocation;

  String get lblShared;

  String get lblTaskUpdates;

  String get lblTaskUpdate;

  String get lblTaskIsCompleted;

  String get lblPleaseCheckInToShareLocationOrFile;

  String get lblPleaseCheckInToSharePhoto;

  String get lblPleaseEnterMessage;

  String get lblPleaseCheckInToSendMessage;

  String get lblOnlyPDFFilesAreAllowed;

  String get lblUnableToPickFile;

  String get lblUnableToGetCurrentLocation;

  String get lblUnableToTakePhoto;

  String get lblMessageCannotBeEmpty;

  String get lblImage;

  String get lblUnableToGetFile;

  String get lblPages;

  String get lblPleaseSelectAClientToPlaceOrder;

  String get lblOrderPlacedSuccessfully;

  String get lblCart;

  String get lblCartIsEmpty;

  String get lblPlacingOrderPleaseWait;

  String get lblOrderingFor;

  String get lblNotes;

  String get lblTotal;

  String get lblItems;

  String get lblPlaceOrder;

  String get lblPleaseCheckInFirst;

  String get lblAreYouSureYouWantToPlaceTheOrder;

  String get lblPasswordChangedSuccessfully;

  String get lblChangePassword;

  String get lblConfirmNewPassword;

  String get lblOldPassword;

  String get lblOldPasswordIsRequired;

  String get lblNewPasswordIsRequired;

  String get lblMinimumLengthIs;

  String get lblConfirmPasswordIsRequired;

  String get lblPasswordDoesNotMatch;

  String get lblTeamChat;

  String get lblChatModuleIsNotEnabled;

  String get lblInvalidFileTypePleaseSelectAPngOrJpgFile;

  String get lblFailedToUploadImage;

  String get lblUnableToCheckDeviceStatus;

  String get lblRequestADocument;

  String get lblNoDocumentTypesAdded;

  String get lblDocumentType;

  String get lblDocumentRequestSubmittedSuccessfully;

  String get lblPleaseSelectADocumentType;

  String get lblNoExpenseTypesAreConfigured;

  String get lblExpenseRequests;

  String get lblUnableToUploadTheFile;

  String get lblSuccessfullyDeleted;

  String get lblRequestedOn;

  String get lblUnableToSendAnOTPTryAgainLater;

  String get lblOtpIsRequired;

  String get lblWrongOTP;

  String get lblUnableToChangeThePassword;

  String get lblCannotBeBlank;

  String get lblPhoneNumberDoesNotExists;

  String get lblSelectClient;

  String get lblPleaseChooseClient;

  String get lblFormSubmittedSuccessfully;

  String get lblPleaseEnter;

  String get lblPleaseEnterValidEmail;

  String get lblPleaseEnterValidURL;

  String get lblPleaseEnterValidNumber;

  String get lblForms;

  String get lblNoFormsAssigned;

  String get lblFormId;

  String get lblSubmissions;

  String get lblTrackedTime;

  String get lblGettingYourIPAddress;

  String get lblGettingYourAddress;

  String get lblUnableToGetAddress;

  String get lblIsYourIPAddress;

  String get lblSite;

  String get lblAttendanceType;

  String get lblPleaseEnterYourLateReason;

  String get lblInvalid;

  String get lblBreakModuleIsNotEnabled;

  String get lblAreYouSureYouWantToTakeABreak;

  String get lblBreak;

  String get lblEarlyCheckOut;

  String get lblPleaseEnterYourEarlyCheckOutReason;

  String get lblEarlyCheckOutReason;

  String get lblAreYouSureYouWantToResume;

  String get lblLateReason;

  String get lblScanQRToCheckIn;

  String get lblClientVisits;

  String get lblTotalVisits;

  String get lblYouAreOnBreakPleaseEndYourBreakToMarkVisit;

  String get lblOrders;

  String get lblProcessing;

  String get lblSuccessfully;

  String get lblAppliedOn;

  String get lblDuration;

  String get lblNoLeaveTypesAreConfigured;

  String get lblLeaveRequests;

  String get lblType;

  String get lblApprovedBy;

  String get lblApprovedOn;

  String get lblRequestLoan;

  String get lblEnterAmount;

  String get lblAmountCannotBeEmpty;

  String get lblLoanRequestSubmittedSuccessfully;

  String get lblLoans;

  String get lblOneTapLogin;

  String get lblLooksLikeYouAlreadyRegisteredThisDeviceYouCanUseOneTapLogin;

  String get lblIfYouWantToLoginWithDifferentAccountPleaseContactAdministrator;

  String get lblPleaseLoginToContinue;

  String get lblInvalidEmployeeId;

  String get lblEmployeeIdDoesNotExists;

  String get lblNoticeBoardIsNotEnabled;

  String get lblNoNoticesFound;

  String get lblPostedOn;

  String get lblBackOnline;

  String get lblServerUnreachable;

  String get lblOfflineMode;

  String get lblYouAreInOfflineMode;

  String
      get lblOptionsWillBeLimitedUntilYouAreBackOnlinePleaseCheckYourInternetConnection;

  String get lblOrderId;

  String get lblOrderDate;

  String get lblTotalItems;

  String get lblViewDetails;

  String get lblOrderDetails;

  String get lblProducts;

  String get lblProduct;

  String get lblQuantity;

  String get lblPrice;

  String get lblSlNo;

  String get lblOrderHistory;

  String get lblFilterByDate;

  String get lblFilter;

  String get lblNoOrdersFound;

  String get lblCancelled;

  String get lblTodayOrders;

  String get lblViewAll;

  String get lblNoOrders;

  String get lblChooseProductCategory;

  String get lblNoData;

  String get lblId;

  String get lblChooseProducts;

  String get lblCode;

  String get lblAddToCart;

  String get lblCollectPayment;

  String get lblSelectPaymentMode;

  String get lblSuccessfullyCreated;

  String get lblPaymentCollections;

  String get lblActivityPermission;

  String get lblWhyActivityPermissionIsRequired;

  String get lblContinue;

  String get lblOpenSettings;

  String get lblGrantPermission;

  String get lblLocationPermission;

  String get lblWhyLocationPermissionIsRequired;

  String get lblModulesStatus;

  String get lblChangeTheme;

  String get lblColorChangedSuccessfully;

  String get lblRecent;

  String get lblNoVisitsAdded;

  String get lblTodayVisits;

  String get lblToMarkVisitsPleaseAddClient;

  String get lblAddClient;

  String get lblUnableToGetModuleStatus;

  String get lblExpenseModuleIsNotEnabled;

  String get lblLoanModuleIsNotEnabled;

  String get lblLoanRequests;

  String get lblLeaveModuleIsNotEnabled;

  String get lblDocumentModuleIsNotEnabled;

  String get lblDocumentRequests;

  String get lblPaymentCollectionModuleIsNotEnabled;

  String get lblPaymentCollection;

  String get lblVisitModuleIsNotEnabled;

  String get lblWeAreUnableToConnectToTheServerPleaseTryAgainLater;

  String get lblRetry; /*

  String get lblBuyThisAppNow;*/

  String get lblYouAreLateYourShiftStartsAt;

  String get lblYourShiftStartsAt;

  String get lblYouAreOnBreak;

  String get lblYouCheckedInAt;

  String get lblYouCheckedOutAt;

  String get lblGoodAfternoon;

  String get lblGoodEvening;

  String get lblScanQRToCheckOut;

  String get lblPleaseSetupYourFingerprint;

  String get lblApprovals;

  String get lblFilters;

  String get lblConnectingFacilitiesWithServiceProviders;
}
