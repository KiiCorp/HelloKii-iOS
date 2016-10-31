//
//  KiiRTransfer.h
//  KiiSDK-Private
//
//  Created by Syah Riza on 3/26/13.
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KiiRTransferInfo.h"
#import "FileHolder.h"

@protocol KiiRTransfer;


typedef void(^KiiRTransferBlock)(id<KiiRTransfer> _Nonnull transferObject, NSError *_Nullable error);

/** Protocol to encapsulate Resumable transfer process. Resumable transfer process consist of Download and Upload.
 */
@protocol KiiRTransfer <NSObject>

/** @name Resumable transfer process */

/** Synchronously get transfer process information. This is blocking method.
 @return KiiRTransferInfo an object contains information regarding transfer process.
 */
-(nonnull KiiRTransferInfo*) info;

/** Synchronously proceed transfer process. This is blocking method.
 KiiRTransferBlock is a block defined as: typedef void(^KiiRTransferBlock)(id<KiiRTransfer> transferObject, NSError *error);

    NSError *error = nil;
    [aTransfer transferWithProgressBlock:^(id <KiiRTransfer> transferObject, NSError *error) {
        if (nil == error) {
            KiiRTransferInfo *info = [transferObject info];
            NSLog(@"%d", [info completedSizeInBytes]);
        }
    } andError:&error];

    if (error == nil) {
        NSLog(@"Transfer is completed.");
    }

 @param KiiRTransferBlock progress block, can be nil.
 @param error used to return an error by reference (pass NULL if this is not desired). It is recommended to set an actual error object to get the error information.
 @return YES if succeeded, NO otherwise.
 @warning This API access to server. Should not be executed in UI/Main thread.
 */
-(BOOL) transferWithProgressBlock:(nullable KiiRTransferBlock) progress andError:(NSError*_Nullable*_Nullable) error;

/** Asynchronously proceed transfer process using block.
 This is non-blocking method.
 KiiRTransferBlock is a block defined as: typedef void(^KiiRTransferBlock)(id<KiiRTransfer> transferObject, NSError *error);

    [aTransfer transferWithProgressBlock:^(id <KiiRTransfer> transferObject, NSError *error) {
        if (nil == error) {
            KiiRTransferInfo *info = [transferObject info];
            NSLog(@"%d", [info completedSizeInBytes]);
        }
    } andCompletionBlock:^(id <KiiRTransfer> transferObject, NSError *error) {
        if (nil == error) {
            NSLog(@"Transfer is completed");
        }
    }];

 @param KiiRTransferBlock progress block. This can be nil.
 @param KiiRTransferBlock completion block to handle after process completed. This can be nil.
 */
-(void) transferWithProgressBlock:(nullable KiiRTransferBlock) progress andCompletionBlock:(nullable KiiRTransferBlock) completion;


/** Suspend transfer process.
 Does not blocks until the completion of suspend.
 Completion of suspend is notified in completion block. If the transfer is on the way of sending a chunk, that chunk will be transferred and progress block is called before suspend notified.
 @param error used to return an error by reference (pass NULL if this is not desired). It is recommended to set an actual error object to get the error information.
 @return YES if succeeded, NO otherwise.
 */
-(BOOL) suspend:(NSError*_Nullable*_Nullable) error;


/** Synchronously terminate transfer process.
 This is blocking method.
 @param error used to return an error by reference (pass NULL if this is not desired). It is recommended to set an actual error object to get the error information.
 @return YES if succeeded, NO otherwise.
 */
-(BOOL) terminate:(NSError*_Nullable*_Nullable) error;

/** Get the File Holder instance which this transfer is bounded.
 @return fileHolder a KiiObject instance which this transfer is bounded.
 */
-(nullable id <FileHolder>) fileHolder;
@end
