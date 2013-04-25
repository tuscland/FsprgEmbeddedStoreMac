//
//  FsprgOrderDocumentRepresentation.m
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/12/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import "FsprgOrderDocumentRepresentation.h"
#import "FsprgEmbeddedStoreController.h"


@implementation FsprgOrderDocumentRepresentation

@synthesize order = _order;

- (NSString *)title
{
	return @"";
}

- (NSString *)documentSource
{
	return nil;
}

- (BOOL)canProvideDocumentSource
{
	return FALSE;
}

- (void)setDataSource:(WebDataSource *)aDataSource
{
}

- (void)receivedData:(NSData *)aData withDataSource:(WebDataSource *)aDataSource
{
    self.order = [FsprgOrder orderFromData:aData];
	FsprgEmbeddedStoreController *storeController = aDataSource.webFrame.webView.frameLoadDelegate;
	[storeController.delegate didReceiveOrder:self.order];
}

- (void)receivedError:(NSError *)anError withDataSource:(WebDataSource *)aDataSource
{
}

- (void)finishedLoadingWithDataSource:(WebDataSource *)aDataSource
{
}

@end
