//
//  NSString+A_Extension.m
//  A_IOSHelper
//
//  Created by Animax on 3/15/15.
//  Copyright (c) 2015 AnimaxDeng. All rights reserved.
//

#import "A_Datetime.h"
#import "A_JSONHelper.h"
#import "A_Mapper.h"
#import "A_StringHelper.h"
#import "NSString+A_Extension.h"

@implementation NSString (A_Extension)

- (BOOL)A_CheckEmpty {
	return [A_StringHelper A_CheckEmpty:self];
}
- (NSString *)A_StripHTMLTag {
	return [A_StringHelper A_StripHTMLTag:self];
}
- (NSString *)A_TrimString {
	return [A_StringHelper A_TrimString:self];
}
- (BOOL)A_ValidateEmail {
	return [A_StringHelper A_ValidateEmail:self];
}
- (BOOL)A_MatchRegex:(NSString *)regex {
	return [A_StringHelper A_Match:self WithRegex:regex];
}
- (NSDate *)A_ToDate:(NSString *)format {
	return [A_Datetime A_StringToDate:self Format:format];
}
- (NSDate *)A_ToDateByDetailFormat {
	return [A_Datetime A_StringToDate:self Format:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
}

- (NSDictionary *)A_CovertJSONToDictionary {
	return [A_JSONHelper A_ConvertJSONToDictionary:self];
}
- (NSArray *)A_CovertJSONToArray {
	return [A_JSONHelper A_ConvertJSONToArray:self];
}

- (id)A_ConvertJSONToMappedClassWithName:(NSString *)className {
    NSDictionary *jsonDic = [A_JSONHelper A_ConvertJSONToDictionary:self];
    A_MappingMap *map = [[A_Mapper A_Instance] A_GetMapByName:@"NSDictionary" To:className];
    if (jsonDic && map) {
        return [map A_ConvertData:jsonDic];
    } else {
        return nil;
    }
}
- (NSArray *)A_ConvertJSONToMappedArrayWithClassName:(NSString *)className {
    NSArray *jsonArr = [A_JSONHelper A_ConvertJSONToArray:self];
    A_MappingMap *map = [[A_Mapper A_Instance] A_GetMapByName:@"NSDictionary" To:className];
    if (jsonArr && map) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (NSDictionary *item in jsonArr) {
            [result addObject:[map A_ConvertData:item]];
        }
        return result;
    } else {
        return @[];
    }
}

- (id)A_ConvertJSONToMappedClass:(Class)classType {
    NSDictionary *jsonDic = [A_JSONHelper A_ConvertJSONToDictionary:self];
    A_MappingMap *map = [[A_Mapper A_Instance] A_GetMap:[NSDictionary class] To:classType];
    if (jsonDic && map) {
        return [map A_ConvertData:jsonDic];
    } else {
        return nil;
    }
}
- (NSArray *)A_ConvertJSONToMappedArrayWithClass:(Class)classType {
    NSArray *jsonArr = [A_JSONHelper A_ConvertJSONToArray:self];
    A_MappingMap *map = [[A_Mapper A_Instance] A_GetMap:[NSDictionary class] To:classType];
    if (jsonArr && map) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (NSDictionary *item in jsonArr) {
            [result addObject:[map A_ConvertData:item]];
        }
        return result;
    } else {
        return @[];
    }
}

- (id)A_ConvertJSONToMappedInstance:(id)obj {
    NSDictionary *jsonDic = [A_JSONHelper A_ConvertJSONToDictionary:self];
    A_MappingMap *map = [[A_Mapper A_Instance] A_GetMap:[NSDictionary class] To:[obj class]];
    if (jsonDic && map) {
        [map A_ConvertData:jsonDic To:obj];
        return obj;
    } else {
        return obj;
    }
}

- (id)A_ConvertJSONToObjectWithMap:(A_MappingMap *)map {
    NSDictionary *jsonDic = [A_JSONHelper A_ConvertJSONToDictionary:self];
    if (jsonDic && map) {
        return [map A_ConvertData:jsonDic];
    } else {
        return nil;
    }
}
- (id)A_ConvertJSONToArrayWithMap:(A_MappingMap *)map {
    NSArray *jsonArr = [A_JSONHelper A_ConvertJSONToArray:self];
    if (jsonArr && map) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (NSDictionary *item in jsonArr) {
            [result addObject:[map A_ConvertData:item]];
        }
        return result;
    } else {
        return @[];
    }
}

@end
