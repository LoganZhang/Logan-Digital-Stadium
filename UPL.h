//
//  UPL.h
//  Digi Stadium
//
//  This is for the unconfirmed POST list.
//
//  Created by Hao Zhang on 07/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheData.h"
#import "RequestData.h"

@interface UPL : NSObject
- (int) getCount;
- (RequestData *) getObjectAtIndex:(int) i;
- (void) removeObjectAtIndex:(int) i;
- (void) addObject:(RequestData *)data;
@end