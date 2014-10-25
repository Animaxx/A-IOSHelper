//
//  A_HtmlHelper.h
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_HtmlHelper : NSObject

+ (NSString*)A_HtmlTemplate:(NSString*)htmlUrl Folder:(NSString*)folder;
+ (NSString*)A_HtmlTemplate:(NSString*)htmlUrl;

/*
 eg. html template is "<html><<body>{content_1}</body>/html>"
     content should be key="content_1" and value="something" 
     than the result will be "<html><<body>something</body>/html>"
 */
+ (NSString*)A_HtmlFillContent:(NSString*)htmlTemplate Content:(NSDictionary*)content;
+ (NSString*)A_HtmlWithContent:(NSString*)htmlUrl Folder:(NSString*)folder Content:(NSDictionary*)content;

@end
