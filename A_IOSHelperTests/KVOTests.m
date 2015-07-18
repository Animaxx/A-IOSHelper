//
//  KVOTest.m
//  A_IOSHelper
//
//  Created by Animax on 5/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSObject+A_KVO_Extension.h"
#import "TestDataModel.h"

@interface ExampleModel : A_DataModel
@property (strong, nonatomic) TestDataModel *model;
@property (nonatomic) int times;
@end

@implementation ExampleModel
-(instancetype)init {
    if ((self = [super init])) {
        self.model = [[TestDataModel alloc] init];
    }
    return self;
}
//-(void)dealloc {
//    [self A_RemoveObservings];
//    NSLog(@"Dealloc");
//}
@end

@interface KVOTests : XCTestCase

@end

@implementation KVOTests

- (void) testRemove {
    TestDataModel *_model = [[TestDataModel alloc] init];
    [_model A_AddObserver:@"Name" block:^(NSObject *itself, NSDictionary *change) {
        XCTAssertTrue([[change objectForKey:@"new"] isEqualToString:@"A"]);
    }];
    
    [_model setName:@"A"];
    [_model setName:@"A"];
    [_model A_RemoveObserver:@"Name"];
//    [_model setName:@"B"];
}

- (void) testDuplicateObserve {
    TestDataModel *_model = [[TestDataModel alloc] init];
    [_model A_AddObserver:@"Name" block:^(NSObject *itself, NSDictionary *change) {
        XCTAssertTrue([[change objectForKey:@"new"] isEqualToString:@"A"]);
    }];
    [_model A_AddObserver:@"Name" block:^(NSObject *itself, NSDictionary *change) {
        XCTAssertTrue([[change objectForKey:@"new"] isEqualToString:@"A"]);
    }];
    
    [_model setName:@"A"];
}

- (void) testObserveProperty {
    ExampleModel *_example = [[ExampleModel alloc] init];
    [_example A_AddObserver:@"model.ID" block:^(NSObject *itself, NSDictionary *change) {
        XCTAssertTrue([[change objectForKey:@"new"] isEqualToNumber:@(-1)]);
    }];
    
    [_example.model setID:@(-1)];
//    [_example A_RemoveAllObservers];
}


-(void) testBindWithConvert {
    ExampleModel *example = [[ExampleModel alloc] init];
    [example A_Bind:@"times" To:@"model.Name" Convert:^id(id value) {
        return [NSString stringWithFormat:@"The number is %@",value];
    }];
    
    example.times = 1;
    XCTAssertTrue(example.model.Name);
}

-(void) testBindWithoutConvert {
    ExampleModel *example = [[ExampleModel alloc] init];
    [example A_Bind:@"times" To:@"model.ID"];
    
    example.times = 1;
    XCTAssertTrue(example.model.ID > 0);
}
-(void) testBindWithoutConvertAndCrossType {
    ExampleModel *example = [[ExampleModel alloc] init];
    [example A_Bind:@"times" To:@"model.Name"];
    
    example.times = 1;
    XCTAssertNotNil(example.model.Name);
}
-(void) testBind2Obj {
    ExampleModel *example1 = [[ExampleModel alloc] init];
    ExampleModel *example2 = [[ExampleModel alloc] init];
    [example1 A_Bind:@"model.Name" ToTager:example2 AndKey:@"model.Name"];
    
    [example1.model setName:@"Test"];
    XCTAssertEqual(example1.model.Name, example2.model.Name);
    
    [example1 A_RemoveBinding:@"model.Name"];
    [example1.model setName:@"Demo"];
    XCTAssertNotEqual(example1.model.Name, example2.model.Name);
}
-(void) testBindNilObj {
    ExampleModel *example1 = [[ExampleModel alloc] init];
    ExampleModel *example2 = [[ExampleModel alloc] init];
    [example1 A_Bind:@"model.Name" ToTager:example2 AndKey:@"model.Name"];
    example2 = nil;
    [example1.model setName:@"Test"];
}


@end
