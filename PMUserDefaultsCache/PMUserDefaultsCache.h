//
//  PMUserDefaultsCache.h
//  Efteling
//
//  Created by ebone on 02-10-13.
//  Copyright (c) 2013 Lukkien. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nimbus/NimbusCore.h>


@interface PMUserDefaultsCache : NSObject {
    @public
    NSMutableDictionary *_groupedObjects;
}

+ (PMUserDefaultsCache*)sharedInstance;
+ (void)storeValue:(id)value forKey:(NSString *)key;
+ (void)cacheValue:(id)value forKey:(NSString *)key;
+ (void)cacheValue:(id)value forKey:(NSString *)key andInvalidateRelated:(BOOL)invalidateRelated;
+ (id)valueForKey:(NSString *)key;
- (void)invalidateKey:(NSString*)key;
- (void)makeSureToInvalidateKeys:(NSArray*)keys whenInvalidatingKey:(NSString*)key;

@property (readonly, nonatomic) NIMemoryCache *cache;

@end
