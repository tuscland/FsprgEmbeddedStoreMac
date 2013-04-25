//
//  FsprgLicense.h
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/24/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import <Cocoa/Cocoa.h>


/*!
 * License information. FsprgLicense is backed by a NSMutableDictionary that
 * can be accessed and modified via the raw and setRaw: methods.
 */
@interface FsprgLicense : NSObject

@property (nonatomic, readwrite, strong) NSDictionary *raw;
@property (nonatomic, readonly) NSString *licenseName;
@property (nonatomic, readonly) NSString *licenseEmail;
@property (nonatomic, readonly) NSString *licenseCompany;
@property (nonatomic, readonly) NSString *firstLicenseCode;
@property (nonatomic, readonly) NSArray *licenseCodes;
@property (nonatomic, readonly) NSDictionary *licensePropertyList;
@property (nonatomic, readonly) NSURL *licenseURL;

+ (FsprgLicense *)licenseWithDictionary:(NSDictionary *)aDictionary;

- (FsprgLicense *)initWithDictionary:(NSDictionary *)aDictionary;

@end
