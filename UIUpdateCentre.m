//
//  UIUpdateCentre.m
//  Digi Stadium
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "UIUpdateCentre.h"
#import "CacheData.h"

@implementation UIUpdateCentre
NSMutableArray * dataDelegates;
AssetList * asset;
RequestCentre * requestCentre;
static UIUpdateCentre *shared = nil;

+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (shared == nil)
        {
            shared = [super allocWithZone:zone];
            dataDelegates = [NSMutableArray array];
            asset = [AssetList alloc];
            requestCentre = [RequestCentre alloc];
            return shared;
        }
    }
    return shared;
}
- (CacheData *)getUIContent:(NSString *)url onlyGetFromInternet:(BOOL) onlyInternet
{
    [requestCentre addOwnRequest:url onlyGetFromInternet:onlyInternet];
    return [asset getData:url];
}
-(void)updateView:(CacheData *)data
{
    for(id delegate in dataDelegates)
    {
        [delegate messageCallBack:data];
    }
}

- (void)addDelegate:(id<EventDelegate>)target
{
    [dataDelegates addObject:target];
}

-(void)messageCallBack:(CacheData *)data
{
    [self updateView:data];
}
@end
