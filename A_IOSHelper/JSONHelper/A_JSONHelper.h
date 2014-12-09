//
//  A_JSONHelper.h
//  A-IOSHelper
//
//  Created by Animax
//  Copyright (c) 2014 AnimaxStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_JSONHelper : NSObject

+ (NSDictionary*)A_ConvertJSONToDictionary: (NSString*)JSONStr;
+ (NSArray*)A_ConvertJSONToArray: (NSString*)JSONStr;

+ (NSString*)A_ConvertDictionaryToJSON: (NSDictionary*)Dict;
+ (NSString*)A_ConvertArrayToJSON: (NSArray*)Arr;

+ (NSData*)A_ConvertDictionaryToData: (NSDictionary*)Dict;
+ (NSData*)A_ConvertArrayToData: (NSArray*)Arr;

+ (NSDictionary*)A_ConvertJSONDataToDictionary: (NSData*)JSONData;
+ (NSArray*)A_ConvertJSONDataToArray: (NSData*)JSONData;

@end
