//
//  CacheData.h
//  Digi Stadium
//
//
//  Data Model for Cache Data which contains JSON content, url and other information
//
//  Created by Hao Zhang on 15/06/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheData : NSObject{
}
//JSON content
@property (strong, nonatomic) NSString * content ;
//update time
@property (strong, nonatomic) NSDate * updateTime;
//url for each digital service
@property (strong, nonatomic) NSString* url;
//different json names map to different urls in /IOS/Supporting Files/CacheData.plist
@property (strong, nonatomic) NSString* jsonName;
//the source where the data come from. Such as DTN, Internet
@property (strong, nonatomic) NSString* source;
//the unique identifer for the Cache Data.
@property (strong, nonatomic) NSString* identifier;
//this is used to mark if the data has been sent to DTN for reducing duplicated messages.
@property (strong, nonatomic) NSString* done;
@end
