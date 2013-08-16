//
//  MainViewController.h
//  DigitalStadium
//
//  This is the class for the main view.
//
//  Created by Hao Zhang on 04/06/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "DMScrollingTicker.h"

@interface MainViewController : UIViewController
{
    NSDictionary *viewsDic;
    UILabel *lb_text;
    UIImageView *seagullsImageView;
    UIButton *btn_menu;
    WebViewController *subWebView;
    UIViewController *subUIView;
    DMScrollingTicker *scrollingTicker;
}

// this should be called when the app has been actived.
- (void)activeApp;

// this should be called when the app goes to background.
- (void)pauseApp;

// open a view by a pariticular name which is in viewsDic.
// the names in viewsDic should be the some as the key values in /IOS/Supporting Files/CacheData.plist
- (void)openView:(NSString *) name;

@end