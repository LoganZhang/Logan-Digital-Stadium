//
//  WebViewUpdateDelegate.h
//  Digi Stadium
//
//
//  all of the event delegates are here.
//
//  Created by Hao Zhang on 13/06/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CacheData.h"
#import "RequestData.h"

@protocol EventDelegate <NSObject>
//call back method for passing Cache data
-(void)messageCallBack:(CacheData *)data;
//call back method for passing Request data
-(void)requestCallBack:(RequestData *)data;
//call back method for bluetooth
-(void)bt2MessageCallBack:(NSString *)string;
//call back method for finding new nodes
-(void)newPeerCallBack;
@end