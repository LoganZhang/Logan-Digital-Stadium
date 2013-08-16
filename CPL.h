//
//  CPL.h
//  Digi Stadium
//
//  This is for the confirmed POST list.
//
//  Created by Hao Zhang on 07/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestData.h"
@interface CPL : NSObject
- (int) getCount;
- (void) addObject:(RequestData *)data;
- (RequestData *) getObjectAtIndex:(int) i;
@end
