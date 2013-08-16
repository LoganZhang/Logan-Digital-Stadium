//
//  BT2.h
//  Digi Stadium
//
//  Created by Hao Zhang on 07/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GameKit/GKSession.h>
#import <GameKit/GKPeerPickerController.h>
#import "EventDelegate.h"
#import "UtilityFunction.h"
#import "CommonStrings.h"

@interface BT2 : NSObject<GKSessionDelegate,GKPeerPickerControllerDelegate>{
    
    GKSession *currentSession;//GKSession对象用于表现两个蓝牙设备之间连接的一个会话，你也可以使用它在两个设备之间发送和接收数据。
    id<EventDelegate> eventDelegate;
    UtilityFunction * utility;
    NSArray * currentPeersList;
}

@property (nonatomic, retain) GKSession *currentSession;
@property Boolean isConnected;
@property (strong,nonatomic)  id<EventDelegate> eventDelegate;

-(void) sendDataToPeers:(NSData *)data;
@end