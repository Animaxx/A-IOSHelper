//
//  A_RESTRequest.h
//  A-IOSHelper
//
//  Created by Animax
//  Copyright (c) 2014 AnimaxStudio. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSUInteger, A_NetworkRequestMethod) {
    A_Network_POST          = 1,
    A_Network_GET           = 2,
    A_Network_PUT           = 3,
    A_Network_DELETE        = 4
};

typedef NS_ENUM(NSUInteger, A_NetworkParameterFormat) {
    A_Network_SendAsQuery   = 11,
    A_Network_SendAsJSON    = 12,
};

typedef void(^requestCompliedBlock)(NSData *data, NSURLResponse *response, NSError *error);

@interface A_RESTRequest : NSObject

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSDictionary *headers;
@property (nonatomic) A_NetworkRequestMethod requestMethod;
@property (nonatomic) A_NetworkParameterFormat parameterFormat;

+ (A_RESTRequest *)A_Create:(NSString *)url;
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method;
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method headers:(NSDictionary *)headers;
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method parameters:(NSDictionary *)parameters;
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method parameters:(NSDictionary *)parameters format:(A_NetworkParameterFormat)parameterFormat;
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters format:(A_NetworkParameterFormat)parameterFormat;





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
+ (NSDictionary*) A_GetDictionary: (NSString*)_URL;
+ (NSArray*) A_GetArray: (NSString*)_URL;

+ (NSDictionary*) A_GetDictionary: (NSString*)_URL
                       Parameters: (NSDictionary*)_parameters
                          Headers: (NSDictionary*)_headers;
+ (NSArray*) A_GetArray: (NSString*)_URL
             Parameters: (NSDictionary*)_parameters
                Headers: (NSDictionary*)_headers;

+ (NSDictionary*) A_PostQueryReturnDictionary: (NSString*)_URL
                                     Parameters: (NSDictionary*)_parameters
                                       Header: (NSDictionary*)_headers;
+ (NSArray*) A_PostQueryReturnArray: (NSString*)_URL
                         Parameters: (NSDictionary*)_parameters
                             Header: (NSDictionary*)_headers;

+ (NSDictionary*) A_PostJSONReturnDictionary: (NSString*)_URL
                                  Parameters: (NSDictionary*)_parameters
                                      Header: (NSDictionary*)_headers;
+ (NSArray*) A_PostJSONReturnArray: (NSString*)_URL
                        Parameters: (NSDictionary*)_parameters
                            Header: (NSDictionary*)_headers;



+ (NSDictionary*) A_UploadImage_Dictionary: (NSString*)_URL
                           QueryParameters: (NSDictionary*)_parameters
                                   Headers: (NSDictionary*)_headers
                                     Image: (UIImage*)_image
                                  FileName: (NSString*)_filename
                                   FileKey: (NSString*)_filekey;


@end

