//
//  UIUpdateCentre.h
//  Digi Stadium
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventDelegate.h"
#import "AssetList.h"
#import "RequestCentre.h"

@interface UIUpdateCentre : NSObject
{
}
- (void)addDelegate:(id<EventDelegate>)target;
- (CacheData *)getUIContent:(NSString *)url onlyGetFromInternet:(BOOL) onlyInternet;
@end
