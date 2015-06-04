//
//  A_MappingMap.h
//  A_IOSHelper
//
//  Created by Animax Deng on 6/3/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^mapElementBlock)(id input);

@interface A_MappingMap : NSObject

@property (readonly, nonatomic) Class BindClass;
@property (readonly, nonatomic) Class ToClass;

+ (A_MappingMap*) A_InitBind:(Class)bindClass To:(Class)toClass;
- (A_MappingMap*)A_AddMemeber: (NSString*)key To:(NSString*)to Convert:(mapElementBlock)block;

@end
