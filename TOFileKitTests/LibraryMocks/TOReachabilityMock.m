//
//  TOReachabilityMocks.m
//  TOFileKitTests
//
//  Created by Tim Oliver on 11/4/19.
//  Copyright © 2019 Tim Oliver. All rights reserved.
//

#import "TOReachabilityMock.h"

@interface TOReachabilityMock ()

@property (nonatomic, assign) TOReachabilityStatus simulatedStatus;

@end

@implementation TOReachabilityMock

/** Override start and stop with no-ops so we never actually trigger a live instance */
- (BOOL)start { return YES; }
- (void)stop { }

- (void)triggerStatusChange:(TOReachabilityStatus)status
{
    _simulatedStatus = status;

    if (self.statusChangedHandler) {
        self.statusChangedHandler(_simulatedStatus);
    }

    if ([self.delegate respondsToSelector:@selector(reachability:didChangeStatusTo:)]) {
        [self.delegate reachability:self didChangeStatusTo:_simulatedStatus];
    }
}

- (TOReachabilityStatus)status
{
    return _simulatedStatus;
}

@end
