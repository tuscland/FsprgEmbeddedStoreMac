//
//  FsprgOrderItem.m
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/24/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import "FsprgOrderItem.h"


@implementation FsprgOrderItem

@synthesize raw = _raw;

+ (FsprgOrderItem *)itemWithDictionary:(NSDictionary *)aDictionary
{
	return [[FsprgOrderItem alloc] initWithDictionary:aDictionary];
}

- (FsprgOrderItem *)initWithDictionary:(NSDictionary *)aDictionary
{
	self = [super init];
	if (self != nil) {
		self.raw = aDictionary;
	}
	return self;
}

- (NSString *)productName
{
	return [self.raw valueForKey:@"ProductName"];
}

- (NSString *)productDisplay
{
	return [self.raw valueForKey:@"ProductDisplay"];
}

- (NSNumber *)quantity
{
	return [self.raw valueForKey:@"Quantity"];
}

- (NSNumber *)itemTotal
{
	return [self.raw valueForKey:@"ItemTotal"];
}

- (NSNumber *)itemTotalUSD
{
	return [self.raw valueForKey:@"ItemTotalUSD"];
}

- (NSString *)subscriptionReference
{
	return [self.raw valueForKey:@"SubscriptionReference"];
}

- (NSURL *)subscriptionCustomerURL
{
    return [NSURL URLWithString:[self.raw valueForKey:@"SubscriptionCustomerURL"]];
}

- (FsprgFulfillment *)fulfillment
{
	return [FsprgFulfillment fulfillmentWithDictionary:[self.raw valueForKey:@"Fulfillment"]];
}

- (FsprgLicense *)license
{
	return [self.fulfillment valueForKey:@"license"];
}

- (FsprgFileDownload *)download
{
	return [self.fulfillment valueForKey:@"download"];
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
	// Don't need KVO as data won't change. Prevent having to keep (retain) instance variables.
	return FALSE;
}

@end
