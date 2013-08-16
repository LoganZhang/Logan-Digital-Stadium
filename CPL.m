//
//  CPL.m
//  Digi Stadium
//
//  This is for the confirmed POST list.
//
//  Created by Hao Zhang on 07/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "CPL.h"

@implementation CPL
static CPL *shared= nil;
NSMutableArray *_CPL;

+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (shared == nil)
        {
            shared = [super allocWithZone:zone];
            _CPL = [[NSMutableArray alloc] init];
            return shared;
        }
    }
    return shared;
}

- (void) addObject:(RequestData *)data
{
     [_CPL addObject:data];
}

- (int) getCount
{
    return _CPL.count;
}

- (RequestData *) getObjectAtIndex:(int) i
{
    if(i<_CPL.count)
    {
        return [_CPL objectAtIndex:i];
    }
    return nil;
}

@end
