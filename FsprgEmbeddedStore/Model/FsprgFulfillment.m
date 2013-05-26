//
//  FsprgFulfillment.m
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/24/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import "FsprgFulfillment.h"
#import "FsprgLicense.h"
#import "FsprgFileDownload.h"


@implementation FsprgFulfillment

@synthesize raw = _raw;

+ (FsprgFulfillment *)fulfillmentWithDictionary:(NSDictionary *)aDictionary
{
	return [[FsprgFulfillment alloc] initWithDictionary:aDictionary];
}

- (FsprgFulfillment *)initWithDictionary:(NSDictionary *)aDictionary
{
	self = [super init];
	if (self != nil) {
        self.raw = aDictionary;
	}
	return self;
}

- (id)valueForKey:(NSString *)aKey
{
	NSDictionary *anItem = [[self raw] valueForKey:aKey];
	
	if([[anItem valueForKey:@"FulfillmentType"] isEqualToString:@"License"]) {
		return [FsprgLicense licenseWithDictionary:anItem];
	}
	if([[anItem valueForKey:@"FulfillmentType"] isEqualToString:@"File"]) {
		return [FsprgFileDownload fileDownloadWithDictionary:anItem];
	}
	
	return anItem;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
	// Don't need KVO as data won't change. Prevent having to keep (retain) instance variables.
	return FALSE;
}

@end
