//
//  A_RESTRequest.h
//  A-IOSHelper
//
//  Created by Animax
//  Copyright (c) 2014 AnimaxStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Network enumeration
typedef NS_ENUM (NSInteger, A_NetworkRequestMethod) {
	A_Network_GET= 0,
	A_Network_POST,
	A_Network_PUT,
	A_Network_PATCH,
	A_Network_DELETE,
};

typedef NS_ENUM (NSInteger, A_NetworkParameterFormat) {
	A_Network_SendAsQuery= 0,
	A_Network_SendAsJSON,
	A_Network_SendAsDataForm,
};

#pragma mark - Upload data set -
@interface A_RESTRequestUploadDataSet : NSObject

+ (A_RESTRequestUploadDataSet *)A_Make:(NSData *)fileData fileName:(NSString *)filename;
+ (A_RESTRequestUploadDataSet *)A_Make:(NSData *)fileData fileName:(NSString *)filename fileKey:(NSString *)fileKey;

+ (A_RESTRequestUploadDataSet *)A_MakeWithImage:(UIImage *)image fileName:(NSString *)filename;
+ (A_RESTRequestUploadDataSet *)A_MakeWithImage:(UIImage *)image fileName:(NSString *)filename fileKey:(NSString *)fileKey;

@end

#pragma mark - Define blocks
typedef void (^A_RESTRequestCompliedBlock) (NSData *data, NSURLResponse *response, NSError *error);
typedef void (^A_RESTRequestDictionaryCompliedBlock) (NSDictionary *data, NSURLResponse *response, NSError *error);
typedef void (^A_RESTRequestArrayCompliedBlock) (NSArray *data, NSURLResponse *response, NSError *error);

typedef void (^A_RESTDidReceiveChallengeCompletionHandler) (NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential);
typedef void (^A_RESTDidReceiveChallenge) (NSURLSession *session, NSURLAuthenticationChallenge *challenge, A_RESTDidReceiveChallengeCompletionHandler completion);

#pragma mark - REST request -
@interface A_RESTRequest : NSObject

#pragma mark - Base params
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSDictionary *headers;
@property (strong, nonatomic) A_RESTRequestUploadDataSet *uploadDataSet;
@property (nonatomic) A_NetworkRequestMethod requestMethod;
@property (nonatomic) A_NetworkParameterFormat parameterFormat;

#pragma mark - Advanced optional params
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
- (A_RESTRequest *)A_Request:(A_RESTRequestCompliedBlock)block;
- (A_RESTRequest *)A_RequestDictionary:(A_RESTRequestDictionaryCompliedBlock)block;
- (A_RESTRequest *)A_RequestArray:(A_RESTRequestArrayCompliedBlock)block;

- (NSDictionary *)A_RequestDictionarySync;
- (NSArray *)A_RequestArraySync;

- (NSURLSessionTask *)A_GetURLSessionTask;

#pragma mark - Thread Operations
- (void)A_Suspend;
- (void)A_Resume;
- (void)A_Cancel;

@end
