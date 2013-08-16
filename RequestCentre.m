//
//  RequestCentre.m
//  Digi Stadium
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "RequestCentre.h"
#import "CommonStrings.h"

@implementation RequestCentre
@synthesize eventDelegate;
static RequestCentre *shared = nil;
UtilityFunction * utility;
+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (shared == nil)
        {
            shared = [super allocWithZone:zone];
            utility= [[UtilityFunction alloc] init];
            return shared;
        }
    }
    return shared;
}
-(void)addOwnRequest:(NSString *) url onlyGetFromInternet:(BOOL) onlyInternet
{
    RequestData * data = [RequestData alloc];
    data.url = url;
    data.requestTime = [NSDate date];
    data.identifier = url;
    data.dataSource = TO_BOTH;
    if(onlyInternet)
    {
        data.dataSource = TO_INTERNET;
    }
    [utility logRequestData:data type:2];
    [self sendToCache:data];
}
-(void)addPeersRequest:(RequestData *) data;
{
    data.dataSource = TO_BOTH;
    [self sendToCache:data];
}
-(void) sendToCache:(RequestData *) data
{
    if (self.eventDelegate!=nil)
    {
        [self.eventDelegate requestCallBack:data];
    }
}
@end
