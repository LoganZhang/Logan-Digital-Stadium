//
//  DTN.h
//  Digi Stadium
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventDelegate.h"
#import "RequestData.h"
#import "UPL.h"
#import "CPL.h"
#import "BT2.h"
#import "AssetList.h"
#import "UtilityFunction.h"
#import "RequestCentre.h"

@interface DTN  : NSOperation
{
    id<EventDelegate> eventDelegate;
    BT2 * bt2;
    UPL * upl;
    CPL * cpl;
    AssetList * asset;
    UtilityFunction * utility;
    RequestCentre * requestCentre;
}
@property (strong,nonatomic)  id<EventDelegate> eventDelegate;

@end
