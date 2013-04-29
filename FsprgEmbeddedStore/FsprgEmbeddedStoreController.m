//
//  FsprgEmbeddedStoreController.m
//  FsprgEmbeddedStore
//
//  Created by Lars Steiger on 2/12/10.
//  Copyright 2010 FastSpring. All rights reserved.
//

#import "FsprgPopUpWindow.h"
#import "FsprgEmbeddedStoreController.h"
#import "FsprgOrderView.h"
#import "FsprgOrderDocumentRepresentation.h"


@interface FsprgEmbeddedStoreController ()

@property (nonatomic, readwrite, strong) NSString *storeHost;
@property (nonatomic, readwrite, strong) NSWindow *popUpWindow;
@property (nonatomic, readwrite, copy) NSURLRequest *cachedPopUpLinkRequest;

- (void)resizeContentDivE;
- (void)webViewFrameChanged:(NSNotification *)aNotification;

@end


@implementation FsprgEmbeddedStoreController

@synthesize webView = _webView;
@synthesize delegate = _delegate;
@synthesize storeHost = _storeHost;
@synthesize popUpWindow = _popUpWindow;
@synthesize cachedPopUpLinkRequest = _cachedPopUpLinkRequest;

+ (void)initialize
{
    [WebView registerViewClass:[FsprgOrderView class]
           representationClass:[FsprgOrderDocumentRepresentation class]
                   forMIMEType:@"application/x-fsprgorder+xml"];
}

+ (BOOL)automaticallyNotifiesObserversOfLoading
{
    return NO;
}

+ (BOOL)automaticallyNotifiesObserversOfEstimatedLoadingProgress
{
    return NO;
}

+ (BOOL)automaticallyNotifiesObserversOfSecure
{
    return NO;
}

- (void)setWebView:(WebView *)aWebView
{
    if (_webView != aWebView) {
        _webView.postsFrameChangedNotifications = NO;
        _webView.frameLoadDelegate = nil;
        _webView.UIDelegate = nil;
        _webView.policyDelegate = nil;
        _webView.applicationNameForUserAgent = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSViewFrameDidChangeNotification
                                                      object:_webView];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:WebViewProgressStartedNotification
                                                      object:_webView];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:WebViewProgressEstimateChangedNotification
                                                      object:_webView];
        [_webView close];

        _webView = aWebView;

        if (_webView) {
            _webView.postsFrameChangedNotifications = YES;
            _webView.frameLoadDelegate = self;
            _webView.UIDelegate = self;
            _webView.policyDelegate = self;
            _webView.applicationNameForUserAgent = @"FSEmbeddedStore/2.0";
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(webViewFrameChanged:)
                                                         name:NSViewFrameDidChangeNotification
                                                       object:_webView];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(estimatedLoadingProgressChanged:)
                                                         name:WebViewProgressStartedNotification
                                                       object:_webView];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(estimatedLoadingProgressChanged:)
                                                         name:WebViewProgressEstimateChangedNotification
                                                       object:_webView];
        }
    }
}

- (void)loadWithParameters:(FsprgStoreParameters *)parameters
{
    if (self.delegate == nil) {
        NSLog(@"No delegate has been assigned to FsprgEmbeddedStoreController!");
    }
    NSURLRequest *urlRequest = [parameters toURLRequest];

    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[urlRequest URL]];
    NSUInteger i, count = [cookies count];
    for (i = 0; i < count; i++) {
        NSHTTPCookie *cookie = [cookies objectAtIndex:i];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }

    self.storeHost = nil;
    [self.webView.mainFrame loadRequest:urlRequest];
}

- (void)loadWithContentsOfFile:(NSString *)aPath
{
    if (self.delegate == nil) {
        NSLog(@"No delegate has been assigned to FsprgEmbeddedStoreController!");
    }
    self.storeHost = nil;

    NSData *data = [NSData dataWithContentsOfFile:aPath];
    if (data == nil) {
        NSLog(@"File %@ not found.", aPath);
    } else {
        [self.webView.mainFrame loadData:data MIMEType:@"application/x-fsprgorder+xml" textEncodingName:@"UTF-8" baseURL:nil];
    }
}

- (BOOL)isLoading
{
    return self.estimatedLoadingProgress < 100;
}
- (double)estimatedLoadingProgress
{
    return self.webView.estimatedProgress * 100;
}
- (void)estimatedLoadingProgressChanged:(NSNotification *)aNotification
{
    [self willChangeValueForKey:@"estimatedLoadingProgress"];
    [self willChangeValueForKey:@"loading"];
    // just trigger change...
    [self didChangeValueForKey:@"loading"];
    [self didChangeValueForKey:@"estimatedLoadingProgress"];
}
- (BOOL)isSecure
{
    WebDataSource *mainFrameDs = self.webView.mainFrame.dataSource;
    return [@"https" isEqualToString:mainFrameDs.request.URL.scheme];
}

- (void)resizeContentDivE {
    DOMElement *resizableContentE = [self.webView.mainFrame.DOMDocument getElementById:@"FsprgResizableContent"];
    if(resizableContentE == nil) {
        return;
    }

    float windowHeight = self.webView.frame.size.height;
    float pageNavigationHeight = [[[self.webView windowScriptObject] evaluateWebScript:@"document.getElementsByClassName('store-page-navigation')[0].clientHeight"] floatValue];

    DOMCSSStyleDeclaration *cssStyle = [self.webView computedStyleForElement:resizableContentE pseudoElement:nil];
    float paddingTop = [[[cssStyle paddingBottom] substringToIndex:[[cssStyle paddingTop] length]-2] floatValue];
    float paddingBottom = [[[cssStyle paddingBottom] substringToIndex:[[cssStyle paddingBottom] length]-2] floatValue];

    float newHeight = windowHeight - paddingTop - paddingBottom - pageNavigationHeight;
    [[resizableContentE style] setHeight:[NSString stringWithFormat:@"%fpx", newHeight]];
}

- (void)webViewFrameChanged:(NSNotification *)aNotification
{
    [self resizeContentDivE];
}


// WebFrameLoadDelegate

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    [self willChangeValueForKey:@"secure"];
    [self didChangeValueForKey:@"secure"];

    [self resizeContentDivE];

    NSURL *newURL = frame.dataSource.request.URL;
    NSString *newStoreHost;
    if ([@"file" isEqualToString:newURL.scheme]) {
        newStoreHost = @"file";
    } else {
        newStoreHost = [newURL host];
    }

    if ([self storeHost] == nil) {
        self.storeHost = newStoreHost;
        [self.delegate didLoadStore:newURL];
    } else {
        FsprgPageType newPageType;
        if([newStoreHost isEqualToString:self.storeHost]) {
            newPageType = FsprgPageFS;
        } else if ([newStoreHost hasSuffix:@"paypal.com"]) {
            newPageType = FsprgPagePayPal;
        } else {
            newPageType = FsprgPageUnknown;
        }
        [self.delegate didLoadPage:newURL ofType:newPageType];
    }
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
    [self.delegate webView:sender didFailProvisionalLoadWithError:error forFrame:frame];
}

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
    [self.delegate webView:sender didFailLoadWithError:error forFrame:frame];
}

// WebUIDelegate

- (void)webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    NSRunAlertPanel(@"Alert", message, @"OK", nil, nil);
}

- (void)webView:(WebView *)sender decidePolicyForNewWindowAction:(NSDictionary *)actionInformation
        request:(NSURLRequest *)request
   newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener
{
    self.cachedPopUpLinkRequest = request;
    [listener use];
}

- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
    if (request == nil && self.cachedPopUpLinkRequest != nil) {
		request = self.cachedPopUpLinkRequest;
        [[NSWorkspace sharedWorkspace] openURL:[request URL]];
        self.cachedPopUpLinkRequest = nil;
        return nil;
    }
    WebView *subWebView = [[WebView alloc] initWithFrame:NSMakeRect(0,0,0,0)];
    NSWindow *window = [[FsprgPopUpWindow alloc] init];
    window.contentView = subWebView;
    self.popUpWindow = window;
    [self.webView.window addChildWindow:window ordered:NSWindowAbove];
    return subWebView;
}

- (void)setPopUpWindow:(NSWindow *)popUpWindow
{
    if (_popUpWindow != popUpWindow) {
        if (_popUpWindow) {
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:NSWindowDidResignKeyNotification
                                                          object:_popUpWindow];
        }
        _popUpWindow = popUpWindow;
        if (_popUpWindow) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(popUpWindowDidResignKey:)
                                                         name:NSWindowDidResignKeyNotification
                                                       object:_popUpWindow];
        }
    }
}

- (void)popUpWindowDidResignKey:(NSNotification *)notification
{
    NSWindow *popUpWindow = self.popUpWindow;
    if (notification.object == popUpWindow) {
        [self.webView.window removeChildWindow:popUpWindow];
        [popUpWindow orderOut:nil];
        dispatch_async(dispatch_get_current_queue(), ^{
            self.popUpWindow = nil;
        });
    }
}

- (void)dealloc
{
    self.webView = nil;
    self.popUpWindow = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
