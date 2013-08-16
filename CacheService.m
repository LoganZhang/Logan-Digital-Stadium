//
//  CacheService.m
//  Digi Stadium
//
//  This is for the cache service.
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "CacheService.h"

@implementation CacheService
@synthesize eventDelegate;

-(id) init
{
    if ((self = [super init]) != NULL)
    {
        upl = [UPL alloc];
        cpl = [CPL alloc];
        asset = [AssetList alloc];
        requestCenter = [RequestCentre alloc];
        requestCenter.eventDelegate = (id)self;
        network = [[Network alloc] init];
        network.eventDelegate = (id)self;
    }
    return (self);
}
- (void) main
{
    while (true)
    {
        [NSThread sleepForTimeInterval:30];
        @synchronized(upl)
        {
            for(int i=0; i<[upl getCount]; i++)
            {
                RequestData * data = [upl getObjectAtIndex:i];
                [network updateData:data];
            }
        }
    }
}
-(void)messageCallBack:(CacheData *)data
{
    @synchronized(upl)
    {
        int index = -1;
        for(int i=0; i<[upl getCount]; i++)
        {
            RequestData * request = [upl getObjectAtIndex:i];
            if([data.identifier isEqualToString:request.identifier])
            {
                index = i;
                break;
            }
        }
        if(index != -1)
        {
            [cpl addObject:[upl getObjectAtIndex:index]];
            [upl removeObjectAtIndex:index];
        }
        data = [asset updateList:data];
        [self performSelectorOnMainThread:@selector(sendToUIUpdateCentre:) withObject:data waitUntilDone:NO];
    }
}
-(void)requestCallBack:(RequestData *)data
{
    @synchronized(upl)
    {
        int index = -1;
        for(int i=0; i<[upl getCount]; i++)
        {
            RequestData * request = [upl getObjectAtIndex:i];
            if([data.identifier isEqualToString:request.identifier])
            {
                index = i;
                break;
            }
        }
        if(index == -1)
        {
            [upl addObject:data];
            [network updateData:data];
        }
    }
}
-(void) sendToUIUpdateCentre:(CacheData *) data
{
    if (self.eventDelegate!=nil)
    {
        [self.eventDelegate messageCallBack:data];
    }
}
@end
