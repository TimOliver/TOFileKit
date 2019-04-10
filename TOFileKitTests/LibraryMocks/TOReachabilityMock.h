//
//  TOReachabilityMocks.h
//  TOFileKitTests
//
//  Created by Tim Oliver on 11/4/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOReachability.h"

NS_ASSUME_NONNULL_BEGIN

/**
 When testing other classes that rely on reachability, this mock
 subclass overrides all of the functionality needed to test specific use cases.
*/
@interface TOReachabilityMock : TOReachability

/** Mamually trigger a status change on demand */
- (void)triggerStatusChange:(TOReachabilityStatus)status;

@end

NS_ASSUME_NONNULL_END
