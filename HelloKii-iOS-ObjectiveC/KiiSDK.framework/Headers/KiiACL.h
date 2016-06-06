//
//  KiiACL.h
//  KiiSDK-Private
//
//  Created by Chris Beauchamp on 5/14/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KiiACLEntry, KiiACL;

typedef void (^KiiACLArrayBlock)(KiiACL * _Nonnull acl, NSArray *_Nullable aclList, NSError *_Nullable error);
typedef void (^KiiACLSaveBlock)(KiiACL * _Nonnull acl, NSArray *_Nullable succeeded, NSArray * _Nullable failed, NSError * _Nullable error);

/** A reference to the ACL of a <KiiObject>
 
 A single KiiACL object can contain multiple <KiiACLEntry> objects, which grant/prevent access of the associated object to users and groups.
 */
@interface KiiACL : NSObject
NS_ASSUME_NONNULL_BEGIN
/** Asynchronously gets the list of active ACLs associated with this object from the server
 
 This is a non-blocking method
 
     [a listACLEntriesWithBlock:^(KiiACL *acl, NSArray *aclList, NSError *error) {
         if(error == nil) {
             NSLog(@"Got acl entries: %@", aclList);
         }
     }];
 
 @param block The block to be called upon method completion. See example
*/
- (void) listACLEntriesWithBlock:(KiiACLArrayBlock)block;

/** Get the list of active ACLs associated with this object from the server
 
 This is a blocking method
 @param error used to return an error by reference (pass NULL if this is not desired). It is recommended to set an actual error object to get the error information.
 @return An array of <KiiACLEntry> objects
 */
- (nullable NSArray* ) listACLEntriesSynchronous:(NSError*_Nullable*_Nullable)error;


/** Asynchronously gets the list of active ACLs associated with this object from the server

 This is a non-blocking method
 @param delegate The object to make any callback requests to
 @param callback The callback method to be called when the request is completed. The callback method should have a signature similar to:
 
     - (void) listRetrieved:(KiiACL*)forACL withResults:(NSArray*)aclList andError:(NSError*)error {
         
         // the request was successful
         if(error == nil) {
             // do something with the list
         }
         
         else {
             // there was a problem
         }
     }
 
 */
- (void) listACLEntries:(id)delegate withCallback:(SEL)callback; 


/** Add a <KiiACLEntry> to the local object, if not already present
 
 @param entry The <KiiACLEntry> to add
 @return TRUE if the entry was added, FALSE otherwise
 */
- (BOOL) putACLEntry:(nullable KiiACLEntry*)entry;


/** Remove a <KiiACLEntry> from the local object
 
 @param entry The <KiiACLEntry> to remove
 @return TRUE if the entry was removed, FALSE otherwise
 */
- (BOOL) removeACLEntry:(nullable KiiACLEntry*)entry;


/** Asynchronously saves the list of ACLEntry objects associated with this ACL object to the server.
 
 This is a non-blocking method
 
     [a listACLEntriesWithBlock:^(KiiACL *acl, NSArray *succeeded, NSArray *failed, NSError *error) {
         if(error == nil) {
             NSLog(@"ACL entries that were successfully saved: %@", succeeded);
             NSLog(@"ACL entries that were NOT saved: %@", failed);
         }
     }];
 
 @param block The block to be called upon method completion. See example
 @note Subscribe or send message to topic is not supported for <KiiAnonymousUser>.
 Saving <KiiACLEntry> created with <KiiAnonymousUser> and
 KiiACLTopicActionSubscribe or KiiACLTopicActionSend will be failed with error code 514.
*/
- (void) saveWithBlock:(KiiACLSaveBlock)block;


/** Save the list of ACLEntry objects associated with this ACL object to the server
 
 This is a blocking method
 
 @param succeeded An NSArray object of <KiiACLEntry> objects that were successfully updated
 @param failed An NSArray object of <KiiACLEntry> objects that failed to update.
 @param error used to return an error by reference (pass NULL if this is not desired). It is recommended to set an actual error object to get the error information. If this error shows partial success, one or more of the ACL entries was unsuccessfully saved - check the succeeded/failed parameters.
 @return YES if succeeded, NO otherwise.
 @note Subscribe or send message to topic is not supported for <KiiAnonymousUser>.
 Saving <KiiACLEntry> created with <KiiAnonymousUser> and
 KiiACLTopicActionSubscribe or KiiACLTopicActionSend will be failed with error code 514.
 */
- (BOOL) saveSynchronous:(NSArray*_Nullable*_Nullable)succeeded
                 didFail:(NSArray*_Nullable*_Nullable)failed
                        error:(NSError*_Nullable*_Nullable)error;

/** Deprecated. Use saveSynchronous:didFail:error: */
- (BOOL) saveSynchronous:(NSError*_Nullable*_Nullable)error
              didSucceed:(NSArray*_Nullable*_Nullable)succeeded
                 didFail:(NSArray*_Nullable*_Nullable)failed __attribute__((deprecated("Use saveSynchronous:didFail:error:")));

/** Asynchronously saves the list of ACLEntry objects associated with this ACL object to the server
 
 This is a non-blocking method
 @param delegate The object to make any callback requests to
 @param callback The callback method to be called when the request is completed. The callback method should have a signature similar to:
 
     - (void) aclSaved:(KiiACL*)acl withError:(NSError*)error andSuccessfulEntries:(NSArray*)successful andFailedEntries:(NSArray*)failed {
     
         // the request was successful
         if(error == nil) {
             // do something with the list
         }
         
         else {
             // there was a problem
         }
     }
 
 @note Subscribe or send message to topic is not supported for <KiiAnonymousUser>.
 Saving <KiiACLEntry> created with <KiiAnonymousUser> and
 KiiACLTopicActionSubscribe or KiiACLTopicActionSend will be failed with error code 514.
 
 */
- (void) save:(id)delegate withCallback:(SEL)callback;

@end
NS_ASSUME_NONNULL_END