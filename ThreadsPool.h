//
//  ThreadsPool.h
//  Digi Stadium
//
//  This is a class for the threads pool.
//
//  Created by Hao Zhang on 07/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreadsPool : NSObject
//All of the threads for the apps can be added into the threads pool by this method.
//The threads pool will help you mange the threads.
+ (void) startService:(NSOperation *) operation;
@end
