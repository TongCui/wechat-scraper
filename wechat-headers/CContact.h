@interface CContact : CBaseContact <PBCoding, NSCoding>
{
    unsigned int m_uiChatRoomStatus;
    NSString *m_nsChatRoomMemList;
    unsigned int m_uiChatRoomAccessType;
    unsigned int m_uiChatRoomMaxCount;
    unsigned int m_uiChatRoomVersion;
    ChatRoomDetail *m_ChatRoomDetail;
    NSString *m_nsChatRoomData;
    ChatRoomData *m_ChatRoomData;
    NSString *m_nsCountry;
    NSString *m_nsProvince;
    NSString *m_nsCity;
    NSString *m_nsSignature;
    unsigned int m_uiCertificationFlag;
    NSString *m_nsCertificationInfo;
    NSString *m_nsOwner;
    NSString *m_nsFBNickName;
    NSString *m_nsFBID;
    unsigned int m_uiNeedUpdate;
    NSString *m_nsWCBGImgObjectID;
    int m_iWCFlag;
    NSString *m_pcWCBGImgID;
    NSString *m_nsExternalInfo;
    NSString *m_nsBrandSubscriptConfigUrl;
    unsigned int m_uiBrandSubscriptionSettings;
    SubscriptBrandInfo *m_subBrandInfo;
    NSString *m_nsBrandIconUrl;
    _Bool m_isExtInfoValid;
    NSDictionary *externalInfoJSONCache;
    _Bool m_isShowRedDot;
    NSString *m_nsMobileHash;
    NSString *m_nsMobileFullHash;
    NSString *m_nsLinkedInID;
    NSString *m_nsLinkedInName;
    NSString *m_nsLinkedInPublicUrl;
    unsigned int m_uiDeleteFlag;
    NSString *m_nsDescription;
    NSString *m_nsCardUrl;
    NSString *m_nsWorkID;
    NSString *m_nsLabelIDList;
    NSArray *m_arrPhoneItem;
    NSRecursiveLock *m_lockForChatRoomData;
    CAppBrandInfo *appBrandInfo;
    _Bool _m_bFromNewDB;
    unsigned int _m_uiLastUpdate;
    unsigned int _m_uiMetaFlag;
    unsigned int _m_uiDebugModeType;
    unsigned int _m_uiWxAppOpt;
    unsigned int _uiLastUpdateAppVersionInfoTime;
    NSString *m_nsWeiDianInfo;
    NSDictionary *_m_dicWeiDianInfo;
    CAppBrandInfo *_appBrandInfo;
}

+ (_Bool)isHeadImgUpdated:(id)arg1 Local:(id)arg2;
+ (void)HandleChatMemUsrImg:(struct tagMMModChatRoomMember *)arg1 Contatct:(id)arg2 DocPath:(id)arg3;
+ (void)HandleUsrImgPB:(id)arg1 Contatct:(id)arg2 DocPath:(id)arg3;
+ (void)HandleUsrImg:(struct tagMMModContact *)arg1 Contatct:(id)arg2 DocPath:(id)arg3;
+ (id)genChatRoomName:(id)arg1 appendTail:(_Bool)arg2;
+ (id)genChatRoomName:(id)arg1;
+ (id)getChatRoomMemberWithoutMyself:(id)arg1;
+ (id)getChatRoomMember:(id)arg1;
+ (id)getChatRoomMemberUserName:(id)arg1;
+ (unsigned long long)getChatRoomMemberCount:(id)arg1;
+ (id)getMicroBlogUsrDisplayName:(id)arg1;
+ (id)parseContactKey:(id)arg1;
+ (id)SubscriptedBrandsFromString:(id)arg1;
+ (void)initialize;
+ (_Bool)isWeAppUserName:(id)arg1;
@property(retain, nonatomic) CAppBrandInfo *appBrandInfo; // @synthesize appBrandInfo=_appBrandInfo;
@property(nonatomic) unsigned int uiLastUpdateAppVersionInfoTime; // @synthesize uiLastUpdateAppVersionInfoTime=_uiLastUpdateAppVersionInfoTime;
@property(nonatomic) unsigned int m_uiWxAppOpt; // @synthesize m_uiWxAppOpt=_m_uiWxAppOpt;
@property(nonatomic) unsigned int m_uiDebugModeType; // @synthesize m_uiDebugModeType=_m_uiDebugModeType;
@property(nonatomic) unsigned int m_uiMetaFlag; // @synthesize m_uiMetaFlag=_m_uiMetaFlag;
@property(nonatomic) unsigned int m_uiLastUpdate; // @synthesize m_uiLastUpdate=_m_uiLastUpdate;
@property(nonatomic) _Bool m_bFromNewDB; // @synthesize m_bFromNewDB=_m_bFromNewDB;
@property(retain, nonatomic) NSString *m_nsWorkID; // @synthesize m_nsWorkID;
- (void)setExternalInfoJSONCache:(id)arg1;
- (id)externalInfoJSONCache;
@property(retain, nonatomic) NSString *m_nsWeiDianInfo; // @synthesize m_nsWeiDianInfo;
@property(retain, nonatomic) ChatRoomDetail *m_ChatRoomDetail; // @synthesize m_ChatRoomDetail;
@property(retain, nonatomic) NSArray *m_arrPhoneItem; // @synthesize m_arrPhoneItem;
@property(retain, nonatomic) NSString *m_nsLabelIDList; // @synthesize m_nsLabelIDList;
@property(retain, nonatomic) NSString *m_nsCardUrl; // @synthesize m_nsCardUrl;
@property(retain, nonatomic) NSString *m_nsDescription; // @synthesize m_nsDescription;
@property(nonatomic) unsigned int m_uiDeleteFlag; // @synthesize m_uiDeleteFlag;
@property(nonatomic) unsigned int m_uiChatRoomVersion; // @synthesize m_uiChatRoomVersion;
@property(nonatomic) unsigned int m_uiChatRoomMaxCount; // @synthesize m_uiChatRoomMaxCount;
@property(retain, nonatomic) NSString *m_nsLinkedInPublicUrl; // @synthesize m_nsLinkedInPublicUrl;
@property(retain, nonatomic) NSString *m_nsLinkedInName; // @synthesize m_nsLinkedInName;
@property(retain, nonatomic) NSString *m_nsLinkedInID; // @synthesize m_nsLinkedInID;
@property(retain, nonatomic) NSString *m_nsMobileFullHash; // @synthesize m_nsMobileFullHash;
@property(retain, nonatomic) NSString *m_nsMobileHash; // @synthesize m_nsMobileHash;
@property(nonatomic) _Bool m_isShowRedDot; // @synthesize m_isShowRedDot;
@property(nonatomic) unsigned int m_uiChatRoomAccessType; // @synthesize m_uiChatRoomAccessType;
@property(nonatomic) _Bool m_isExtInfoValid; // @synthesize m_isExtInfoValid;
@property(retain, nonatomic) NSString *m_nsBrandIconUrl; // @synthesize m_nsBrandIconUrl;
@property(retain, nonatomic) SubscriptBrandInfo *m_subBrandInfo; // @synthesize m_subBrandInfo;
@property(nonatomic) unsigned int m_uiBrandSubscriptionSettings; // @synthesize m_uiBrandSubscriptionSettings;
@property(retain, nonatomic) NSString *m_nsBrandSubscriptConfigUrl; // @synthesize m_nsBrandSubscriptConfigUrl;
@property(retain, nonatomic) NSString *m_nsExternalInfo; // @synthesize m_nsExternalInfo;
@property(retain, nonatomic) NSString *m_pcWCBGImgID; // @synthesize m_pcWCBGImgID;
@property(nonatomic) int m_iWCFlag; // @synthesize m_iWCFlag;
@property(retain, nonatomic) NSString *m_nsWCBGImgObjectID; // @synthesize m_nsWCBGImgObjectID;
@property(nonatomic) unsigned int m_uiNeedUpdate; // @synthesize m_uiNeedUpdate;
@property(retain, nonatomic) NSString *m_nsFBID; // @synthesize m_nsFBID;
@property(retain, nonatomic) NSString *m_nsFBNickName; // @synthesize m_nsFBNickName;
@property(retain, nonatomic) NSString *m_nsOwner; // @synthesize m_nsOwner;
@property(retain, nonatomic) NSString *m_nsCertificationInfo; // @synthesize m_nsCertificationInfo;
@property(nonatomic) unsigned int m_uiCertificationFlag; // @synthesize m_uiCertificationFlag;
@property(retain, nonatomic) NSString *m_nsSignature; // @synthesize m_nsSignature;
@property(retain, nonatomic) NSString *m_nsCity; // @synthesize m_nsCity;
@property(retain, nonatomic) NSString *m_nsProvince; // @synthesize m_nsProvince;
@property(retain, nonatomic) NSString *m_nsCountry; // @synthesize m_nsCountry;
@property(nonatomic) unsigned int m_uiChatRoomStatus; // @synthesize m_uiChatRoomStatus;
@property(retain, nonatomic) NSString *m_nsChatRoomMemList; // @synthesize m_nsChatRoomMemList;
- (void).cxx_destruct;
- (_Bool)IsUserInChatRoom:(id)arg1;
- (id)getLabelIDList;
- (_Bool)isAccountDeleted;
@property(readonly, nonatomic) NSDictionary *m_dicWeiDianInfo; // @synthesize m_dicWeiDianInfo=_m_dicWeiDianInfo;
- (_Bool)isHasWeiDian;
- (_Bool)isShowLinkedIn;
- (_Bool)needShowUnreadCountOnSession;
- (void)setChatStatusNotifyOpen:(_Bool)arg1;
- (_Bool)isChatStatusNotifyOpen;
- (_Bool)isContactFrozen;
- (_Bool)isContactSessionTop;
- (_Bool)isChatroomNeedAccessVerify;
- (_Bool)isShowChatRoomDisplayName;
- (_Bool)isAdmin;
- (id)xmlForMessageWrapContent;
- (id)getChatRoomMembrGroupNickName:(id)arg1;
- (id)getChatRoomMemberNickName:(id)arg1;
- (id)getChatRoomMemberDisplayName:(id)arg1;
- (id)getNormalContactDisplayDesc;
- (long long)compareForFavourGroup:(id)arg1;
- (_Bool)isLocalizedContact;
- (_Bool)isHolderContact;
- (_Bool)isVerified;
- (_Bool)isIgnoreBrandContat;
- (_Bool)isVerifiedBrandContact;
- (_Bool)isBrandContact;
- (_Bool)IsAddFromShake;
- (_Bool)IsAddFromLbs;
- (_Bool)isMyContact;
- (void)tryLoadExtInfo;
@property(readonly, copy) NSString *description;
- (_Bool)copyPatialFieldFromContact:(id)arg1;
- (_Bool)copyFieldFromContact:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithModContact:(id)arg1;
- (id)initWithShareCardMsgWrapContent:(id)arg1;
- (id)initWithShareCardMsgWrap:(id)arg1;
- (void)genContactFromShareCardMsgWrapContent:(id)arg1;
- (_Bool)genContactFromShareCardMsgWrap:(id)arg1;
- (id)init;
- (_Bool)isHasMobile;
- (id)getMobileList;
- (_Bool)hasMatchHashPhone;
- (id)getMobileNumString;
- (id)getMobileDisplayName;
- (_Bool)isContactTypeShouldDelete;
- (id)getNewChatroomData;
@property(retain, nonatomic) ChatRoomData *m_ChatRoomData; // @synthesize m_ChatRoomData;
@property(retain, nonatomic) NSString *m_nsChatRoomData; // @synthesize m_nsChatRoomData;
- (void)setSignatureWithoutEmojiChange:(id)arg1;
- (void)setChatRoomDataWithoutEmojiChange:(id)arg1;
- (const map_490096f0 *)getValueTagIndexMap;
- (id)getValueTypeTable;
- (_Bool)isBlockWeAppTemplateMessage;
- (_Bool)isBlockWeAppSessionMessage;
- (_Bool)isWeAppContact;
- (_Bool)isWeChatPluginWeApp;
- (id)getAppID;
- (id)getAppBrandInfo;
- (_Bool)isAppBrandInfoValid;
- (id)getBrandProfileBindWeAppList;
- (long long)getWeAppBizWxaOpenFlag;
- (id)getMainPageUrl;
- (_Bool)isOpenMainPage;
- (unsigned int)getFunctionFlag;
- (id)getSupportEmoticonLinkPrefix;
- (id)getConferenceVerifyButtonTitle;
- (id)getConferenceVerifyPromptTitle;
- (unsigned int)getConferenceContactExpireTime;
- (id)getBrandBusinessScope;
- (id)getBrandMerchantSecurityUrl;
- (id)getBrandMerchantSecurity;
- (id)getBrandEvaluateCount;
- (id)getBrandMerchantRatings;
- (id)brandUrls;
- (id)brandPrivileges;
- (id)getBrandRegisterSourceIntroUrl;
- (id)getBrandRegisterSourceBody;
- (_Bool)getIsTrademarkProtection;
- (id)getBrandVerifySubTitle;
- (id)getBrandVerifySourceIntroUrl;
- (id)getBrandVerifySourceDescription;
- (id)getBrandVerifySourceName;
- (unsigned int)getBrandVerifySourceType;
- (id)getBrandTrademarkName;
- (id)getBrandTrademarkUrl;
- (id)getCustomizeMenu;
- (id)bizMenuInfoFromContact;
- (long long)getInteractiveMode;
- (_Bool)isShowToolBarInMsg;
- (_Bool)isShowHeadImgInMsg;
- (long long)getScanQRCodeType;
- (long long)getReportLocationType;
- (long long)getAudioPlayType;
- (_Bool)isContactCanReceiveSpeexVoice;
- (_Bool)containKFWorkerInfo;
- (id)getSpecifyWorkerOpenID;
- (long long)getConnectorMsgType;
- (_Bool)canSupportMessageNotify;
- (_Bool)isHardDeviceHideSubtitle;
- (_Bool)isInternalMyDeviceBrand;
- (_Bool)isInternalSportBrand;
- (id)getNearFieldDesc;
- (_Bool)isSupportPublicWifi;
- (_Bool)isHardDeviceTestBrand;
- (_Bool)isHardDeviceBrand;
- (_Bool)isEnterpriseDisableBrand;
- (_Bool)isEnterpriseWebSubBrand;
- (_Bool)isEnterpriseChatSubBrand;
- (_Bool)isEnterpriseSubBrand;
- (id)getEnterpriseSubBrandChatExtUrl;
- (id)getEnterpriseSubBrandUrl;
- (unsigned int)getEnterpriseSubBrandChildType;
- (_Bool)isEnterpriseBrand;
- (_Bool)isEnterpriseMainBrand;
- (id)getEnterpriseBrandFrozenWording;
- (id)getEnterpriseMainBrandUserName;
- (int)getBrandContactType;
- (id)getExternalInfoDictionary;
- (void)updateWithBizAttrChanged:(id)arg1;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end