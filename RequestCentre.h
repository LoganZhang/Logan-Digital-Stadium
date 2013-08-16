//
//  RequestCentre.h
//  Digi Stadium
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventDelegate.h"
#import "RequestData.h"
#import "UtilityFunction.h"

@interface RequestCentre : NSObject
{
    id<EventDelegate> eventDelegate;
}
@property (strong,nonatomic)  id<EventDelegate> eventDelegate;
-(void)addOwnRequest:(NSString *) url onlyGetFromInternet:(BOOL) onlyInternet;
-(void)addPeersRequest:(RequestData *) data;
@end
