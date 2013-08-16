//
//  DTN.m
//  Digi Stadium
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "DTN.h"
#define DTN_SLEEP 10
@implementation DTN
@synthesize eventDelegate;
-(id) init
{
    if ((self = [super init]) != NULL)
    {
        bt2 = [[BT2 alloc] init];
        bt2.eventDelegate = (id)self;
        upl = [UPL alloc];
        cpl = [CPL alloc];
        asset = [AssetList alloc];
        requestCentre = [RequestCentre alloc];
        utility = [[UtilityFunction alloc] init];
    }
    return (self);
}
- (void) main
{
    while (true)
    {
        [NSThread sleepForTimeInterval:DTN_SLEEP];
        if ([bt2 isConnected])
        {
            @synchronized(upl)
            {
                for(int i=0; i<[upl getCount]; i++)
                {
                    RequestData * requestData = [upl getObjectAtIndex:i];
                    if([requestData.dataSource isEqualToString:TO_INTERNET])
                    {
                        continue;
                    }
                    if([requestData.done isEqualToString:DONE])
                    {
                        continue;
                    }
                    if([utility isNeedToSend:requestData.url])
                    {
                        NSData * data = [utility castRequestDataToJsonData:requestData];
                        [utility logRequestData:requestData type:3];
                        [bt2 sendDataToPeers:data];
                        requestData.done = DONE;
                    }
                }
                
                for(int i=0; i<[asset getCount]; i++)
                {
                    CacheData * cacheData = [asset getObjectAtIndex:i];
                    if([cacheData.source isEqualToString:LOCAL_STRING])
                    {
                        continue;
                    }
                    if([cacheData.done isEqualToString:DONE])
                    {
                        continue;
                    }
                    if([utility isNeedToSend:cacheData.url])
                    {
                        NSData * data = [utility castCacheDataToJsonData:cacheData];
                        [utility logCacheData:cacheData type:7];
                        [bt2 sendDataToPeers:data];
                        cacheData.done = DONE;
                    }
                }
            }
        }
    }
}
-(void)sendDataToNewPeers
{
    @synchronized(upl)
    {
        for(int i=0; i<[upl getCount]; i++)
        {
            RequestData * requestData = [upl getObjectAtIndex:i];
            if([requestData.dataSource isEqualToString:TO_INTERNET])
            {
                continue;
            }
            if([utility isNeedToSend:requestData.url])
            {
                NSData * data = [utility castRequestDataToJsonData:requestData];
                [utility logRequestData:requestData type:3];
                [bt2 sendDataToPeers:data];
                requestData.done = DONE;
            }
        }
        
        for(int i=0; i<[asset getCount]; i++)
        {
            CacheData * cacheData = [asset getObjectAtIndex:i];
            if([cacheData.source isEqualToString:LOCAL_STRING])
            {
                continue;
            }
            if([utility isNeedToSend:cacheData.url])
            {
                NSData * data = [utility castCacheDataToJsonData:cacheData];
                [utility logCacheData:cacheData type:7];
                [bt2 sendDataToPeers:data];
                cacheData.done = DONE;
            }
        }
    }
}
-(void)newPeerCallBack
{
    [self sendDataToNewPeers];
}
-(void)bt2MessageCallBack:(NSString *)str
{
    CacheData * cacheData = [utility castStringToCacheData:str];
   
    if(cacheData != nil)
    {
        [utility logCacheData:cacheData type:5];
        [self sendAssetItemToNetworkModule:cacheData];
    }
    else
    {
        RequestData * requestData = [utility castStringToRequestData:str];
        if (requestData!=nil)
        {
            [utility logRequestData:requestData type:1];
            [requestCentre addPeersRequest:requestData];
        }
    }
}
-(void) sendAssetItemToNetworkModule:(CacheData *) data
{
    if (self.eventDelegate!=nil)
    {
        data.source = DTN_STRING;
        [self.eventDelegate messageCallBack:data];
    }
}
@end
