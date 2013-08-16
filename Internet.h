//
//  Internet.h
//  Digi Stadium
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventDelegate.h"
#import "RequestData.h"
#import "UtilityFunction.h"
@interface Internet : NSObject
{
    id<EventDelegate> eventDelegate;
    UtilityFunction * utility;
}
@property (strong,nonatomic)  id<EventDelegate> eventDelegate;
-(void)updateData:(RequestData *) data;
@end
