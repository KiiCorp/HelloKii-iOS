//
//  KiiSDK.h
//  KiiSDK
//
//  Created by syahRiza on 6/28/16.
//  Copyright © 2016 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for KiiSDK.
FOUNDATION_EXPORT double KiiSDKVersionNumber;

//! Project version string for KiiSDK.
FOUNDATION_EXPORT const unsigned char KiiSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <KiiSDK/PublicHeader.h>


#import <KiiSDK/Kii.h>
#import <KiiSDK/KiiBucket.h>
#import <KiiSDK/KiiError.h>
#import <KiiSDK/KiiObject.h>
#import <KiiSDK/KiiUser.h>
#import <KiiSDK/KiiGroup.h>
#import <KiiSDK/KiiClause.h>
#import <KiiSDK/KiiQuery.h>
#import <KiiSDK/KiiAnyAuthenticatedUser.h>
#import <KiiSDK/KiiAnonymousUser.h>
#import <KiiSDK/KiiACL.h>
#import <KiiSDK/KiiACLEntry.h>
#import <KiiSDK/KiiSocialConnect.h>
#import <KiiSDK/KiiPushInstallation.h>
#import <KiiSDK/KiiTopic.h>
#import <KiiSDK/KiiPushMessage.h>
#import <KiiSDK/KiiAPNSFields.h>
#import <KiiSDK/KiiGCMFields.h>
#import <KiiSDK/KiiRTransfer.h>
#import <KiiSDK/KiiUploader.h>
#import <KiiSDK/KiiRTransferManager.h>
#import <KiiSDK/KiiResumableTransfer.h>
#import <KiiSDK/KiiRTransferInfo.h>
#import <KiiSDK/KiiDownloader.h>
#import <KiiSDK/KiiBaseBucket.h>
#import <KiiSDK/KiiServerCodeEntry.h>
#import <KiiSDK/KiiServerCodeEntryArgument.h>
#import <KiiSDK/KiiServerCodeExecResult.h>
#import <KiiSDK/KiiExperiment.h>
#import <KiiSDK/KiiVariation.h>
#import <KiiSDK/KiiVariationSampler.h>
#import <KiiSDK/KiiVariationSamplerByKiiUser.h>
#import <KiiSDK/KiiRandomVariationSampler.h>
#import <KiiSDK/KiiConversionEvent.h>
#import <KiiSDK/KiiIllegalStateException.h>
#import <KiiSDK/KiiGeoPoint.h>
#import <KiiSDK/KiiPushSubscription.h>
#import <KiiSDK/FileHolder.h>
#import <KiiSDK/KiiCloudPhotoColle.h>
#import <KiiSDK/KiiPhotoColleRTransferManager.h>
#import <KiiSDK/KiiPhotoColleSocialConnect.h>
#import <KiiSDK/KiiUserFields.h>
#import <KiiSDK/KiiIdentityData.h>
#import <KiiSDK/KiiIdentityDataBuilder.h>
#import <KiiSDK/KiiSocialAccountInfo.h>
#import <KiiSDK/KiiThing.h>
#import <KiiSDK/KiiThingOwner.h>
#import <KiiSDK/KiiThingFields.h>
#import <KiiSDK/KiiBaseObject.h>
#import <KiiSDK/KiiMQTTFields.h>
#import <KiiSDK/KiiEncryptedBucket.h>
#import <KiiSDK/KiiListResult.h>
#import <KiiSDK/KiiAnalytics.h>
#import <KiiSDK/KiiUserBuilder.h>
#import <KiiSDK/LocaleContainer.h>
#import <KiiSDK/KAConstants.h>
#import <KiiSDK/KiiCallback.h>