//
//  FsprgOrderView.m
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/18/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import "FsprgOrderView.h"
#import "FsprgOrderDocumentRepresentation.h"
#import "FsprgOrder.h"
#import "FsprgEmbeddedStoreController.h"


@implementation FsprgOrderView

@synthesize dataSource = _dataSource;
@synthesize needsLayout = _needsLayout;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setAutoresizesSubviews:TRUE];
		[self setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    }
    return self;
}

- (void)dataSourceUpdated:(WebDataSource *)aDataSource
{
    self.dataSource = aDataSource;
}

- (void)drawRect:(NSRect)aRect
{
	if(self.needsLayout) {
		self.needsLayout = FALSE;
		[self layout];
	}
	[super drawRect:aRect];
}

- (void)layout
{
	if(self.subviews.count == 0) {
        self.frame = self.superview.frame;

		FsprgOrderDocumentRepresentation *representation = self.dataSource.representation;
		FsprgOrder *order = representation.order;
		FsprgEmbeddedStoreController *delegate = self.dataSource.webFrame.webView.UIDelegate;
		NSView *newSubview = [delegate.delegate viewWithFrame:self.frame forOrder:order];
		[self addSubview:newSubview];
	}
}

- (void)viewDidMoveToHostWindow
{
}
- (void)viewWillMoveToHostWindow:(NSWindow *)hostWindow
{
}

@end
