//
//  A_RESTRequest.h
//  A-IOSHelper
//
//  Created by Animax on 11/21/14.
//  Copyright (c) 2014 AnimaxStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface A_RESTRequest : NSObject

enum {
    A_Network_POST          = 1,
    A_Network_GET           = 2,
    A_Network_PUT           = 3,
    A_Network_DELETE        = 4
}; typedef NSUInteger A_NetworkRequestMethod;

enum {
    A_Network_SendAsQuery   = 1,
    A_Network_SendAsJSON    = 2,
}; typedef NSUInteger A_NetworkParameterFormat;


+ (NSData*) A_Request: (NSDictionary*)_parameters
                  URL: (NSString*)_URL
               Header: (NSDictionary*)_headers
               Method: (A_NetworkRequestMethod)_method
          ParamFormat: (A_NetworkParameterFormat)_format;

@end
