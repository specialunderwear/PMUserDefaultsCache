Cache lookups in userdefaults
-----------------------------

Since lookups in UserDefauts require disk-io they are slow.

In order to make UserDefaults more useable for storing frequently
Accessed application data, PMUserDefaultsCache adds a cache and
invalidate mechanism.
