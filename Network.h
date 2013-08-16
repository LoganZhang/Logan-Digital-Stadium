//
//  Network.h
//  Digi Stadium
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventDelegate.h"
#import "RequestData.h"
#import "DTN.h"
#import "Internet.h"

@interface Network : NSObject
{
    id<EventDelegate> eventDelegate;
    DTN * dtn;
    Internet *internet;
}
@property (strong,nonatomic)  id<EventDelegate> eventDelegate;
- (void)updateData:(RequestData *) data;
@end
