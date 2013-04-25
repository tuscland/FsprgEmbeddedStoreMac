//
//  FsprgStoreParameters.h
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/19/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*! Constants for orderProcessType */
extern NSString *const kFsprgOrderProcessDetail;
extern NSString *const kFsprgOrderProcessInstant;

/*! Constants for mode */
extern NSString *const kFsprgModeActive;
extern NSString *const kFsprgModeActiveTest;
extern NSString *const kFsprgModeTest;


/*!
 * FastSpring store parameters. FsprgStoreParameters is backed by a NSMutableDictionary that
 * can be accessed and modified via the raw and setRaw: methods.
 */
@interface FsprgStoreParameters : NSObject

/*!
 * Pass a language code via the URL to bypass automatic language detection.
 * Example: de
 */
@property (nonatomic, readwrite) NSString *language;

/*!
 * Use kFsprgOrderProcessDetail or kFsprgOrderProcessInstant.
 */
@property (nonatomic, readwrite) NSString *orderProcessType;

/*!
 * Store path name and product path name.
 * These are found in a full product URL such as sites.fastspring.com/<STOREPATH>/product/<PRODUCTPATH>
 */
@property (nonatomic, readwrite) NSString *storeId;
@property (nonatomic, readwrite) NSString *productId;

/*!
 * Use kFsprgModeActive, kFsprgModeActiveTest or kFsprgModeTest.
 */
@property (nonatomic, readwrite) NSString *mode;

/*!
 * Used for "External Tracking". Go to "Link Sources" inside SpringBoard.
 * Example: november_sale_post
 */
@property (nonatomic, readwrite) NSString *campaign;

/*!
 * Used for advanced and atypical store configuration options.
 */
@property (nonatomic, readwrite) NSString *option;

/*!
 * Pass a custom referrer via the URL to override the automatically detected referring URL (HTTP_REFERER).
 * The value passed in this parameter is available in notifications and data exports. If a value is
 * passed in this parameter then no data will be stored from the HTTP_REFERER header.
 * Example: xyz123
 */
@property (nonatomic, readwrite) NSString *referrer;

/*!
 * Used for "External Tracking". Go to "Link Sources" inside SpringBoard.
 * Example: my_blog
 */
@property (nonatomic, readwrite) NSString *source;

/*!
 * Pass a coupon code via the URL to automatically apply a coupon to the order so that the customer
 * does not need to enter it. A corresponding coupon code must be setup and associated with a promotion.
 * Example: DECSPECIAL987
 */
@property (nonatomic, readwrite) NSString *coupon;

@property (nonatomic, readonly) BOOL hasContactDefaults;
@property (nonatomic, readwrite) NSString *contactFname;
@property (nonatomic, readwrite) NSString *contactLname;
@property (nonatomic, readwrite) NSString *contactEmail;
@property (nonatomic, readwrite) NSString *contactCompany;
@property (nonatomic, readwrite) NSString *contactPhone;

+ (FsprgStoreParameters *)parameters;
+ (FsprgStoreParameters *)parametersWithRaw:(NSMutableDictionary *)aRaw;

- (id)initWithRaw:(NSMutableDictionary *)aRaw;

- (void)setStoreId:(NSString *)aStoreId withProductId:(NSString *)aProductId;

- (NSURLRequest *)toURLRequest;
- (NSURL *)toURL;

@end
