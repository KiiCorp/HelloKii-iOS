//
//  ThingFields.h
//  KiiSDK-Private
//
//  Created by Syah Riza on 12/16/14.
//  Copyright (c) 2014 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KiiBaseObject.h"

/**Represent fields of thing on KiiCloud.
 */
@interface KiiThingFields : KiiBaseObject

/**Set and get firmwareVersion.
 */
@property(nonatomic, strong, nullable) NSString* firmwareVersion;

/**Set and get productName.
 */
@property(nonatomic, strong, nullable) NSString* productName;

/**Set and get the lot.
 */
@property(nonatomic, strong, nullable) NSString* lot;

/**Set and get the stringField1.
 */
@property(nonatomic, strong, nullable) NSString* stringField1;

/**Set and get the stringField2.
 */
@property(nonatomic, strong, nullable) NSString* stringField2;

/**Set and get the stringField3.
 */
@property(nonatomic, strong, nullable) NSString* stringField3;

/**Set and get the stringField4.
 */
@property(nonatomic, strong, nullable) NSString* stringField4;

/**Set and get the stringField5.
 */
@property(nonatomic, strong, nullable) NSString* stringField5;

/**Set and get the numberField1.
 */
@property(nonatomic, strong, nullable) NSNumber* numberField1;

/**Set and get the numberField2.
 */
@property(nonatomic, strong, nullable) NSNumber* numberField2;

/**Set and get the numberField3.
 */
@property(nonatomic, strong, nullable) NSNumber* numberField3;

/**Set and get the numberField4.
 */
@property(nonatomic, strong, nullable) NSNumber* numberField4;

/**Set and get the numberField5.
 */
@property(nonatomic, strong, nullable) NSNumber* numberField5;

/**Set and get vendor.
 */
@property(nonatomic, strong, nullable) NSString* vendor;


@end
