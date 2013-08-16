//
//  UtilityFunction.m
//  Digi Stadium
//
//  A set of utility functions
//
//  Created by Hao Zhang on 03/07/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "UtilityFunction.h"
#import "CJSONDeserializer.h"
#import "TweetData.h"
#import "Log.h"
#define MINUTE 60
#define TWO_MINUTE 120
#define HOUR 3600
#define DAY 86400
#define TWEET_NUM 2

@implementation UtilityFunction
int _height;
int _width;
// this method runs when the class is initilaizing.
- (id)init
{
    if ((self = [super init]) != NULL)
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        _height = screenHeight;
        _width = screenWidth;
    }
    return (self);
}

// news and players data is a bit large, so we will not send them to dtn by now.
-(BOOL)isNeedToSend:(NSString *) url
{
    if([url isEqualToString:PLAYERS_URL] || [url isEqualToString:NEWS_URL])
    {
        return false;
    }
    return true;
}
//log the request data for evaluation.
// the second variable t:
// 1 recieved request from dtn.
// 2 request which is created by user.
// 3 send request to dtn.
// 4 send request to internet.
-(void) logRequestData: (RequestData *) data type:(int) t
{
    NSString *logStr =  [@(t) description];
    [Log writeToTxt:logStr];
}
// log the cache data for evaluation.
// the second variable t:
// 5 recieved cache data from dtn
// 6 recieved cache data from internet
// 7 send cache data to dtn
// 8 recieved useful cache data from dtn
-(void) logCacheData: (CacheData *) data type:(int) t
{
    NSString *logStr =  [@(t) description];
    [Log writeToTxt:logStr];
}
// replace the quote slash and quote by some particular strings to avoid JSON error when it was decoded.
-(NSString *) encodeContent:(NSString *) string
{
    NSString * content = string;
    content = [content stringByReplacingOccurrencesOfString:@"\\\"" withString:QUOTE_SLASH];
    content = [content stringByReplacingOccurrencesOfString:@"\"" withString:QUOTE];
    return content;
}
//  return JSON strings to the original strings.
-(NSString *) decodeContent:(NSString *) string
{
    NSString * content = string;
    content = [content stringByReplacingOccurrencesOfString:QUOTE_SLASH withString:@"\\\""];
    content = [content stringByReplacingOccurrencesOfString:QUOTE withString:@"\""];
    return content;
}
// cast NSDate to string
-(NSString *) castDateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
    NSString * ds = [dateFormatter stringFromDate:date];
    return ds;
}
// cast string to NSDate
-(NSDate *) castStringToDate:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:string];
    return dateFromString;
}
//cast Request Data to JSON.
-(NSData *) castRequestDataToJsonData:(RequestData *) data
{
    NSString * jsonString = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\"}",
                             IDENTIFIER,data.identifier,
                             DATA_SOURCE,data.dataSource,
                             URL_STRING,data.url,
                             REQUEST_TIME,[self castDateToString:data.requestTime]];
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];

}
// cast Cache Data to JSON.
-(NSData *) castCacheDataToJsonData:(CacheData *) data
{
    NSString * content = data.content;
    if([data.url isEqualToString:FANSC_URL] ||[data.url isEqualToString:CLUBC_URL])
    {
        content = [self getReducedTweets:content];
    }
    content = [self encodeContent:content];
    NSString * jsonString = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\"}",
                             IDENTIFIER,data.identifier,
                             SOURCE,data.source,
                             JSON_NAME,data.jsonName,
                             URL_STRING,data.url,
                             UPDATE_TIME,[self castDateToString:data.updateTime],
                             CONTENT, content];
    
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
}
//decode JSON strings to Cache Data.
-(CacheData *) castStringToCacheData:(NSString *) string
{
    NSError *error;
    NSDictionary * l= [[CJSONDeserializer deserializer] deserialize:[string dataUsingEncoding:NSUTF8StringEncoding] error:&error];
    
    if(l == nil)
    {
        return nil;
    }
    CacheData * cacheData = [CacheData alloc];
    if([[l allKeys] containsObject:SOURCE])
    {
        cacheData.source = [l objectForKey:SOURCE];
        cacheData.identifier = [l objectForKey:IDENTIFIER];
        cacheData.jsonName = [l objectForKey:JSON_NAME];
        cacheData.url = [l objectForKey:URL_STRING];
        cacheData.updateTime = [self castStringToDate: [l objectForKey:UPDATE_TIME]];
        
        NSString * content = string;
        NSRange r= [content rangeOfString:SPECIAL_DECODE_STRING_FOR_CONTENT];
        if(r.length ==0)
        {
            return nil;
        }
        content = [content substringFromIndex:r.location+r.length];
        content = [content substringToIndex:content.length-2];
        cacheData.content =[self decodeContent:content];
        return cacheData;
    }
    return nil;
}
//decode JSON strings to Request Data.
-(RequestData *) castStringToRequestData:(NSString *) string
{
    NSError *error;
    NSDictionary * l= [[CJSONDeserializer deserializer] deserialize:[string dataUsingEncoding:NSUTF8StringEncoding] error:&error];
    if(l == nil)
    {
        return nil;
    }
    RequestData * requestData = [RequestData alloc];
    if([[l allKeys] containsObject:DATA_SOURCE])
    {
        requestData.url = [l objectForKey:URL_STRING];
        requestData.identifier = [l objectForKey:IDENTIFIER];
        requestData.dataSource = [l objectForKey:DATA_SOURCE];
        requestData.requestTime = [self castStringToDate: [l objectForKey:REQUEST_TIME]];
        return requestData;
    }
    
    return nil;
}
// In order to reduce the pressure of bluetooth.
// only get 2 or 3 tweets and process the tweets by removing the image data.
-(NSString *) getReducedTweets:(NSString *) content
{
    NSString * newString = @"[";
    NSError *error;
    NSArray * list= [[CJSONDeserializer deserializer] deserializeAsArray:[content dataUsingEncoding:NSUTF8StringEncoding] error:&error];
    
    if(list == nil)
    {
        return nil;
    }
    
    for(int i=0;i<list.count && i<TWEET_NUM;i++)
    {
        NSDictionary *l = list[i];
        TweetData * td = [TweetData alloc];
        NSDictionary * user = [l objectForKey:@"user"];
        td.name = [user objectForKey:@"name"];
        td.nickname = [user objectForKey:@"screenName"];
        td.realtime = [l objectForKey:@"createdAt"];
        td.tweet = [l objectForKey:@"text"];
        NSString * itemString = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":{\"%@\":\"%@\",\"%@\":\"%@\"}},",
                                 CREATED_AT,td.realtime,
                                 TEXT,td.tweet,
                                 USER,
                                 SCREEN_NAME,td.nickname,
                                 NAME,td.name];
        newString = [newString stringByAppendingString:itemString];
    }
    newString = [newString substringToIndex:newString.length-1];
    newString = [newString stringByAppendingString:@"]"];
    return newString;
}
//get the friendly time string. For example, "17/08/2012" will map to "1 years ago".
-(NSString *)getScreenTime:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm:ss a"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:time];
    NSTimeInterval late=[dateFromString timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval gap=now-late;
    double seconds = gap;
    
    if(seconds<7)
    {
        return @"now";
    }
    
    if(seconds < MINUTE)
    {
        int n =  floor(seconds);
        return  [[@(n) stringValue] stringByAppendingString:@"s"];
    }
    
    if(seconds < TWO_MINUTE)
    {
        return @"1m";
    }
    
    if(seconds < HOUR)
    {
        int n =  floor(seconds / MINUTE);
        return [[@(n) stringValue] stringByAppendingString:@"m"];
    }
    
    if(seconds < 2*HOUR)
    {
        return @"1h";
    }
    
    if(seconds < DAY)
    {
        int n =  floor(seconds / HOUR);
        return [[@(n) stringValue] stringByAppendingString:@"h"];
    }
    
    if(seconds < 2*DAY)
    {
        return @"1d";
    }
    
    if(seconds<DAY*365)
    {
        int n =  floor(seconds / DAY);
        return [[@(n) stringValue] stringByAppendingString:@"d"];
    }
    else
    {
        return @"1y+";
    }
}
//get the width of the device.
-(int) getDeviceWidth
{
    return _width;
}
//get the height of the device.
-(int) getDeviceHeigt
{
    return _height;
}
//get the name of the device. (iPad, iPhone 4, iPhone 5,iPad Mini)
-(NSString *) getDeviceName
{
    if(_width == 320)
    {
        return @"iphone";
    }
    
    if(_width == 768)
    {
        return @"mini";
    }
    
    else
    {
        return @"ipad";
    }
}
@end
