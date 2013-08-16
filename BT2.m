//
//  BT2.m
//  Digi Stadium
//
//  Created by Hao Zhang on 07/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "BT2.h"

#import <GameKit/GKPeerPickerController.h>

@implementation BT2
@synthesize currentSession,eventDelegate,isConnected;

-(id) init
{
    if ((self = [super init]) != NULL)
    {
        utility = [[UtilityFunction alloc] init];
        currentPeersList = [[NSArray alloc] init];
        [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(beep:) userInfo:nil repeats:YES];
    }
    return (self);
}

-(void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self sendToDTN:str];
}

-(void) sendToDTN:(NSString *) string
{
    if (self.eventDelegate!=nil) {
        [self.eventDelegate bt2MessageCallBack:string];
    }
}

-(void) sendDataToPeers:(NSData *)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *requestError = nil;
            if (currentSession)
            {
                [self.currentSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&requestError];
            }
        });
    });
}

-(void) searchGKPeer{
    currentSession = [[GKSession alloc] initWithSessionID:nil
                                              displayName:nil
                                              sessionMode: GKSessionModePeer ];
    currentSession.delegate = self;
    [currentSession setDataReceiveHandler:self withContext:nil];
    currentSession.available = YES;
    currentSession.disconnectTimeout = 0;
}


-(void)beep:(NSTimer *)timer
{
    [self checkAvailablePeer];
}

-(void) checkAvailablePeer
{
    @synchronized(currentPeersList)
    {
        if(currentSession == nil)
        {
            [self searchGKPeer];
        }
        if(currentSession == nil)
        {
            return;
        }
        NSArray * list = [currentSession peersWithConnectionState:GKPeerStateConnected];
        if([self foundNewPeer:list] && list.count!=0)
        {
            if (self.eventDelegate!=nil) {
                [self.eventDelegate newPeerCallBack];
            }
        }
        if(list.count == 0)
        {
            [self searchGKPeer];
        }
    }
}
- (BOOL)foundNewPeer:(NSArray *)list
{
    if(list.count==0)
    {
        return false;
    }
    for(int i = 0; i< list.count;i++)
    {
        bool foundRepeat = false;
        for(int j=0;j<currentPeersList.count;j++)
        {
            if([currentPeersList[j] isEqualToString:list[i]])
            {
                foundRepeat = true;
                continue;
            }
        }
        if(!foundRepeat)
        {
            currentPeersList = list;
            return true;
        }
    }
    currentPeersList = list;
    return false;
}
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
    
    picker.delegate = nil;
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    currentSession = session;
    switch (state)
    {
        case GKPeerStateAvailable:
        {
            isConnected = false;
            [currentSession connectToPeer:peerID withTimeout:0];
        }
            break;
        case GKPeerStateConnected:
        {
            isConnected = true;
        }
            break;
        case GKPeerStateDisconnected:
        {
            isConnected = false;
            [self searchGKPeer];
        }
        default:
            isConnected = false;
            break;
    }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
    [currentSession acceptConnectionFromPeer:peerID error:nil];
    
}

/*
 *从一个Apple设备中断开连接
 */
-(void) disconnect
{
    [currentSession disconnectFromAllPeers];
    [currentSession setAvailable:NO];
    [currentSession setDelegate:nil];
    [currentSession setDataReceiveHandler:nil withContext:nil];
}

@end