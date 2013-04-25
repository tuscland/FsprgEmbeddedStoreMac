//
//  FsprgOrderItem.h
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/24/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FsprgFulfillment.h"
#import "FsprgLicense.h"
#import "FsprgFileDownload.h"


/*!
 * Order item information. FsprgOrderItem is backed by a NSMutableDictionary that
 * can be accessed and modified via the raw and setRaw: methods.
 */
@interface FsprgOrderItem : NSObject

@property (nonatomic, readwrite, strong) NSDictionary *raw;
@property (nonatomic, readonly) NSString *productName;
@property (nonatomic, readonly) NSString *productDisplay;
@property (nonatomic, readonly) NSNumber *quantity;
@property (nonatomic, readonly) NSNumber *itemTotal;
@property (nonatomic, readonly) NSNumber *itemTotalUSD;

/*!
 * This reference can be used to make calls to FastSpring's Subscription API.
 * See https://support.fastspring.com/entries/236487-api-subscriptions
 */
@property (nonatomic, readonly) NSString *subscriptionReference;

/*!
 * This URL can be presented to the customer to manage their subscription.
 */
@property (nonatomic, readonly) NSURL *subscriptionCustomerURL;

@property (nonatomic, readonly) FsprgFulfillment *fulfillment;

/*!
 * Shortcut for [[self fulfillment] valueForKey:@"license"].
 * @result License information.
 */
@property (nonatomic, readonly) FsprgLicense *license;

/*!
 * Shortcut for [[self fulfillment] valueForKey:@"download"].
 * @result Download information.
 */
@property (nonatomic, readonly) FsprgFileDownload *download;

+ (FsprgOrderItem *)itemWithDictionary:(NSDictionary *)aDictionary;

- (FsprgOrderItem *)initWithDictionary:(NSDictionary *)aDictionary;

@end
