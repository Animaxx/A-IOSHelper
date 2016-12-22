//
//  A_RESTRequest.h
//  A-IOSHelper
//
//  Created by Animax
//  Copyright (c) 2014 AnimaxStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
+ (A_RESTRequestUploadDataSet *)A_MakeWithImage:(UIImage *)image compressRate:(float)rate fileName:(NSString *)filename fileKey:(NSString *)fileKey;

@end

#pragma mark - Define blocks
typedef void (^A_RESTRequestCompliedBlock) (NSData *data, NSURLResponse *response, NSError *error);
typedef void (^A_RESTRequestDownloadCompliedBlock) (NSURL *temporaryURL, NSURLResponse *response, NSError *error);

typedef void (^A_RESTRequestDictionaryCompliedBlock) (NSDictionary *data, NSURLResponse *response, NSError *error);
typedef void (^A_RESTRequestArrayCompliedBlock) (NSArray *data, NSURLResponse *response, NSError *error);

typedef void (^A_RESTDidReceiveChallengeCompletionHandler) (NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential);
typedef void (^A_RESTDidReceiveChallenge) (NSURLSession *session, NSURLAuthenticationChallenge *challenge, A_RESTDidReceiveChallengeCompletionHandler completion);

typedef void (^A_RESTDidSendData) (NSURLSession *session, NSURLSessionTask *dataTask, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);
typedef void (^A_RESTDidReceiveData) (NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data);

#pragma mark - REST request -
@interface A_RESTRequest : NSObject

#pragma mark - Base params
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDictionary<NSString *, NSObject *> *parameters;
@property (strong, nonatomic) NSDictionary<NSString *, NSString *> *headers;
@property (strong, nonatomic) A_RESTRequestUploadDataSet *uploadDataSet;
@property (nonatomic) A_NetworkRequestMethod requestMethod;
@property (nonatomic) A_NetworkParameterFormat parameterFormat;

/**
 *  Request timeout, seconds, default 60s
 */
@property (nonatomic) double timeout;


#pragma mark - Advanced optional params
@property (copy, nonatomic) A_RESTDidReceiveChallenge didReceiveChallengeBlock;
@property (copy, nonatomic) A_RESTDidSendData didSendDataBlock;
@property (copy, nonatomic) A_RESTDidReceiveData didReceiveDataBlock;

#pragma mark - Initialize methods
+ (A_RESTRequest *)A_Create:(NSString *)url;

+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method;
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method headers:(NSDictionary<NSString *, NSString *> *)headers;
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method parameters:(NSDictionary<NSString *, NSObject *> *)parameters;
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method parameters:(NSDictionary<NSString *, NSObject *> *)parameters format:(A_NetworkParameterFormat)parameterFormat;
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method headers:(NSDictionary<NSString *, NSString *> *)headers parameters:(NSDictionary<NSString *, NSObject *> *)parameters format:(A_NetworkParameterFormat)parameterFormat;

+ (A_RESTRequest *)A_Create:(NSString *)url upload:(A_RESTRequestUploadDataSet *)uploadSet;
+ (A_RESTRequest *)A_Create:(NSString *)url upload:(A_RESTRequestUploadDataSet *)uploadSet parameters:(NSDictionary<NSString *, NSObject *> *)parameters;
+ (A_RESTRequest *)A_Create:(NSString *)url upload:(A_RESTRequestUploadDataSet *)uploadSet headers:(NSDictionary<NSString *, NSString *> *)headers parameters:(NSDictionary<NSString *, NSObject *> *)parameters;

#pragma mark - Event Blocks
- (A_RESTRequest *)A_SetDidReceiveChallengeBlock:(A_RESTDidReceiveChallenge)block;
- (A_RESTRequest *)A_SetDidReceiveDataBlock:(A_RESTDidReceiveData)block;
- (A_RESTRequest *)A_SetSendDataBlock:(A_RESTDidSendData)block;

#pragma mark - Excute Request Methods
- (NSURLSessionTask *)A_Request:(A_RESTRequestCompliedBlock)block;
- (NSURLSessionTask *)A_RequestDictionary:(A_RESTRequestDictionaryCompliedBlock)block;
- (NSURLSessionTask *)A_RequestArray:(A_RESTRequestArrayCompliedBlock)block;


/**
 Execute Download Task, didReceiveDataBlock params will be avaliable with this request.
 */
- (NSURLSessionTask *)A_RequestDownload:(A_RESTRequestDownloadCompliedBlock)block;
/**
 Execute Download Task, didReceiveDataBlock params will be avaliable with this request.
 */
- (NSURLSessionTask *)A_RequestDownloadTo:(NSString *)filePath withBlock:(A_RESTRequestDownloadCompliedBlock)block;

/**
 Execute Upload Task, didSendDataBlock params will be avaliable with these requests.
 */
- (NSURLSessionTask *)A_RequestUpload:(A_RESTRequestCompliedBlock)block;
/**
 Execute Upload Task, didSendDataBlock params will be avaliable with these requests.
 */
- (NSURLSessionTask *)A_RequestUploadAndReturnDictionary:(A_RESTRequestDictionaryCompliedBlock)block;
/**
 Execute Upload Task, didSendDataBlock params will be avaliable with these requests.
 */
- (NSURLSessionTask *)A_RequestUploadAndReturnArray:(A_RESTRequestArrayCompliedBlock)block;


- (NSDictionary *)A_RequestDictionarySync;
- (NSArray *)A_RequestArraySync;

- (NSURLSessionTask *)A_GetURLSessionTask;

#pragma mark - Thread Operations
- (void)A_Resume;
- (void)A_Suspend;
- (void)A_Cancel;

@end
