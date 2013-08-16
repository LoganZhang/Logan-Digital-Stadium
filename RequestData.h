//
//  RequestData.h
//  Digi Stadium
//
//  Data Model for Request Data which contains request url and other information
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestData : NSObject
//the time of creating the request.
@property (strong, nonatomic) NSDate * requestTime;
//url for service.
@property (strong, nonatomic) NSString* url;
//the source where the request came from, such as users themselves or peers
@property (strong, nonatomic) NSString* dataSource;
//unique identifier for the request
@property (strong, nonatomic) NSString* identifier;
//this is used to mark if the data has been sent to DTN for reducing duplicated messages.
@property (strong, nonatomic) NSString* done;
@end
