//
//  NSArray+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "NSArray+A_Extension.h"
#import "A_CollectionHelper.h"
#import "A_JSONHelper.h"

@implementation NSArray (A_Extension)

- (NSDictionary*) A_CombineKeys: (NSArray*)keys {
    return [A_CollectionHelper A_CombineArraysToDictionary:keys Values:self];
}
- (NSDictionary*) A_CombineValues: (NSArray*)values {
    return [A_CollectionHelper A_CombineArraysToDictionary:self Values:values];
}
- (NSData*) A_CovertToJSONData {
    return [A_JSONHelper A_ConvertArrayToData:self];
}
- (NSString*) A_CovertToJSONString {
    return [A_JSONHelper A_ConvertArrayToJSON:self];
}

@end
