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

+ (nonnull A_RESTRequestUploadDataSet *)A_Make:(nonnull NSData *)fileData fileName:(nonnull NSString *)filename;
+ (nonnull A_RESTRequestUploadDataSet *)A_Make:(nonnull NSData *)fileData fileName:(nonnull NSString *)filename fileKey:(nullable NSString *)fileKey;

+ (nonnull A_RESTRequestUploadDataSet *)A_MakeWithImage:(nonnull UIImage *)image fileName:(nonnull NSString *)filename;
+ (nonnull A_RESTRequestUploadDataSet *)A_MakeWithImage:(nonnull UIImage *)image fileName:(nonnull NSString *)filename fileKey:(nullable NSString *)fileKey;
+ (nonnull A_RESTRequestUploadDataSet *)A_MakeWithImage:(nonnull UIImage *)image compressRate:(float)rate fileName:(nonnull NSString *)filename fileKey:(nullable NSString *)fileKey;

@end

#pragma mark - Define blocks
typedef void (^A_RESTRequestCompliedBlock) (NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error);
typedef void (^A_RESTRequestDownloadCompliedBlock) (NSURL *_Nullable emporaryURL, NSURLResponse *_Nullable response, NSError *_Nullable error);

typedef void (^A_RESTRequestDictionaryCompliedBlock) (NSDictionary<NSString *, id> *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error);
typedef void (^A_RESTRequestArrayCompliedBlock) (NSArray *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error);

typedef void (^A_RESTDidReceiveChallengeCompletionHandler) (NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *_Nullable credential);
typedef void (^A_RESTDidReceiveChallenge) (NSURLSession *_Nullable session, NSURLAuthenticationChallenge *_Nullable challenge, A_RESTDidReceiveChallengeCompletionHandler _Nullable completion);

typedef void (^A_RESTDidSendData) (NSURLSession *_Nullable session, NSURLSessionTask *_Nullable dataTask, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);
typedef void (^A_RESTDidReceiveData) (NSURLSession *_Nullable session, NSURLSessionTask *_Nullable dataTask, CGFloat progress);

#pragma mark - REST request -
@interface A_RESTRequest : NSObject

#pragma mark - Base params
@property (strong, nonatomic, nonnull) NSString *url;
@property (strong, nonatomic, nullable) NSDictionary<NSString *, id> *parameters;
@property (strong, nonatomic, nullable) NSDictionary<NSString *, NSString *> *headers;
@property (strong, nonatomic, nullable) A_RESTRequestUploadDataSet *uploadDataSet;
@property (nonatomic) A_NetworkRequestMethod requestMethod;
@property (nonatomic) A_NetworkParameterFormat parameterFormat;

/**
 *  Request timeout, seconds, default 60s
 */
@property (nonatomic) double timeout;


#pragma mark - Advanced optional params
@property (copy, nonatomic, nullable) A_RESTDidReceiveChallenge didReceiveChallengeBlock;
@property (copy, nonatomic, nullable) A_RESTDidSendData didSendDataBlock;
@property (copy, nonatomic, nullable) A_RESTDidReceiveData didReceiveDataBlock;

#pragma mark - Initialize methods
+ (nonnull A_RESTRequest *)A_Create:(nonnull NSString *)url;

+ (nonnull A_RESTRequest *)A_Create:(nonnull NSString *)url method:(A_NetworkRequestMethod)method;
+ (nonnull A_RESTRequest *)A_Create:(nonnull NSString *)url method:(A_NetworkRequestMethod)method headers:(nullable NSDictionary<NSString *, NSString *> *)headers;
+ (nonnull A_RESTRequest *)A_Create:(nonnull NSString *)url method:(A_NetworkRequestMethod)method parameters:(nullable NSDictionary<NSString *, id> *)parameters;
+ (nonnull A_RESTRequest *)A_Create:(nonnull NSString *)url method:(A_NetworkRequestMethod)method parameters:(nullable NSDictionary<NSString *, id> *)parameters format:(A_NetworkParameterFormat)parameterFormat;
+ (nonnull A_RESTRequest *)A_Create:(nonnull NSString *)url method:(A_NetworkRequestMethod)method headers:(nullable NSDictionary<NSString *, NSString *> *)headers parameters:(nullable NSDictionary<NSString *, id> *)parameters format:(A_NetworkParameterFormat)parameterFormat;

+ (nonnull A_RESTRequest *)A_Create:(nonnull NSString *)url upload:(nonnull A_RESTRequestUploadDataSet *)uploadSet;
+ (nonnull A_RESTRequest *)A_Create:(nonnull NSString *)url upload:(nonnull A_RESTRequestUploadDataSet *)uploadSet parameters:(nullable NSDictionary<NSString *, id> *)parameters;
+ (nonnull A_RESTRequest *)A_Create:(nonnull NSString *)url upload:(nonnull A_RESTRequestUploadDataSet *)uploadSet headers:(nullable NSDictionary<NSString *, NSString *> *)headers parameters:(nullable NSDictionary<NSString *, id> *)parameters;

#pragma mark - Event Blocks
/**
 Block for handling challenges as SSL; if not set, it will trust any SSL certificates.
 */
- (nonnull A_RESTRequest *)A_SetDidReceiveChallengeBlock:(nullable A_RESTDidReceiveChallenge)block;

- (nonnull A_RESTRequest *)A_SetDidReceiveDataBlock:(nullable A_RESTDidReceiveData)block;
- (nonnull A_RESTRequest *)A_SetSendDataBlock:(nullable A_RESTDidSendData)block;

#pragma mark - Excute Request Methods
- (nonnull NSURLSessionTask *)A_Request:(nullable A_RESTRequestCompliedBlock)block;
- (nonnull NSURLSessionTask *)A_RequestDictionary:(nullable A_RESTRequestDictionaryCompliedBlock)block;
- (nonnull NSURLSessionTask *)A_RequestArray:(nullable A_RESTRequestArrayCompliedBlock)block;

/**
 Execute Download Task, didReceiveDataBlock params will be avaliable with this request.

 @param block Download complied block
 @return SessionTask
 */
- (nonnull NSURLSessionTask *)A_RequestDownload:(nullable A_RESTRequestDownloadCompliedBlock)block;

/**
 Execute Download Task, didReceiveDataBlock params will be avaliable with this request.

 @param filename File in app's document folder
 @param block Download complied block
 @return Session Task
 */
- (nonnull NSURLSessionTask *)A_RequestDownloadToDocument:(nonnull NSString *)filename withBlock:(nullable A_RESTRequestDownloadCompliedBlock)block;


/**
 Execute Download Task, didReceiveDataBlock params will be avaliable with this request.

 @param url Full Path URL
 @param block Download complied block
 @return Session Task
 */
- (nonnull NSURLSessionTask *)A_RequestDownloadToUrl:(nonnull NSURL *)url withBlock:(nullable A_RESTRequestDownloadCompliedBlock)block;

/**
 Execute Upload Task, didSendDataBlock params will be avaliable with these requests.
 */
- (nonnull NSURLSessionTask *)A_RequestUpload:(nullable A_RESTRequestCompliedBlock)block;
/**
 Execute Upload Task, didSendDataBlock params will be avaliable with these requests.
 */
- (nonnull NSURLSessionTask *)A_RequestUploadAndReturnDictionary:(nullable A_RESTRequestDictionaryCompliedBlock)block;
/**
 Execute Upload Task, didSendDataBlock params will be avaliable with these requests.
 */
- (nonnull NSURLSessionTask *)A_RequestUploadAndReturnArray:(nullable A_RESTRequestArrayCompliedBlock)block;

- (nonnull NSData *)A_RequestDataSync;
- (nonnull NSDictionary *)A_RequestDictionarySync;
- (nonnull NSArray *)A_RequestArraySync;

- (nonnull NSURLSessionTask *)A_GetURLSessionTask;

#pragma mark - Thread Operations
- (void)A_Resume;
- (void)A_Suspend;
- (void)A_Cancel;

@end
