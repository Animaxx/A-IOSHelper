//
//  A_RESTRequest.m
//  A-IOSHelper
//
//  Created by Animax
//  Copyright (c) 2014 AnimaxStudio. All rights reserved.
//
#import "A_JSONHelper.h"
#import "A_RESTRequest.h"

#define boundary @"A_iOSHelper"

typedef NS_ENUM (NSInteger, A_NetworkSessionType) {
    A_NetworkSessionType_NormalRequest= 0,
    A_NetworkSessionType_DownloadRequest,
    A_NetworkSessionType_UploadRequest,
};

@interface A_RESTRequestUploadDataSet ()

@property (strong, nonatomic) NSData *fileData;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *fileKey;

@end

@implementation A_RESTRequestUploadDataSet

+ (A_RESTRequestUploadDataSet *)A_Make:(NSData *)fileData fileName:(NSString *)filename {
	return [self A_Make:fileData fileName:filename fileKey:filename];
}
+ (A_RESTRequestUploadDataSet *)A_Make:(NSData *)fileData fileName:(NSString *)filename fileKey:(NSString *)fileKey {
	A_RESTRequestUploadDataSet *dataset= [[A_RESTRequestUploadDataSet alloc] init];
	dataset.fileData= fileData;
	dataset.fileName= filename;
	if (fileKey && fileKey.length > 0) {
		dataset.fileKey= fileKey;
	} else {
		dataset.fileKey= filename;
	}
	return dataset;
}

+ (A_RESTRequestUploadDataSet *)A_MakeWithImage:(UIImage *)image fileName:(NSString *)filename {
	return [self A_MakeWithImage:image fileName:filename fileKey:filename];
}
+ (A_RESTRequestUploadDataSet *)A_MakeWithImage:(UIImage *)image fileName:(NSString *)filename fileKey:(NSString *)fileKey {
    return [self A_MakeWithImage:image compressRate:1.0f fileName:filename fileKey:fileKey];
}
+ (A_RESTRequestUploadDataSet *)A_MakeWithImage:(UIImage *)image compressRate:(float)rate fileName:(NSString *)filename fileKey:(NSString *)fileKey {
    return [self A_Make:[NSData dataWithData:UIImageJPEGRepresentation (image, rate)] fileName:filename fileKey:fileKey];
}

- (BOOL)dataCompleted {
	return _fileData && _fileName && _fileKey;
}

@end

@interface A_RESTRequest ()<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSURLSession                          *currectSession;
@property (strong, atomic) NSURLSessionTask                         *currectSessionTask;

@property (strong, atomic) NSURL                                    *downloadToPath;

@property (copy, nonatomic) A_RESTRequestCompliedBlock              normalCompliedBlock;
@property (copy, nonatomic) A_RESTRequestDownloadCompliedBlock      downloadCompliedBlock;

@property (strong, atomic) NSMutableData                            *receivedData;

@end

@implementation A_RESTRequest

#pragma mark - Initialize methods
- (instancetype)init {
	self= [super init];
	if (self) {
		[NSException raise:NSInternalInconsistencyException
					format:@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <REST Request Init Error> \r\n -------- \r\n\r\n in %@,Please use A_Create method to create A_RESTRequest", NSStringFromSelector (_cmd)];
	}
	return self;
}
- (instancetype)initInternal {
	self= [super init];
    self.timeout = 60.0f;
    self.url = @"";
	return self;
}

+ (A_RESTRequest *)A_Create:(NSString *)url {
	A_RESTRequest *optionSet= [[A_RESTRequest alloc] initInternal];
	optionSet.url= url;
	return optionSet;
}

+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method {
	A_RESTRequest *optionSet= [[A_RESTRequest alloc] initInternal];
	optionSet.url= url;
	optionSet.requestMethod= method;
	return optionSet;
}
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method headers:(NSDictionary *)headers {
	A_RESTRequest *optionSet= [[A_RESTRequest alloc] initInternal];
	optionSet.url= url;
	optionSet.requestMethod= method;
	optionSet.headers= headers;
	return optionSet;
}
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method parameters:(NSDictionary *)parameters {
	A_RESTRequest *optionSet= [[A_RESTRequest alloc] initInternal];
	optionSet.url= url;
	optionSet.requestMethod= method;
	optionSet.parameters= parameters;
	return optionSet;
}
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method parameters:(NSDictionary *)parameters format:(A_NetworkParameterFormat)parameterFormat {
	A_RESTRequest *optionSet= [[A_RESTRequest alloc] initInternal];
	optionSet.url= url;
	optionSet.requestMethod= method;
	optionSet.parameters= parameters;
	optionSet.parameterFormat= parameterFormat;
	return optionSet;
}
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters format:(A_NetworkParameterFormat)parameterFormat {
	A_RESTRequest *optionSet= [[A_RESTRequest alloc] initInternal];
	optionSet.url= url;
	optionSet.requestMethod= method;
	optionSet.headers= headers;
	optionSet.parameters= parameters;
	optionSet.parameterFormat= parameterFormat;
	return optionSet;
}

+ (A_RESTRequest *)A_Create:(NSString *)url upload:(A_RESTRequestUploadDataSet *)uploadSet {
	A_RESTRequest *optionSet= [[A_RESTRequest alloc] initInternal];
	optionSet.url= url;
	optionSet.requestMethod= A_Network_POST;
	optionSet.uploadDataSet= uploadSet;
	return optionSet;
}
+ (A_RESTRequest *)A_Create:(NSString *)url upload:(A_RESTRequestUploadDataSet *)uploadSet parameters:(NSDictionary *)parameters {
	A_RESTRequest *optionSet= [[A_RESTRequest alloc] initInternal];
	optionSet.url= url;
	optionSet.requestMethod= A_Network_POST;
	optionSet.uploadDataSet= uploadSet;
	optionSet.parameters= parameters;
	optionSet.parameterFormat= A_Network_SendAsDataForm;
	return optionSet;
}
+ (A_RESTRequest *)A_Create:(NSString *)url upload:(A_RESTRequestUploadDataSet *)uploadSet headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters {
	A_RESTRequest *optionSet= [[A_RESTRequest alloc] initInternal];
	optionSet.url= url;
	optionSet.requestMethod= A_Network_POST;
	optionSet.headers= headers;
	optionSet.uploadDataSet= uploadSet;
	optionSet.parameters= parameters;
	optionSet.parameterFormat= A_Network_SendAsDataForm;
	return optionSet;
}

#pragma mark - Event Blocks
- (A_RESTRequest *)A_SetDidReceiveChallengeBlock:(A_RESTDidReceiveChallenge)block {
    self.didReceiveChallengeBlock = block;
    return self;
}
- (A_RESTRequest *)A_SetDidReceiveDataBlock:(A_RESTDidReceiveData)block {
    self.didReceiveDataBlock = block;
    return self;
}
- (A_RESTRequest *)A_SetSendDataBlock:(A_RESTDidSendData)block {
    self.didSendDataBlock = block;
    return self;
}

#pragma mark - Request Methods
/**
 *  foundation request call
 */
- (NSURLSessionTask *)A_RequestWithType:(A_NetworkSessionType)request {
    //A_RESTRequestCompliedBlock
//    [UIApplication sharedApplication].networkActivityIndicatorVisible= YES;
    
	// Perpare Parameters
	NSString *myRequestString= [[NSString alloc] init];
	if (_parameters != nil && [self.parameters count] > 0 && (_requestMethod == A_Network_GET || _parameterFormat == A_Network_SendAsQuery)) {
		NSArray *reqestdDataKeys= [_parameters allKeys];
		for (NSString *itemKey in reqestdDataKeys) {
			NSString *itemObj= (NSString *)[_parameters objectForKey:itemKey];

			if (itemObj != nil) {
				if (myRequestString.length > 0) {
					myRequestString= [myRequestString stringByAppendingString:@"&"];
				}

				if ([itemObj isKindOfClass:[NSString class]]) {
					myRequestString= [myRequestString stringByAppendingFormat:@"%@=%@", itemKey, itemObj];
				}
			}
		}
	}

	// Set Parameters for GET
	NSString *urlStr= _url;
	if (_requestMethod == A_Network_GET && myRequestString.length > 0) {
		urlStr= [_url stringByAppendingFormat:@"?%@", [myRequestString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
	}

	// the Request
	NSMutableURLRequest *theRequest= [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];

	// Set upload data
    if (!_headers) {
        _headers = @{};
    }
    
	NSMutableData *body= [NSMutableData data];
	if (self.uploadDataSet && [self.uploadDataSet dataCompleted]) {
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", _uploadDataSet.fileKey, _uploadDataSet.fileName] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:_uploadDataSet.fileData];
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

		// Set parameters as form-data
		if (_requestMethod != A_Network_GET && _parameters != nil && [_parameters count] > 0) {
			for (NSString *key in [_parameters allKeys]) {
				NSString *value= (NSString *)[_parameters objectForKey:key];
				[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, value] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
			}
		}

		[theRequest setHTTPBody:body];
        
        
        NSMutableDictionary *rebuildHeader = [[NSMutableDictionary alloc] initWithDictionary:_headers];
        [rebuildHeader setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forKey:@"Content-type"];
        [rebuildHeader setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forKey:@"Content-Length"];
        
        _headers = rebuildHeader;
        
	} else {
		// Set Parameters for POST PUT DELETE
		if (_requestMethod != A_Network_GET && _parameters != nil && [_parameters count] > 0) {
            if (_parameterFormat == A_Network_SendAsJSON) {
				[theRequest setHTTPBody:[A_JSONHelper A_ConvertDictionaryToData:_parameters]];
                
                NSMutableDictionary *rebuildHeader = [[NSMutableDictionary alloc] initWithDictionary:_headers];
                [rebuildHeader setValue:@"application/json; charset=utf-8" forKey:@"Content-Type"];
                _headers = rebuildHeader;
            }
			else
				[theRequest setHTTPBody:[myRequestString dataUsingEncoding:NSUTF8StringEncoding]];
		}
	}

	switch (_requestMethod) {
	case A_Network_POST:
		[theRequest setHTTPMethod:@"POST"];
		break;
	case A_Network_GET:
		[theRequest setHTTPMethod:@"GET"];
		break;
	case A_Network_PUT:
		[theRequest setHTTPMethod:@"PUT"];
		break;
	case A_Network_PATCH:
		[theRequest setHTTPMethod:@"PATCH"];
		break;
	case A_Network_DELETE:
		[theRequest setHTTPMethod:@"DELETE"];
		break;
	default:
		break;
	}
    
    [theRequest setAllHTTPHeaderFields:_headers];
    [theRequest setTimeoutInterval:self.timeout];

//	__block NSData *resultData= nil;
	if (self.currectSessionTask && (self.currectSessionTask.state == NSURLSessionTaskStateRunning || self.currectSessionTask.state == NSURLSessionTaskStateSuspended)) {
		[self.currectSessionTask cancel];
	}

    _currectSession= [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue currentQueue]];
//	_currectSession= [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    
//	if (self.didReceiveChallengeBlock || self.didReceiveDataBlock || self.didSendDataBlock) {
//		session=
//	} else {
//		session= [NSURLSession sharedSession];
//	}
    
//    void(^compleledBlock)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error){
//        
//
//    };
    
    switch (request) {
        case A_NetworkSessionType_NormalRequest:
            self.currectSessionTask= [_currectSession dataTaskWithRequest:theRequest];
//            self.sessionTask= [session dataTaskWithRequest:theRequest completionHandler:compleledBlock];
            break;
        case A_NetworkSessionType_DownloadRequest:
            self.currectSessionTask= [_currectSession downloadTaskWithRequest:theRequest];
            break;
        case A_NetworkSessionType_UploadRequest:
//            self.sessionTask= [session uploadTaskWithRequest:theRequest fromData:body completionHandler:compleledBlock];
            self.currectSessionTask = [_currectSession uploadTaskWithRequest:theRequest fromData:body];
            break;
        default:
            break;
    }
    
	[self.currectSessionTask resume];
    [_currectSession finishTasksAndInvalidate];

	return self.currectSessionTask;
}

- (NSURLSessionTask *)A_Request:(A_RESTRequestCompliedBlock)block {
    [self setNormalCompliedBlock:block];
    return [self A_RequestWithType:A_NetworkSessionType_NormalRequest];
}
- (NSURLSessionTask *)A_RequestDictionary:(A_RESTRequestDictionaryCompliedBlock)block {
	return [self A_Request:^(NSData *data, NSURLResponse *response, NSError *error) {
	  @try {
		  NSDictionary *dicResult= @{};
		  if (data) {
			  dicResult= [A_JSONHelper A_ConvertJSONDataToDictionary:data];
		  }
		  if (block) {
			  block (dicResult, response, error);
		  }
	  } @catch (NSException *e) {
		  NSLog (@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Get JSON and get dictionary error>  \r\n %@ \r\n -------- \r\n\r\n", e);
          if (block) {
              NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:@{@"reason":e.reason, @"userInfo": e.userInfo}];
              block (nil, nil, error);
          }
	  } @finally {
	  }
	}];
}
- (NSURLSessionTask *)A_RequestArray:(A_RESTRequestArrayCompliedBlock)block {
	return [self A_Request:^(NSData *data, NSURLResponse *response, NSError *error) {
	  @try {
		  NSArray *arrayResult= @[];
		  if (data) {
			  arrayResult= [A_JSONHelper A_ConvertJSONDataToArray:data];
		  }
		  if (block) {
			  block (arrayResult, response, error);
		  }
	  } @catch (NSException *e) {
		  NSLog (@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Get JSON and get dictionary error>  \r\n %@ \r\n -------- \r\n\r\n", e);
          if (block) {
              NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:@{@"reason":e.reason, @"userInfo": e.userInfo}];
              block (nil, nil, error);
          }
	  } @finally {
	  }
	}];
}

- (NSURLSessionTask *)A_RequestDownload:(A_RESTRequestDownloadCompliedBlock)block {
    [self setDownloadCompliedBlock:block];
    [self setDownloadToPath:nil];
    return [self A_RequestWithType:A_NetworkSessionType_DownloadRequest];
}
- (NSURLSessionTask *)A_RequestDownloadToDocument:(NSString *)filename withBlock:(A_RESTRequestDownloadCompliedBlock)block {
    
    NSURL *documentDir = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    if (documentDir) {
        NSURL *filePath = [documentDir URLByAppendingPathComponent:filename];
        self.downloadToPath = filePath;
    } else {
        NSLog (@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Document Directory Not Found> \r\n -------- \r\n\r\n");
    }
    
    [self setDownloadCompliedBlock:block];
    return [self A_RequestWithType:A_NetworkSessionType_DownloadRequest];
}
- (NSURLSessionTask *)A_RequestDownloadToUrl:(NSURL *)url withBlock:(A_RESTRequestDownloadCompliedBlock)block {
    self.downloadToPath = url;
    [self setDownloadCompliedBlock:block];
    return [self A_RequestWithType:A_NetworkSessionType_DownloadRequest];
}

- (NSURLSessionTask *)A_RequestUpload:(A_RESTRequestCompliedBlock)block {
    [self setNormalCompliedBlock:block];
    return [self A_RequestWithType:A_NetworkSessionType_UploadRequest];
}
- (NSURLSessionTask *)A_RequestUploadAndReturnDictionary:(A_RESTRequestDictionaryCompliedBlock)block {
    return [self A_RequestUpload:^(NSData *data, NSURLResponse *response, NSError *error) {
        @try {
            NSDictionary *dicResult= @{};
            if (data) {
                dicResult= [A_JSONHelper A_ConvertJSONDataToDictionary:data];
            }
            if (block) {
                block (dicResult, response, error);
            }
        } @catch (NSException *e) {
            NSLog (@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Get JSON and get dictionary error>  \r\n %@ \r\n -------- \r\n\r\n", e);
            if (block) {
                NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:@{@"reason":e.reason, @"userInfo": e.userInfo}];
                block (nil, nil, error);
            }
        } @finally {
        }
    }];
}
- (NSURLSessionTask *)A_RequestUploadAndReturnArray:(A_RESTRequestArrayCompliedBlock)block {
    return [self A_RequestUpload:^(NSData *data, NSURLResponse *response, NSError *error) {
        @try {
            NSArray *arrayResult= @[];
            if (data) {
                arrayResult= [A_JSONHelper A_ConvertJSONDataToArray:data];
            }
            if (block) {
                block (arrayResult, response, error);
            }
        } @catch (NSException *e) {
            NSLog (@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Get JSON and get dictionary error>  \r\n %@ \r\n -------- \r\n\r\n", e);
            if (block) {
                NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:@{@"reason":e.reason, @"userInfo": e.userInfo}];
                block (nil, nil, error);
            }
        } @finally {
        }
    }];
}

- (NSURLSessionTask *)A_GetURLSessionTask {
	return self.currectSessionTask;
}

- (NSData *)A_RequestDataSync {
    dispatch_semaphore_t requestSemaphore= dispatch_semaphore_create (0);
    __block NSData *result = nil;
    
    void(^runBlock)(void)  = ^ {
        [self A_Request:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            result = data;
            dispatch_semaphore_signal (requestSemaphore);
        }];
    };
    if (![NSThread isMainThread]) {
        runBlock();
    } else {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), runBlock);
    }
    
    dispatch_semaphore_wait (requestSemaphore, DISPATCH_TIME_FOREVER);
    return result;
}
- (NSDictionary *)A_RequestDictionarySync {
	__block NSDictionary *result= nil;
	dispatch_semaphore_t requestSemaphore= dispatch_semaphore_create (0);
    
    void(^runBlock)(void)  = ^ {
        [self A_RequestDictionary:^(NSDictionary *data, NSURLResponse *response, NSError *error) {
          result= data;
          dispatch_semaphore_signal (requestSemaphore);
        }];
    };
    if (![NSThread isMainThread]) {
        runBlock();
    } else {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), runBlock);
    }
        
	dispatch_semaphore_wait (requestSemaphore, DISPATCH_TIME_FOREVER);
	return result;
}
- (NSArray *)A_RequestArraySync {
	__block NSArray *result= nil;
	dispatch_semaphore_t requestSemaphore= dispatch_semaphore_create (0);
    
    void(^runBlock)(void)  = ^ {
        [self A_RequestArray:^(NSArray *data, NSURLResponse *response, NSError *error) {
          result= data;
          dispatch_semaphore_signal (requestSemaphore);
        }];
    };
    if (![NSThread isMainThread]) {
        runBlock();
    } else {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), runBlock);
    }
    
	dispatch_semaphore_wait (requestSemaphore, DISPATCH_TIME_FOREVER);
	return result;
}

#pragma mark - Implement Session Delegates
// Normal Session Task functions
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    _receivedData = nil;
    _receivedData = [[NSMutableData alloc] init];
    [_receivedData setLength:0];
    
    completionHandler(NSURLSessionResponseAllow);
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (self.didReceiveDataBlock) {
        self.didReceiveDataBlock (session, dataTask, ((CGFloat)dataTask.countOfBytesReceived / (CGFloat)dataTask.countOfBytesExpectedToReceive));
    }
    
    [_receivedData appendData:data];
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog (@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Http request error> \r\n %@ \r\n -------- \r\n\r\n", error);
    }
    
#ifndef NDEBUG
    NSString *resultStr= [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    NSLog (@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Http requested result> \r\n %@ \r\n -------- \r\n\r\n", resultStr);
#endif
    if (self.normalCompliedBlock) {
        self.normalCompliedBlock(_receivedData, task.response, error);
    }
}

// Upload Session Task functions
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    if (self.didSendDataBlock) {
        self.didSendDataBlock (session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }
}

// Download Session Task functions
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    if (self.didReceiveDataBlock) {
        self.didReceiveDataBlock (session, downloadTask, ((CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite));
    }
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    if (!location) {
        NSLog (@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Http download requested result> \r\n %@ \r\n -------- \r\n\r\n", @"Download failed");
        //                        [UIApplication sharedApplication].networkActivityIndicatorVisible= NO;
        return;
    } else {
        if (self.downloadToPath) {
            NSError *fileErr = nil;
            if ([[NSFileManager defaultManager] fileExistsAtPath:[self.downloadToPath path]]) {
                [[NSFileManager defaultManager] removeItemAtURL:self.downloadToPath error:&fileErr];
                if (fileErr) {
                    NSLog (@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Http remove exist file> \r\n %@ \r\n -------- \r\n\r\n", fileErr);
                }
            }
            
            fileErr = nil;
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:self.downloadToPath error:&fileErr];
            if (fileErr) {
                NSLog (@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Http saving downloaded file> \r\n %@ \r\n -------- \r\n\r\n", fileErr);
            }
        }
    }
    
    if (self.downloadCompliedBlock) {
        if (self.downloadToPath) {
            self.downloadCompliedBlock(self.downloadToPath, downloadTask.response, downloadTask.error);
        } else {
            self.downloadCompliedBlock(location, downloadTask.response, downloadTask.error);
        }
    }
    
}

// Authentication functions
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^) (NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler {
    if (self.didReceiveChallengeBlock) {
        self.didReceiveChallengeBlock (session, challenge, completionHandler);
    } else {
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([challenge.protectionSpace.host isEqualToString:self.currectSessionTask.originalRequest.URL.host]) {
                [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
            }
        }
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
        completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
    }
}

// Exception functions
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    // TODO:
}




#pragma mark - Thread Operations
- (void)A_Resume {
    if (self.currectSessionTask && self.currectSessionTask.state != NSURLSessionTaskStateRunning) {
        [self.currectSessionTask resume];
    }
}
- (void)A_Suspend {
	if (self.currectSessionTask && self.currectSessionTask.state == NSURLSessionTaskStateRunning) {
		[self.currectSessionTask suspend];
	}
}
- (void)A_Cancel {
	if (self.currectSessionTask) {
		[self.currectSessionTask cancel];
	}
}

@end
