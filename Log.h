//
//  WriteTxt.h
//  Digi Stadium
//
//  This class is used to log some valuable for evaluation.
//
//  Created by Hao Zhang on 09/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Log : NSObject
// write the str into /Resource/log.txt.
+(void) writeToTxt:(NSString *) str;
// upload the log string to the server.
+(void) uploadLog;
@end
