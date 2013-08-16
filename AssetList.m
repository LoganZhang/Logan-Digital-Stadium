//
//  AssetList.m
//  Digi Stadium
//
//  This is for the asset list.
//
//  Created by Hao Zhang on 06/08/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "AssetList.h"
#import "UtilityFunction.h"

@implementation AssetList
static AssetList *sharedCache = nil;
NSDictionary *_dataList;
NSMutableDictionary *_dateList;
NSMutableDictionary *_jsonList;
NSMutableDictionary *contentDic = nil;
UtilityFunction * utility;
+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedCache == nil)
        {
            utility = [[UtilityFunction alloc] init];
            sharedCache = [super allocWithZone:zone];
            contentDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
            NSString *pathj  = [self getPlistPath:@"JsonData.plist"];
            _jsonList = [[NSMutableDictionary alloc] initWithContentsOfFile:pathj];
            if(_jsonList ==nil)
            {
                [self copyPlistFileToDocument:@"JsonData"];
            }
            _jsonList = [[NSMutableDictionary alloc] initWithContentsOfFile:pathj];
            
            
            NSString *path  = [[NSBundle mainBundle] pathForResource:@"CacheData" ofType:@"plist"];
            _dataList = [[NSDictionary alloc] initWithContentsOfFile:path];
            
            
            NSString *pathu  = [self getPlistPath:@"UpdateTime.plist"];
            _dateList = [[NSMutableDictionary alloc] initWithContentsOfFile:pathu];
            if(_dateList ==nil)
            {
                [self copyPlistFileToDocument:@"UpdateTime"];
            }
            _dateList = [[NSMutableDictionary alloc] initWithContentsOfFile:pathu];
            return sharedCache;
        }
    }
    return sharedCache;
}

- (CacheData *) getObjectAtIndex:(int) i
{
    NSArray * array = contentDic.allValues;
    if(i<contentDic.count)
    {
        return [array objectAtIndex:i];
    }
    else
    {
        return nil;
    }
}

- (int) getCount
{
    return contentDic.count;
}

-(CacheData *)getContentFromLocal:(NSString *) url
{
    if([[_dataList allKeys] containsObject:url])
    {
        NSString *jsonName =  [_dataList objectForKey:url];
        CacheData *data = [CacheData alloc];
        data.updateTime = [self getUpdateTime:jsonName];
        data.content = [_jsonList objectForKey:jsonName];
        data.url = url;
        data.source = LOCAL_STRING;
        return data;
    }
    else{
        return nil;
    }
}

- (NSDate *)getUpdateTime:(NSString *)name
{
    if([[_dateList allKeys] containsObject:name])
    {
        NSDate *date =  [_dateList objectForKey:name];
        return date;
    }
    else
    {
        return nil;
    }
    
}

-(CacheData *) updateList:(CacheData *)cacheData
{
    if(cacheData.jsonName == nil)
    {
        cacheData.jsonName= [_dataList objectForKey:cacheData.url];
    }
    NSTimeInterval current=[[self getData:cacheData.url].updateTime timeIntervalSince1970]*1;
    NSTimeInterval new=[cacheData.updateTime timeIntervalSince1970]*1;
    NSTimeInterval gap=new-current;
    if(gap>1)
    {
        if([cacheData.source isEqualToString:DTN_STRING])
        {
            [utility logCacheData:cacheData type:8];
        }
        cacheData.done = @"";
        [self persist:cacheData];
        return cacheData;
    }
    return  [self getData:cacheData.url];
}

+ (NSString*) getPlistPath:(NSString*) filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:filename];
}

+ (void) copyPlistFileToDocument:(NSString *) fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getPlistPath:[fileName stringByAppendingString:@".plist"]];
    if( ![fileManager fileExistsAtPath:dbPath])
    {
        NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        BOOL copyResult = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if(!copyResult)
            NSAssert1(0, @"Failed to create writable plist file with message '%@'.", [error localizedDescription]);
    }
    
}

-(CacheData *) getData:(NSString *)url
{
    CacheData * result = [CacheData alloc];
    if([[contentDic allKeys] containsObject:url])
    {
        result =(CacheData *) [contentDic objectForKey:url];
    }
    else
    {
        result = [self getContentFromLocal:url];
        if(result !=nil)
        {
            [contentDic setObject:(CacheData *)result forKey:url];
        }
    }
    return result;
}

-(void) persist:(CacheData *) data
{
    [contentDic setObject:data forKey:data.url];
    [_jsonList setObject:data.content forKey:data.jsonName];
    [_dateList setObject:data.updateTime forKey:data.jsonName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    [_jsonList writeToFile:[documentsDir stringByAppendingPathComponent:@"JsonData.plist"] atomically:YES];
    [_dateList writeToFile:[documentsDir stringByAppendingPathComponent:@"UpdateTime.plist"] atomically:YES];
}
@end
