//
//  KiiListResult.h
//  KiiSDK-Private
//
//  Created by Syah Riza on 5/21/15.
//  Copyright (c) 2015 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KiiListResult;
/**Block type for returning generic NSObject from the server, currently <KiiTopic> is supported.
 */
typedef void (^KiiListResultBlock)(KiiListResult *_Nullable objects, id _Nullable  callerObject, NSError *_Nullable error);
/** Class for holding data from the cloud.
 */
@interface KiiListResult : NSObject

/**Array of object obtained from the server. Currently, it can be used to obtain <KiiTopic> instances of subscribable topic in particular scope. It returns empty array if there is no result.
 */
@property (nonatomic,readonly,nonnull) NSArray* results;

/**Pagination key for result list. If hasNext value is NO, then paginationKey will always nil.
 */
@property (nonatomic,readonly,nullable) NSString* paginationKey;

/**Indication whether results has next colection. It returns YES if has next collection, NO otherwise.
 */
@property (nonatomic,readonly) BOOL hasNext;

@end
