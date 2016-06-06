//
//  KiiDownloadTransferManaging.h
//  KiiSDK-Private
//
//  Copyright (c) 2014 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A protocol to manage status of resumable download.
 */
@protocol KiiDownloadTransferManaging <NSObject>


/**
 Download entries are stored with identifier of KiiUser who execute the download.
 This API get existing download entries initiated by current logged in user.
 If no user logged in, lists download entries initiated by anonymous user.
 This is blocking method.<br>

 <b>Entry Life cycle:</b> The entry will be created
 on calling <[KiiRTransfer transferWithProgressBlock:andError:]> and deleted
 on completion/termination of download.

 @param error used to return an error by reference (pass NULL if this is not desired). It is recommended to set an actual error object to get the error information.
 @return NSArray download entries array.
 */
-(nullable NSArray*) getDownloadEntries:(NSError *_Nullable*_Nullable) error;

@end
