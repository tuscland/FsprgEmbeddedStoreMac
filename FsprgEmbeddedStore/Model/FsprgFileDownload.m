//
//  FsprgFileDownload.m
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/24/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import "FsprgFileDownload.h"


@implementation FsprgFileDownload

@synthesize raw = _raw;

+ (FsprgFileDownload *)fileDownloadWithDictionary:(NSDictionary *)aDictionary
{
	return [[FsprgFileDownload alloc] initWithDictionary:aDictionary];
}

- (FsprgFileDownload *)initWithDictionary:(NSDictionary *)aDictionary
{
	self = [super init];
	if (self != nil) {
        self.raw = aDictionary;
	}
	return self;
}

- (NSURL *)fileURL
{
	return [NSURL URLWithString:[self.raw valueForKey:@"FileURL"]];
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
	// Don't need KVO as data won't change. Prevent having to keep (retain) instance variables.
	return FALSE;
}

@end
