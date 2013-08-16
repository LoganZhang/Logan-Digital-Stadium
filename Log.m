//
//  WriteTxt.m
//  Digi Stadium
//
//  This class is used to log some valuable for evaluation.
//
//  Created by Hao Zhang on 09/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "Log.h"
#import "CommonStrings.h"
#import "Base64.h"
@implementation Log
+(void) writeToTxt:(NSString *) str
{
    @synchronized(self)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if([paths count] > 0)
        {
            NSString *path = [[paths objectAtIndex: 0] stringByAppendingPathComponent: @"log.txt"];
            NSError *writeError = nil;
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSString *string = [NSString stringWithFormat:@"%@ %@;",[self castDateToString:dat] ,str];
            NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
            if(content == nil)
            {
                content=@"";
            }
            content = [content stringByAppendingString:string];
            [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
            if(writeError !=nil)
            {
                NSLog(@"%@", writeError.localizedFailureReason);
            }
        }
    }
}
+(NSString *) castDateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd HH:mm"];
    NSString * ds = [dateFormatter stringFromDate:date];
    return ds;
}
+(void) uploadLog
{
    @synchronized(self)
    {
        NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if([paths count] > 0)
        {
            long timestamp=  [[NSDate date] timeIntervalSince1970];
            NSString *path = [[paths objectAtIndex: 0] stringByAppendingPathComponent: @"log.txt"];
            NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
            NSString * jsonString = [NSString stringWithFormat:@"data=[{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%ld\",\"%@\":\"%@\"}]",
                                     DEVICE_ID,udid,
                                     NAME,@"iOS",
                                     TYPE_STRING,@"",
                                     ENTRY,@"",
                                     TIMESTAMP,timestamp,
                                     EXTRA,content];
            NSLog(@"%@",jsonString);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //[self postToServer:jsonString];
            });
        }
        //anv9pans
    }
}
+(void)postToServer:(NSString *) post;
{
    @synchronized(self)
    {
        
        NSString *loginString = [NSString stringWithFormat:@"%@:%@", USERNAME, PASSWORD];
        NSString *encodedLoginData = [Base64 encode:[loginString dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *base64LoginData = [NSString stringWithFormat:@"Basic %@",encodedLoginData];
        
        NSURL *url=[NSURL URLWithString:LOG_URL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval:20.0];
        [request setHTTPMethod:@"POST"];
        [request setValue:base64LoginData forHTTPHeaderField:@"Authorization"];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        [request setHTTPBody:postData];
        
        NSError *requestError = nil;
        NSURLResponse *urlResponse = nil;
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
        if(requestError == nil)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            if([paths count] > 0)
            {
                NSString *path = [[paths objectAtIndex: 0] stringByAppendingPathComponent: @"log.txt"];
                NSString* content = @"";
                [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:NULL];
            }
        }
    }
}
@end