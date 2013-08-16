//
//  Network.m
//  Digi Stadium
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "Network.h"
#import "DTN.h"
#import "CommonStrings.h"
#import "ThreadsPool.h"
#import "Log.h"
@implementation Network
@synthesize eventDelegate;
bool isPost;
bool isConnectedToInternet;
-(id)init
{
    if ((self = [super init]) != NULL)
    {
        //是不是比赛日
        dtn = [[DTN alloc] init];
        dtn.eventDelegate = (id)self;
        internet = [[Internet alloc] init];
        internet.eventDelegate = (id)self;
        [ThreadsPool startService:dtn];
        isConnectedToInternet = true;
        isPost = false;
        [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(beep:) userInfo:nil repeats:YES];

    }
    return (self);
}
-(void)beep:(NSTimer *)timer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimeInterval timeout = 10;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:TargetServer]
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                           timeoutInterval:timeout];
        [request setHTTPMethod: @"GET"];
        NSError *requestError = nil;
        NSURLResponse *urlResponse = nil;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
        if(requestError == nil)
        {
            isConnectedToInternet = true;
        } else {
            isConnectedToInternet = false;
        }
    });
}

- (void)updateData:(RequestData *) data;
{
    if(isConnectedToInternet)
    {
        if(!isPost)
        {
            [Log uploadLog];
            isPost= true;
        }
        [self updateDataFromInternet:data];
    }
}
- (void)updateDataFromInternet:(RequestData *) data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [internet updateData:data];
    });
}
-(void)messageCallBack:(CacheData *)data
{
    [self sendToCacheModule:data];
}
-(void) sendToCacheModule:(CacheData *) data
{
    if (self.eventDelegate!=nil)
    {
        [self.eventDelegate messageCallBack:data];
    }
}
@end
