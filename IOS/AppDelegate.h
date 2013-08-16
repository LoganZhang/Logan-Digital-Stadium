//
//  AppDelegate.h
//  IOS
//
//  Created by Hao Zhang on 04/06/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "CacheService.h"
#import "UIUpdateCentre.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CacheService * cacheService;
    UIUpdateCentre * uiUpdateCentre;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainViewController;
@end
