//
//  TestDataModel.h
//  A_IOSHelper
//
//  Created by Animax on 3/9/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <A_IOSHelper/A_IOSHelper.h>

@interface TestDataModel : A_DataModel

@property (retain, nonatomic) NSString* Name;
@property (retain, nonatomic) NSDate* CreateDate;
@property (nonatomic) NSInteger Index;
@property (retain, nonatomic) NSNumber* ID;

@end
