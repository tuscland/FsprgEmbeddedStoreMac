//
//  FsprgOrderView.h
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/18/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


/*!
 * WebDocumentView implementation encapsulating the order
 * confirmation view of FsprgEmbeddedStoreDelegate.
 */
@interface FsprgOrderView : NSView<WebDocumentView>

@property (nonatomic, readwrite, strong) WebDataSource *dataSource;
@property (nonatomic, readwrite) BOOL needsLayout;

@end
