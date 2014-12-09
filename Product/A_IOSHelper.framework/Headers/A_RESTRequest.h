//
//  A_RESTRequest.h
//  A-IOSHelper
//
//  Created by Animax
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


#pragma mark - Methods For Construct
+ (NSData*) A_Request: (NSString*)_URL
           Parameters: (NSDictionary*)_parameters
              Headers: (NSDictionary*)_headers
               Method: (A_NetworkRequestMethod)_method
          ParamFormat: (A_NetworkParameterFormat)_format ;

+ (NSMutableURLRequest*) A_UploadRequestConstructor: (NSString*)_URL
                                    QueryParameters: (NSDictionary*)_parameters
                                     FormParameters: (NSDictionary*)_formparameters
                                            Headers: (NSDictionary*)_headers
                                               File: (NSData*)_filedata
                                           FileName: (NSString*)_filename
                                            FileKey: (NSString*)_filekey;

+ (NSData*) A_UploadImage: (NSString*)_URL
          QueryParameters: (NSDictionary*)_parameters
                  Headers: (NSDictionary*)_headers
                    Image: (UIImage*)_image
                 FileName: (NSString*)_filename
                  FileKey: (NSString*)_filekey;

+ (NSData*) A_UploadImageWithForm: (NSString*)_URL
                  QueryParameters: (NSDictionary*)_parameters
                   FormParameters: (NSDictionary*)_formparameters
                          Headers: (NSDictionary*)_headers
                            Image: (UIImage*)_image
                         FileName: (NSString*)_filename
                          FileKey: (NSString*)_filekey;

#pragma mark - Methods For Applicate

+ (NSDictionary*) A_GetJson_Dictionary: (NSString*)_URL
                            Parameters: (NSDictionary*)_parameters
                               Headers: (NSDictionary*)_headers;
+ (NSArray*) A_GetJson_Array: (NSString*)_URL
                  Parameters: (NSDictionary*)_parameters
                     Headers: (NSDictionary*)_headers ;

+ (NSDictionary*) A_PostForm_Dictionary: (NSString*)_URL
                             Parameters: (NSDictionary*)_parameters
                                 Header: (NSDictionary*)_headers;
+ (NSArray*) A_PostForm_Array: (NSString*)_URL
                   Parameters: (NSDictionary*)_parameters
                       Header: (NSDictionary*)_headers;

+ (NSDictionary*) A_PostJSON_Dictionary: (NSString*)_URL
                             Parameters: (NSDictionary*)_parameters
                                 Header: (NSDictionary*)_headers;
+ (NSArray*) A_PostJSON_Array: (NSString*)_URL
                   Parameters: (NSDictionary*)_parameters
                       Header: (NSDictionary*)_headers;

+ (NSDictionary*) A_UploadImage_Dictionary: (NSString*)_URL
                           QueryParameters: (NSDictionary*)_parameters
                                   Headers: (NSDictionary*)_headers
                                     Image: (UIImage*)_image
                                  FileName: (NSString*)_filename
                                   FileKey: (NSString*)_filekey;


@end

