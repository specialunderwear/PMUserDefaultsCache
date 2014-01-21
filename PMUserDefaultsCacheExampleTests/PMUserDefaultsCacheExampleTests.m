//
//  PMUserDefaultsCacheExampleTests.m
//  PMUserDefaultsCacheExampleTests
//
//  Created by ebone on 21-01-14.
//  Copyright (c) 2014 PermanentMarkers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PMUserDefaultsCache.h"

@interface PMUserDefaultsCacheTests : XCTestCase

@end

@implementation PMUserDefaultsCacheTests

- (void)tearDown
{
    // Tear-down code here.
    [[PMUserDefaultsCache sharedInstance]->_groupedObjects removeAllObjects];
    [[PMUserDefaultsCache sharedInstance] invalidateKey:@"koe"];
    [[PMUserDefaultsCache sharedInstance] invalidateKey:@"henk"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"koe"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"henk"];
    [super tearDown];
}

- (void)testCachedValue {
    [PMUserDefaultsCache cacheValue:@1 forKey:@"koe"];
    [PMUserDefaultsCache cacheValue:@11 forKey:@"henk"];
    XCTAssertEqualObjects([PMUserDefaultsCache valueForKey:@"koe"], @1, @"value can be stored correctly");
    XCTAssertEqualObjects([PMUserDefaultsCache valueForKey:@"henk"], @11, @"value can be stored correctly");
}

- (void)testStoredValue {
    [PMUserDefaultsCache storeValue:@1 forKey:@"koe"];
    [[PMUserDefaultsCache sharedInstance] invalidateKey:@"koe"];
    XCTAssertEqualObjects([PMUserDefaultsCache valueForKey:@"koe"], @1, @"value is stored in userdefaults so invalidating cache only has no effect on result");
    [[NSUserDefaults standardUserDefaults] setObject:@11 forKey:@"koe"];
    XCTAssertEqualObjects([PMUserDefaultsCache valueForKey:@"koe"], @1, @"Changing value stored in NSUSerdefaults changes nothing because value is cached automatically.");
    [[PMUserDefaultsCache sharedInstance] invalidateKey:@"koe"];
    XCTAssertEqualObjects([PMUserDefaultsCache valueForKey:@"koe"], @11, @"After invalidating cached value, the changed value in userdefaults is shown");}

- (void)testInvalidate {
    [self testCachedValue];
    [[PMUserDefaultsCache sharedInstance] invalidateKey:@"koe"];
    XCTAssertNil([PMUserDefaultsCache valueForKey:@"koe"], @"invalidating a cached item should make the cache respond with nil");
}

- (void)testInvalidateRelated {
    [self testCachedValue];
    [[PMUserDefaultsCache sharedInstance] makeSureToInvalidateKeys:@[@"henk"] whenInvalidatingKey:@"koe"];
    [[PMUserDefaultsCache sharedInstance] invalidateKey:@"koe"];
    XCTAssertNil([PMUserDefaultsCache valueForKey:@"koe"], @"invalidating a cached item should make the cache respond with nil");
    XCTAssertNil([PMUserDefaultsCache valueForKey:@"henk"], @"invalidating a cached item should make the related items get invalidated as well");
}

- (void)testInvalidateByNilling {
    [self testCachedValue];
    [PMUserDefaultsCache storeValue:nil forKey:@"koe"];
    XCTAssertNil([[NSUserDefaults standardUserDefaults] objectForKey:@"ikbestaniet"], @"Not existing is being nil");
    XCTAssertNil([[NSUserDefaults standardUserDefaults] objectForKey:@"koe"], @"nilling is deleting");
    XCTAssertNil([PMUserDefaultsCache valueForKey:@"koe"], @"also in mem it is nil now");
}

@end
