//
//  UtilityFunction.h
//  Digi Stadium
//
//  A set of utility functions
//
//  Created by Hao Zhang on 03/07/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestData.h"
#import "CacheData.h"
#import "CommonStrings.h"

@interface UtilityFunction : NSObject{
}
//get the width of the device.
-(int) getDeviceWidth;
//get the height of the device.
-(int) getDeviceHeigt;
//get the name of the device. (iPad, iPhone 4, iPhone 5,iPad Mini)
-(NSString *) getDeviceName;
//get the friendly time string.
//For example, "17/08/2012" will map to "1 years ago".
-(NSString *)getScreenTime:(NSString *)time;
//cast Request Data to JSON.
-(NSData *) castRequestDataToJsonData:(RequestData *) data;
//cast Cache Data to JSON.
-(NSData *) castCacheDataToJsonData:(CacheData *) data;
//decode JSON strings to Request Data.
-(RequestData *) castStringToRequestData:(NSString *) string;
//decode JSON strings to Cache Data.
-(CacheData *) castStringToCacheData:(NSString *) string;
//cast date to string
-(NSString *) castDateToString:(NSDate *)date;
//log the request data for evaluation.
// the second variable t:
// 1 recieved request from dtn.
// 2 request which is created by user.
// 3 send request to dtn.
// 4 send request to internet.
-(void) logRequestData: (RequestData *) data type:(int) t;
//log the cache data for evaluation.
// the second variable t:
// 5 recieved cache data from dtn
// 6 recieved cache data from internet
// 7 send cache data to dtn
// 8 recieved useful cache data from dtn
-(void) logCacheData: (CacheData *) data type:(int) t;
// news and players data is a bit large, so we will not send them to dtn by now.
-(BOOL)isNeedToSend:(NSString *) url;
@end
