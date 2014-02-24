Cache lookups in userdefaults
-----------------------------

Since lookups in UserDefauts require disk-io they are slow.

In order to make UserDefaults more useable for storing frequently
Accessed application data, PMUserDefaultsCache adds a cache and
invalidate mechanism.

::

    // Store a value in user defaults and invalidate cache
    [PMUserDefaultsCache storeValue:@1 forKey:@"koe"];

    // Store a value in cache only, not persistent in userdefaults and invalidate cache.
    [PMUserDefaultsCache cacheValue:@1 forKey:@"koe"];

    // store a value in the cache but do not invalidate any related objects.
    [PMUserDefaultsCache cacheValue:@1 forKey:@"koe" andInvalidateRelated:NO];
    
    // set up relation between keys so that when one invalidates, the other are invalidated as well.
    [[PMUserDefaultsCache sharedInstance] makeSureToInvalidateKeys:@[@"henk"] whenInvalidatingKey:@"koe"];

    // invalidate key @"koe" which will invalidate key @"henk" as well.
    [[PMUserDefaultsCache sharedInstance] invalidateKey:@"koe"];

