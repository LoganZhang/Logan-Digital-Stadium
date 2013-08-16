//
//  Internet.m
//  Digi Stadium
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "Internet.h"
#import "CacheData.h"
#import "CommonStrings.h"
@implementation Internet
@synthesize eventDelegate;
-(id) init
{
    if ((self = [super init]) != NULL)
    {
        utility = [[UtilityFunction alloc] init];
    }
    return (self);
}
-(void)updateData:(RequestData *) data;
{
    NSTimeInterval timeout = 10;
    
    if([data.url isEqualToString:CLUBC_URL] || [data.url isEqualToString:FANSC_URL])
    {
        timeout = 15;
    }
    [utility logRequestData:data type:4];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:data.url]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:timeout];
    [request setHTTPMethod: @"GET"];
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    if(requestError == nil)
    {
        NSString *content = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
        CacheData * result = [CacheData alloc];
        result.content = content;
        result.url = data.url;
        NSDate *now = [NSDate date];
        result.updateTime = now;
        result.jsonName = nil;
        result.identifier = data.identifier;
        if(result!=nil)
        {
            [utility logCacheData:result type:6];
            [self sendToNetworkModule:result];
        }
    }
}
-(void) sendToNetworkModule:(CacheData *) data
{
    if (self.eventDelegate!=nil)
    {
        data.source = INTERNET_STRING;
        [self.eventDelegate messageCallBack:data];
    }
}
@end
