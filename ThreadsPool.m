//
//  ThreadsPool.m
//  Digi Stadium
//
//  This is a class for the threads pool.
//
//  Created by Hao Zhang on 07/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "ThreadsPool.h"

@implementation ThreadsPool
NSOperationQueue *queue =nil;
//All of the threads for the apps can be added into the threads pool by this method.
//The threads pool will help you mange the threads.
+ (void) startService:(NSOperation *) operation
{
    @synchronized(self)
    {
        if (queue == nil)
        {
            queue = [[NSOperationQueue alloc] init];
        }
        [queue addOperation:operation];
    }
}
@end
