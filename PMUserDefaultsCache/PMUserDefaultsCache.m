//
//  PMUserDefaultsCache.m
//  Efteling
//
//  Created by ebone on 02-10-13.
//  Copyright (c) 2013 Lukkien. All rights reserved.
//

#import "PMUserDefaultsCache.h"

@interface PMUserDefaultsCache () {
    __weak NSUserDefaults *_userDefaults;
    NIMemoryCache *_cache;
}

@end

@implementation PMUserDefaultsCache

@synthesize cache=_cache;

- (id)init {
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        _cache = [[NIMemoryCache alloc] initWithCapacity:0];
        _groupedObjects = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)invalidateKey:(NSString *)key {
    @synchronized(self) {
        [_cache removeObjectWithName:key];
        for (NSString *relatedKey in [_groupedObjects valueForKey:key]) {
            [_cache removeObjectWithName:relatedKey];
        }
    }
}

- (void)makeSureToInvalidateKeys:(NSArray *)keys whenInvalidatingKey:(NSString *)key {
    [self->_groupedObjects setObject:keys forKey:key];
}

+ (PMUserDefaultsCache*) sharedInstance {
    static PMUserDefaultsCache *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[PMUserDefaultsCache alloc] init];
    });
    return shared;
}

+ (void)storeValue:(id)value forKey:(NSString *)key {
    PMUserDefaultsCache *instance = [self sharedInstance];
    [instance invalidateKey:key];
    [instance->_userDefaults setObject:value forKey:key];
}

+ (void)cacheValue:(id)value forKey:(NSString *)key {
    [self cacheValue:value forKey:key andInvalidateRelated:YES];
}

+ (void)cacheValue:(id)value forKey:(NSString *)key andInvalidateRelated:(BOOL)invalidateRelated {
    PMUserDefaultsCache *instance = [self sharedInstance];
    if (invalidateRelated) {
        [instance invalidateKey:key];
    }
    [instance->_cache storeObject:value withName:key];
}

+ (id)valueForKey:(NSString *)key {
    PMUserDefaultsCache *instance = [self sharedInstance];
    id someCacheObject = [instance->_cache objectWithName:key];
    if (!someCacheObject) {
        someCacheObject = [instance->_userDefaults objectForKey:key];
        if (someCacheObject) {
            [instance->_cache storeObject:someCacheObject withName:key];
        }
    }
    return someCacheObject;
}

@end
