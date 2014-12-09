//
//  A_HtmlHelper.m
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import "A_HtmlHelper.h"

@implementation A_HtmlHelper

+ (NSString*)A_HtmlTemplate:(NSString*)htmlUrl Folder:(NSString*)folder {
    if (htmlUrl) {
        NSError *error;
        NSBundle *thisBundle = [NSBundle mainBundle];
        NSString *url = [thisBundle pathForResource:htmlUrl ofType:nil inDirectory: folder];
        
        NSURL *instructionsURL = [NSURL fileURLWithPath:url];
        
        return [NSString stringWithContentsOfURL:instructionsURL encoding:NSUTF8StringEncoding error:&error];
    }
    else {
        return [NSString string];
    }
}

+ (NSString*)A_HtmlTemplate:(NSString*)htmlUrl {
    return [A_HtmlHelper A_HtmlTemplate:htmlUrl Folder:@"www"];
}


+ (NSString*)A_HtmlFillContent:(NSString*)htmlTemplate Content:(NSDictionary*)content {
    for (id key in [content allKeys]) {
        
        NSString* _key = [NSString stringWithFormat:@"{%@}",[key string]];
        
        htmlTemplate = [htmlTemplate stringByReplacingOccurrencesOfString:_key
                                                               withString:[content objectForKey:key]];
    }
    
    return htmlTemplate;
}


+ (NSString*)A_HtmlWithContent:(NSString*)htmlUrl Folder:(NSString*)folder Content:(NSDictionary*)content {
    NSString* _htmlTemplate = [A_HtmlHelper A_HtmlTemplate:htmlUrl Folder:folder];
    return [A_HtmlHelper A_HtmlFillContent:_htmlTemplate Content:content];
}

@end
