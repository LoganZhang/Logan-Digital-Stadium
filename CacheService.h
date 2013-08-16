//
//  CacheService.h
//  Digi Stadium
//
//  This is for the cache service.
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssetList.h"
#import "Network.h"
#import "RequestCentre.h"
#import "RequestData.h"
#import "CommonStrings.h"
#import "UPL.h"
#import "CPL.h"

@interface CacheService : NSOperation
{
    UPL * upl;
    CPL * cpl;
    AssetList * asset;
    Network * network;
    RequestCentre * requestCenter;
    id<EventDelegate> eventDelegate;
}
@property (strong,nonatomic)  id<EventDelegate> eventDelegate;
@end
