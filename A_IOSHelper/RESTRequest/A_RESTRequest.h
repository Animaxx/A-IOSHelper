//
//  A_RESTRequest.h
//  A-IOSHelper
//
//  Created by Animax
//  Copyright (c) 2014 AnimaxStudio. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, A_NetworkRequestMethod) {
    A_Network_GET = 0,
    A_Network_POST,
    A_Network_PUT,
    A_Network_PATCH,
    A_Network_DELETE,
};

typedef NS_ENUM(NSInteger, A_NetworkParameterFormat) {
    A_Network_SendAsQuery = 0,
    A_Network_SendAsJSON,
    A_Network_SendAsDataForm,
};

typedef void(^requestCompliedBlock)(NSData *data, NSURLResponse *response, NSError *error);
typedef void(^requestDictionaryCompliedBlock)(NSDictionary *data, NSURLResponse *response, NSError *error);
typedef void(^requestArrayCompliedBlock)(NSArray *data, NSURLResponse *response, NSError *error);

@interface A_RESTRequestUploadDataSet : NSObject

+ (A_RESTRequestUploadDataSet *)A_Make:(NSData *)fileData fileName:(NSString *)filename;
+ (A_RESTRequestUploadDataSet *)A_Make:(NSData *)fileData fileName:(NSString *)filename fileKey:(NSString *)fileKey;

+ (A_RESTRequestUploadDataSet *)A_MakeWithImage:(UIImage *)image fileName:(NSString *)filename;
+ (A_RESTRequestUploadDataSet *)A_MakeWithImage:(UIImage *)image fileName:(NSString *)filename fileKey:(NSString *)fileKey;

@end

typedef void (^A_RESTDidReceiveChallenge)(NSURLSession *session, NSURLAuthenticationChallenge *challenge);

@interface A_RESTRequest : NSObject

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSDictionary *headers;
@property (strong, nonatomic) A_RESTRequestUploadDataSet *uploadDataSet;
@property (nonatomic) A_NetworkRequestMethod requestMethod;
@property (nonatomic) A_NetworkParameterFormat parameterFormat;

@property (copy, nonatomic) A_RESTDidReceiveChallenge didReceiveChallenge;

#pragma mark - Initialize methods
+ (A_RESTRequest *)A_Create:(NSString *)url;

+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method;
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method headers:(NSDictionary *)headers;
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method parameters:(NSDictionary *)parameters;
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method parameters:(NSDictionary *)parameters format:(A_NetworkParameterFormat)parameterFormat;
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters format:(A_NetworkParameterFormat)parameterFormat;

+ (A_RESTRequest *)A_Create:(NSString *)url upload:(A_RESTRequestUploadDataSet *)uploadSet;
+ (A_RESTRequest *)A_Create:(NSString *)url upload:(A_RESTRequestUploadDataSet *)uploadSet parameters:(NSDictionary *)parameters;
+ (A_RESTRequest *)A_Create:(NSString *)url upload:(A_RESTRequestUploadDataSet *)uploadSet headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters;

#pragma mark - Request Methods
- (A_RESTRequest *)A_Request:(requestCompliedBlock)block;
- (A_RESTRequest *)A_RequestDictionary:(requestDictionaryCompliedBlock)block;
- (A_RESTRequest *)A_RequestArray:(requestArrayCompliedBlock)block;

- (NSDictionary *)A_RequestDictionarySync;
- (NSArray *)A_RequestArraySync;

- (NSURLSessionTask *)A_GetURLSessionTask;

#pragma mark - Thread Operations
- (void)A_Suspend;
- (void)A_Resume;
- (void)A_Cancel;

@end

