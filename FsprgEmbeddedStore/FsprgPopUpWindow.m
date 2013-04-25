//
//  FsprgPopUpWindow.m
//  ActivatedApplication
//
//  Created by Camille Troillard on 20/04/13.
//  Copyright (c) 2013 Wildora. All rights reserved.
//

#import "FsprgPopUpWindow.h"

@implementation FsprgPopUpWindow

- (id)init
{
    self = [super initWithContentRect:NSMakeRect(0,0,0,0)
                            styleMask:NSClosableWindowMask|NSResizableWindowMask
                              backing:NSBackingStoreBuffered
                                defer:NO];
    return self;
}

- (BOOL)canBecomeMainWindow
{
    return NO;
}

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

- (BOOL)isExcludedFromWindowsMenu
{
    return YES;
}

@end
