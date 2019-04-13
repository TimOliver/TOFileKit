//
//  TOFileLocalServiceDiscoveryMock.m
//
//  Copyright 2019 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TOFileLocalServiceDiscoveryMock.h"

@interface TOFileLocalServiceDiscoveryMock ()

@property (nonatomic, strong) NSMutableArray *mockedServices;

@end

@implementation TOFileLocalServiceDiscoveryMock

- (void)triggerServicesFoundWithNumber:(NSInteger)serviceCount
{
    // Reset the array
    self.mockedServices = [NSMutableArray array];

    // Trigger the removed block
    if (self.servicesListRemovedHandler) {
        self.servicesListRemovedHandler(nil);
    }

    // Fill the array with the number of services
    for (NSInteger i = 0; i < serviceCount; i++) {
        NSString *name = [NSString stringWithFormat:@"Test %d", i+1];
        NSNetService *service = [[NSNetService alloc] initWithDomain:@"" type:@"_smb._tcp." name:name];
        [self.mockedServices addObject:service];
    }

    if (self.servicesListAddedHandler) {
        self.servicesListAddedHandler(self.mockedServices.lastObject);
    }
}

- (NSArray *)services
{
    return _mockedServices;
}

- (BOOL)isRunning { return YES; }

// Override these methods so they don't touch the real code
- (void)start { }
- (void)stop { }
- (void)reset { }

@end
