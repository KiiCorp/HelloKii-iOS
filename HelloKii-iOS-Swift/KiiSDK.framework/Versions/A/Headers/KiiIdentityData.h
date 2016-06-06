//
//  KiiIdentifyData.h
//  KiiSDK-Private
//
//  Copyright (c) 2014 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
/** Identity data. */
@interface KiiIdentityData : NSObject

/** user name of the user. */
@property (strong, readonly, nullable) NSString *userName;
/** email of the user. */
@property (strong, readonly, nullable) NSString *email;
/** phone number of the user. */
@property (strong, readonly, nullable) NSString *phoneNumber;

@end
