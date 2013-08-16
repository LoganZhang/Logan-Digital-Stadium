//
//  WebViewController.h
//  Digi Stadium
//
//  This is for the web view.
//
//  Created by Hao Zhang on 01/07/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUpdateCentre.h"
@interface WebViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    UIUpdateCentre *uiUpdateCentre;
    NSString *currentURL;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
// load a particular digital service by name.
- (void)loadWebView:(NSString *) name;
@end