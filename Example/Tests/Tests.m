//
//  GLCKeychainWrapperTests.m
//  GLCKeychainWrapperTests
//
//  Created by Nico du Plessis on 12/24/2015.
//  Copyright (c) 2015 Nico du Plessis. All rights reserved.
//

@import XCTest;

#import "GLCKeychainWrapper.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMyTest
{
    GLCKeychainWrapper *kc = [GLCKeychainWrapper new];
    [kc setData:nil forKey:@""];
}

@end

