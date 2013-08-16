//
//  UPL.m
//  Digi Stadium
//
//  This is for the unconfirmed POST list.
//
//  Created by Hao Zhang on 07/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "UPL.h"

@implementation UPL
static UPL *shared= nil;
NSMutableArray *_UPL;

+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (shared == nil)
        {
            shared = [super allocWithZone:zone];
            _UPL = [[NSMutableArray alloc] init];
            return shared;
        }
    }
    return shared;
}

- (int) getCount
{
    return _UPL.count;
}

- (RequestData *) getObjectAtIndex:(int) i
{
    if(i<_UPL.count)
    {
       return [_UPL objectAtIndex:i];
    }
    return nil;
}

- (void) removeObjectAtIndex:(int) i
{
    if(i<_UPL.count)
    {
        [_UPL removeObjectAtIndex:i];
    }
}

- (void) addObject:(RequestData *)data
{
    [_UPL addObject:data];
}
@end
