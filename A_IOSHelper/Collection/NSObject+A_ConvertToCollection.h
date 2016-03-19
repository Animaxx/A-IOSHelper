//
//  NSObject+A_ConvertToCollection.h
//  A_IOSHelper
//
//  Created by Animax Deng on 3/19/16.
//  Copyright © 2016 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "A_Dictionary.h"

@interface NSObject (A_ConvertToCollection)

- (NSDictionary<NSString *, id> *)A_ConvertToDictionary;
- (NSDictionary<NSString *, id> *)A_ConvertToDictionaryWithContent;

@end
