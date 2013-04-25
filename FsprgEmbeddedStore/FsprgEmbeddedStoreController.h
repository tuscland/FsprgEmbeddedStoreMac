//
//  FsprgEmbeddedStoreController.h
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/12/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "FsprgEmbeddedStoreDelegate.h"


/*!
 * Controller for FastSpring's embedded store.
 */
@interface FsprgEmbeddedStoreController : NSObject

/*!
 * Connects this controller to a web view.
 * @param aWebView Web view to connect.
 */
@property (nonatomic, readwrite, strong) IBOutlet WebView *webView;

/*!
 * Sets a delegate to which it has a weak reference.
 * @param aDelegate Delegate to set.
 */
@property (nonatomic, readwrite, weak) IBOutlet id<FsprgEmbeddedStoreDelegate> delegate;

/*!
 * Host that delivers the store (e.g. sites.fastspring.com).
 * @result <code>nil</code> until the store has been loaded.
 */
@property (nonatomic, readonly, strong) NSString *storeHost;

/*!
 * Useful to trigger e.g. the hidden flag of a progress bar.
 * @result TRUE if loading a page.
 */
@property (nonatomic, readonly, getter = isLoading) BOOL loading;

/*!
 * Useful to provide the value for a progress bar.
 * @result The loading progress in percent of a page (0 - 100)
 */
@property (nonatomic, readonly) double estimatedLoadingProgress;

/**
 * Useful to show a secure icon.
 * @result TRUE if connection is secure (SSL)
 */
@property (nonatomic, readonly, getter = isSecure) BOOL secure;

/*!
 * Loads the store using the given parameters.
 * @param parameters Parameters that get passed to the store.
 */
- (void)loadWithParameters:(FsprgStoreParameters *)parameters;

/*!
 * Loads the store with content of a file (XML plist). Useful to develop and test the order confirmation view. You can create that plist file by using the bundled TestApp.app.
 * @param aPath File path.
 */
- (void)loadWithContentsOfFile:(NSString *)aPath;

@end
