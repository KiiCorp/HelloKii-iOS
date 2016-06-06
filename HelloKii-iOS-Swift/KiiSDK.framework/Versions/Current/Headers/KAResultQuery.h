//
//  KAResultQuery.h
//  KiiAnalytics
//
//  Copyright (c) 2013 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KADateRange, KAFilter;

/** Use this class to generate a query against the analytics data
 */
@interface KAResultQuery : NSObject

/** The grouping key associated with the query object.
 If nil is passed, no grouping key is applied.
 @exception NSException Named NSInvalidArgumentException is thrown if groupingKey is invalid. GroupingKey must match with pattern ^[a-zA-Z][a-zA-Z0-9_]{0,63}$
 */
@property(nonatomic, nullable) NSString * groupingKey;

/** The filter associated with the query object.
 If nil is passed, no filter is applied.
 @exception NSException Named NSInvalidArgumentException is thrown if filter has no element.
 */
@property(nonatomic, nullable) KAFilter * filter;

/** The date range for the query object.
 If nil is passed, no date range is applied.
 */
@property(nonatomic, nullable) KADateRange * dateRange;

@end
