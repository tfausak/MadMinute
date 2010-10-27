#import <GHUnitIOS/GHUnitIOS.h>

@interface Test : GHTestCase { }
@end

@implementation Test

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
    return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}

- (void)test1 {
    GHAssertTrue(TRUE, @"This one should succeed.");
}

- (void)test2 {
    GHAssertFalse(TRUE, @"This one should fail.");
}

@end