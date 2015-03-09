//
//  A_DataModel.h
//  A_IOSHelper
//
//  Created by Animax on 2/22/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_DataModel : NSObject

- (NSDictionary*)A_Serialize;
+ (NSObject*)A_Deserialize: (NSDictionary*)Array;

- (NSString*)A_ConvertToJSON;
+ (NSObject*)A_ConvertFromJSON: (NSString*)JSON;

@end
