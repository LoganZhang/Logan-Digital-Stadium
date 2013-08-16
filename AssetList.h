//
//  AssetList.h
//  Digi Stadium
//
//  This is for the asset list.
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheData.h"
#import "CommonStrings.h"

@interface AssetList : NSObject
-(int) getCount;
-(CacheData *) getData:(NSString *)url;
-(CacheData *) updateList:(CacheData *)cacheData;
-(CacheData *) getObjectAtIndex:(int) i;
@end
