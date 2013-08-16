//
//  TweetData.h
//  Digi Stadium
//
//  Data Model for tweets.
//
//  Created by Hao Zhang on 01/07/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetData : NSObject

@property (strong, nonatomic) NSString * name ;
@property (strong, nonatomic) NSString * time;
@property (strong, nonatomic) NSString * realtime;
@property (strong, nonatomic) NSString* tweet;
@property (strong, nonatomic) NSString* nickname;
@property (strong, nonatomic) UIImage* image;

@end