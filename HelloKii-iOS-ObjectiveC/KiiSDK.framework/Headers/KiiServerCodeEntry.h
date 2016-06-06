//
//  KiiServerCodeEntry.h
//  KiiSDK-Private
//
//  Created by Riza Alaudin Syah on 6/25/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>


@class KiiServerCodeExecResult,KiiServerCodeEntryArgument,KiiServerCodeEntry;
typedef void(^KiiServerCodeExecBlock) (KiiServerCodeEntry* _Nonnull entry,
                                       KiiServerCodeEntryArgument* _Nullable argument,
                                       KiiServerCodeExecResult* _Nullable result,
                                       NSError* _Nullable error);

/** Class that represents a server side code entry in KiiCloud.
 */
@interface KiiServerCodeEntry : NSObject

/** Synchronously execute this server code entry.
 This is blocking method.
 @param argument  passed to the entry of script in the server.
 @param error used to return an error by reference (pass NULL if this is not desired). It is recommended to set an actual error object to get the error information.
 @return Result of execution includes NSData returned from specified server code entry in KiiCloud.
 */
-(nullable KiiServerCodeExecResult*) executeSynchronous:(nullable KiiServerCodeEntryArgument*) argument withError:(NSError*_Nullable*_Nullable) error;

/** Asynchronously execute this server code entry using block.This is non-blocking method.
    [kiiCloudEntry execute:argument 
                withBlock :^(KiiServerCodeEntry* entry,KiiServerCodeEntryArgument* argument, KiiCloudClodeExecResult* result, NSError* error){
                if(error==nil){
                    NSLog(@"Code is executed successfully");
                }
    }];
 
 @param argument  passed to the entry of script in the cloud.
 @param block The block to be called upon method completion. See example.
 */
-(void) execute:(nullable KiiServerCodeEntryArgument*) argument withBlock:(nullable KiiServerCodeExecBlock) block;

/** Get the entryName of this server code entry
 @return name of this server code entry.
 */
-(nonnull NSString*) entryName;




@end
