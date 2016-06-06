//
//  KiiBucket.h
//  KiiSDK-Private
//
//  Created by Chris Beauchamp on 5/12/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KiiPushSubscription.h"
#import "KiiBaseBucket.h"

@class KiiObject, KiiQuery, KiiUser, KiiBucket, KiiGroup, KiiACL, KiiRTransferManager;

typedef void (^KiiBucketBlock)(KiiBucket *_Nonnull bucket, NSError *_Nullable error);
typedef void (^KiiQueryResultBlock)(KiiQuery *_Nullable query, KiiBucket *_Nonnull bucket, NSArray *_Nullable results, KiiQuery *_Nullable nextQuery, NSError *_Nullable error);
typedef void (^KiiCountQueryResultBlock)(KiiBucket *_Nonnull bucket, KiiQuery *_Nullable query, NSUInteger result, NSError *_Nullable error);

/** A reference to a bucket within an application, group or user's scope which contains KiiObjects */
@interface KiiBucket : KiiBaseBucket <KiiSubscribable>
NS_ASSUME_NONNULL_BEGIN
/** Get the ACL handle for this bucket. Any <KiiACLEntry> objects added or revoked from this ACL object will be appended to/removed from the server on ACL save. */
@property (readonly) KiiACL *bucketACL;

/** Create a <KiiObject> within the current bucket, with type
 
 The object will not be created on the server until the <KiiObject> is explicitly saved. This method simply returns an empty working <KiiObject> with a specified type. The type allows for better indexing and improved query results. It is recommended to use this method - but for lazy creation, the <createObject> method is also available.
 @param objectType A string representing the desired object type
 @return An empty <KiiObject> with the specified type
 */
- (KiiObject*) createObjectWithType:(nullable NSString*)objectType;


/** Create a <KiiObject> within the current bucket
 
 The object will not be created on the server until the <KiiObject> is explicitly saved. This method simply returns an empty working <KiiObject>.
 @return An empty <KiiObject> with the specified type
 */
- (KiiObject*) createObject;

/** Instantiate KiiObject specifying its ID.

 If the object has not existed on KiiCloud,
 <saveAllFieldsSynchronous:withError:>, <saveAllFields:withBlock:> or <saveAllFields:withDelegate:andCallback:>
 will create new Object which has ID specified in the argument.
 If the object exists in KiiCloud, references the existing object which has specified ID,
 use <KiiObject#refreshSynchronous:> to retrieve the contents of KiiObject.
 @param objectID The ID of the KiiObject you'd like to use. It has to match the pattern with: ^[a-zA-Z0-9-_\\.]{2,100}$
 @return A KiiObject instance.
 @exception NSInvalidArgumentException Thrown if objectID is not acceptable.
 */
- (KiiObject *)createObjectWithID:(NSString *)objectID;

/** Execute a query on the current bucket
 
 The query will be executed against the server, returning a result set. This is a blocking method

    KiiBucket *bucket = ...;
    KiiQuery *query = ...;

    // To recursively get all results in a query (from multiple pages)
    KiiQueryResultBlock __block __weak weakQueryBlock;
    KiiQueryResultBlock queryBlock = ^(KiiQuery *retQuery, KiiBucket *retBucket, NSArray *retResults, KiiQuery *retNextQuery, NSError *retError) {
        // We got some valid results
        if (retError == nil) {
            // Do something with the results
            [self handleResults:retResults];
        }

        // We have another query available (another page of results)
        if (retNextQuery != nil) {
            // Execute the next query
            [bucket executeQuery:retNextQuery withBlock:[weakQueryBlock copy]];
        }
    };
    weakQueryBlock = queryBlock;

    [bucket executeQuery:query withBlock:queryBlock];
 
 @param query The query to execute. If nil, fetch all items in the bucket.
 @param block The block to be called upon method completion. See example
*/
- (void) executeQuery:(nullable KiiQuery*)query withBlock:(KiiQueryResultBlock)block;

/** Execute a query on the current bucket
 
 The query will be executed against the server, returning a result set. This is a blocking method
 @param query The query to execute. If nil, fetch all items in the bucket.
 @param nextQuery A <KiiQuery> object representing the next set of results, if they couldn't all be returned in the current query
 @param error used to return an error by reference (pass NULL if this is not desired). It is recommended to set an actual error object to get the error information.
 @return An NSArray of objects returned by the query.
    
    KiiBucket *bucket = ...;
    KiiQuery *query = ...;
    NSError *error = nil;
    KiiQuery *nextQuery = nil;
    NSMutableArray *allResults = [NSMutableArray array];

    do {
        if (nextQuery != nil) {
            // Set next query
            query = nextQuery;
        }
        // Do query
        NSArray *results = [bucket executeQuerySynchronous:query withError:&error nextQuery:&nextQuery];
        // Add results to the all results array
        [allResults addObjectsFromArray:results];
    } while (error == nil && nextQuery != nil);
 
    // Do something with the entire result set contained in allResults
    
 */
- (nullable NSArray* ) executeQuerySynchronous:(nullable KiiQuery*)query nextQuery:(KiiQuery*_Nullable*_Nullable)nextQuery error:(NSError*_Nullable*_Nullable)error;

/** Deprecated. Use executeQuerySynchronous:nextQuery:error */
- (nullable NSArray* ) executeQuerySynchronous:(nullable KiiQuery*)query withError:(NSError*_Nullable*_Nullable)error andNext:(KiiQuery*_Nullable*_Nullable)nextQuery __attribute__((deprecated("Use executeQuerySynchronous:nextQuery:error:")));

/** Execute a query on the current bucket
 
 The query will be executed against the server, returning a result set. This is a non-blocking method
 @param query The query to execute. If nil, fetch all items in the bucket.
 @param delegate The object to make any callback requests to
 @param callback The callback method to be called when the request is completed. The callback method should have a signature similar to:
 
    - (void)queryFinished:(KiiQuery *)query onBucket:(KiiBucket *)bucket withResults:(NSArray *)results andNext:(KiiQuery *)nextQuery andError:(NSError *)error {
        // The request was successful
        if (error == nil) {
            // Do something with the results
            for (KiiObject *o in results) {
                // use this object
            }

            // Also check to see if there are more results
            if (nextQuery != nil) {
                // There are more results, query for them
                [bucket executeQuery:nextQuery withDelegate:self andCallback:@selector(queryFinished:onBucket:withResults:andNext:andError:)];
            }
        } else {
            // there was a problem
        }
    }
 
 */
- (void) executeQuery:(nullable KiiQuery*)query withDelegate:(id)delegate andCallback:(SEL)callback;

/**Synchronously execute count aggregation of all clause query on current bucket.
 This is blocking method.
 @param error used to return an error by reference (pass NULL if this is not desired). It is recommended to set an actual error object to get the error information.
 @return NSNumber number of object inside the current bucket in unsigned integer format, nil if error.
 */
- (nullable NSNumber* ) countObjectsSynchronous:(NSError*_Nullable*_Nullable) error;

/** Depreacated. Use countObjectsSynchronous:error */
- (NSUInteger) countSynchronous:(NSError*_Nullable*_Nullable) error __attribute__((deprecated("Use countObjectsSynchronous:error:.")));

/**Synchronously execute count aggregation of specific query on current bucket.
 This is blocking method.
 
 Do not pass query from next query of <executeQuerySynchronous:withError:andNext:> or nextQuery from callback/block, otherwise an error (code 604) will be returned.
 
 If the given query is not supported, an error (code 604) will be returned.

 @param error used to return an error by reference (pass NULL if this is not desired). It is recommended to set an actual error object to get the error information.
 @param query The query to execute. If nil, KiiQuery with all clause wil be set by default.
 @return NSNumber number of object inside the current bucket in unsigned integer format, nil if error.
 */
- (nullable NSNumber* ) countObjectsSynchronous:(nullable KiiQuery*) query error:(NSError*_Nullable*_Nullable) error;

/** Deprecated. Use countObjectSynchronous:error: */
- (NSUInteger) countSynchronousWithQuery:(nullable KiiQuery*) query andError:(NSError*_Nullable*_Nullable) error __attribute__((deprecated("Use countObjectSynchronous:error.")));

/**Asynchronously execute count aggregation of all clause query on current bucket.
 This is non-blocking method. 
 
        KiiBucket *bucket = ...;
        [bucket count:^(KiiBucket *bucket, KiiQuery *query, NSUInteger result, NSError *error){
        
            if(error){
                // do something with error;
                return;
            }
     
            NSLog(@"count :%d",result);

        };
 
 @param block The block to be called upon method completion. See example.
 */
- (void) count:(KiiCountQueryResultBlock) block;

/**Asynchronously execute count aggregation of specific query on current bucket.
 This is non-blocking method. 
 
 Do not pass query from next query of <executeQuerySynchronous:withError:andNext:> or nextQuery from callback/block, otherwise an error (code 604) will be returned.
 
 If the given query is not supported, an error (code 604) will be returned.
 
        KiiBucket *bucket = ...;
        KiiQuery *query = ...;
        [bucket countWithQuery:query andBlock:^(KiiBucket *bucket, KiiQuery *query, NSUInteger result, NSError *error){

            if(error){
            // do something with error;
            return;
            }

            NSLog(@"count :%d",result);
        };
 
 @param block The block to be called upon method completion. See example.
 @param query The query to execute. If nil, KiiQuery with all clause wil be set by default.
 */
- (void) countWithQuery:(nullable KiiQuery*) query andBlock:(KiiCountQueryResultBlock) block;


/** Asynchronously deletes a bucket from the server.
 
 Delete a bucket from the server. This method is non-blocking.
 
     [b deleteWithBlock:^(KiiBucket *bucket, NSError *error) {
         if(error == nil) {
             NSLog(@"Bucket deleted!");
         }
     }];
 
 @param block The block to be called upon method completion. See example
*/
- (void) deleteWithBlock:(KiiBucketBlock)block;

/** Synchronously deletes a bucket from the server.
 
 Delete a bucket from the server. This method is blocking.
 @param error used to return an error by reference (pass NULL if this is not desired). It is recommended to set an actual error object to get the error information.
 @return YES if succeeded, NO otherwise.
 */
- (BOOL) deleteSynchronous:(NSError*_Nullable*_Nullable)error;


/** Asynchronously deletes a bucket from the server. 
 
 Delete a bucket from the server. This method is non-blocking.
 @param delegate The object to make any callback requests to
 @param callback The callback method to be called when the request is completed. The callback method should have a signature similar to:
 
     - (void) bucketDeleted:(KiiBucket*)bucket withError:(NSError*)error {
     
        // the request was successful
        if(error == nil) {
            // do something
        }
     
        else {
            // there was a problem
        }
     }
 
 */
- (void) delete:(id)delegate withCallback:(SEL)callback;

/** Get transfer manager object based on this bucket
@return A transfer manager object based on this file bucket. 
 */
-(KiiRTransferManager *) transferManager;

/** Checks whether the bucket name is valid or not.
 
 Valid bucket name definition is:
 
    - Not null or empty
    - Matches ^[a-zA-Z0-9-_]{2,64}$

 * @param bucketName Name of the bucket.
 * @return YES if valid otherwise NO.
 */
+(BOOL) isValidBucketName:(nullable NSString*) bucketName;
NS_ASSUME_NONNULL_END
@end
