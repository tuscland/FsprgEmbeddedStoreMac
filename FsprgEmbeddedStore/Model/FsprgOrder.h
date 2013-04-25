//
//  FsprgOrder.h
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/12/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FsprgOrderItem.h"


/*!
 * Order information. FsprgOrder is backed by a NSMutableDictionary that
 * can be accessed and modified via the raw and setRaw: methods.
 */
@interface FsprgOrder : NSObject

@property (nonatomic, readwrite, strong) NSDictionary *raw;
@property (nonatomic, readonly) BOOL orderIsTest;
@property (nonatomic, readonly) NSString *orderReference;
@property (nonatomic, readonly) NSString *orderLanguage;
@property (nonatomic, readonly) NSString *orderCurrency;
@property (nonatomic, readonly) NSNumber *orderTotal;
@property (nonatomic, readonly) NSNumber *orderTotalUSD;
@property (nonatomic, readonly) NSString *customerFirstName;
@property (nonatomic, readonly) NSString *customerLastName;
@property (nonatomic, readonly) NSString *customerCompany;
@property (nonatomic, readonly) NSString *customerEmail;

/*!
 * Shortcut for [[self orderItems] objectAtIndex:0].
 * @result First item.
 */
@property (nonatomic, readonly) FsprgOrderItem *firstOrderItem;
@property (nonatomic, readonly) NSArray *orderItems;

+ (FsprgOrder *)orderFromData:(NSData *)aData;

- (FsprgOrder *)initWithDictionary:(NSDictionary *)aDictionary;

@end
