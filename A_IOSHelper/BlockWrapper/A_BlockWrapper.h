//
//  A_BlockWrapper.h
//  A_IOSHelper
//
//  Created by Animax on 3/11/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_BlockWrapper : NSObject

+ (A_BlockWrapper*) A_Init: (void *)block;
- (void) A_Execute;
- (void) A_Execute: (id)obj;
- (void) A_Execute: (id)obj WithObj:(id)obj2;

@end
