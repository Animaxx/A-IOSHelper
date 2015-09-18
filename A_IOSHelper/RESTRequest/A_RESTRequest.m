//
//  A_RESTRequest.m
//  A-IOSHelper
//
//  Created by Animax
//  Copyright (c) 2014 AnimaxStudio. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "A_RESTRequest.h"
#import "A_JSONHelper.h"

#define boundary @"A_iOSHelper"

@interface A_RESTRequestUploadDataSet()

@property (strong, nonatomic) NSData *fileData;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *fileKey;

@end

@implementation A_RESTRequestUploadDataSet

+ (A_RESTRequestUploadDataSet *)A_Make:(NSData *)fileData fileName:(NSString *)filename {
    return [self A_Make:fileData fileName:filename fileKey:filename];
}
+ (A_RESTRequestUploadDataSet *)A_Make:(NSData *)fileData fileName:(NSString *)filename fileKey:(NSString *)fileKey {
    A_RESTRequestUploadDataSet *dataset = [[A_RESTRequestUploadDataSet alloc] init];
    dataset.fileData = fileData;
    dataset.fileName = filename;
    if (fileKey && fileKey.length > 0) {
        dataset.fileKey = fileKey;
    } else {
        dataset.fileKey = filename;
    }
    return dataset;
}

+ (A_RESTRequestUploadDataSet *)A_MakeWithImage:(UIImage *)image fileName:(NSString *)filename {
    return [self A_MakeWithImage:image fileName:filename fileKey:filename];
}
+ (A_RESTRequestUploadDataSet *)A_MakeWithImage:(UIImage *)image fileName:(NSString *)filename fileKey:(NSString *)fileKey {
    return [self A_Make:[NSData dataWithData:UIImageJPEGRepresentation(image, 0.5f)] fileName:filename fileKey:fileKey];
}

@end

@interface A_RESTRequest()

@property (strong, atomic) NSURLSessionTask *sessionTask;

@end

@implementation A_RESTRequest

#pragma mark - Initialize methods
+ (A_RESTRequest *)A_Create:(NSString *)url {
    A_RESTRequest *optionSet = [[A_RESTRequest alloc] init];
    optionSet.url = url;
    return optionSet;
}
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method {
    A_RESTRequest *optionSet = [[A_RESTRequest alloc] init];
    optionSet.url = url;
    optionSet.requestMethod = method;
    return optionSet;
}
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method headers:(NSDictionary *)headers {
    A_RESTRequest *optionSet = [[A_RESTRequest alloc] init];
    optionSet.url = url;
    optionSet.requestMethod = method;
    optionSet.headers = headers;
    return optionSet;
}
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method parameters:(NSDictionary *)parameters {
    A_RESTRequest *optionSet = [[A_RESTRequest alloc] init];
    optionSet.url = url;
    optionSet.requestMethod = method;
    optionSet.parameters = parameters;
    return optionSet;
}
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method parameters:(NSDictionary *)parameters format:(A_NetworkParameterFormat)parameterFormat {
    A_RESTRequest *optionSet = [[A_RESTRequest alloc] init];
    optionSet.url = url;
    optionSet.requestMethod = method;
    optionSet.parameters = parameters;
    optionSet.parameterFormat = parameterFormat;
    return optionSet;
}
+ (A_RESTRequest *)A_Create:(NSString *)url method:(A_NetworkRequestMethod)method headers:(NSDictionary *)headers parameters:(NSDictionary *)parameters format:(A_NetworkParameterFormat)parameterFormat {
    A_RESTRequest *optionSet = [[A_RESTRequest alloc] init];
    optionSet.url = url;
    optionSet.requestMethod = method;
    optionSet.headers = headers;
    optionSet.parameters = parameters;
    optionSet.parameterFormat = parameterFormat;
    return optionSet;
}

#pragma mark - New Methods
- (BOOL)A_IsRunning {
    return _sessionTask.state == NSURLSessionTaskStateRunning;
}
- (A_RESTRequest *)A_Request:(requestCompliedBlock)block {
    // Perpare Parameters
    NSString *myRequestString = [[NSString alloc] init] ;
    if (_parameters != nil && [self.parameters count] > 0
        && (_requestMethod == A_Network_GET || _parameterFormat == A_Network_SendAsJSON))
    {
        NSArray *reqestdDataKeys = [_parameters allKeys];
        for (NSString *itemKey in reqestdDataKeys) {
            NSString *itemObj = [_parameters objectForKey:itemKey];
            
            if (itemObj != nil)
            {
                if (myRequestString.length > 0){
                    myRequestString = [myRequestString stringByAppendingString:@"&"];
                }else{
//                    myRequestString = [myRequestString stringByAppendingString:@"?"];
                }
                
                if ([itemObj isKindOfClass:NSClassFromString(@"NSString")])
                {
                    myRequestString = [myRequestString stringByAppendingFormat:@"%@=%@", itemKey, itemObj];
                }
            }
        }
    }
    
    // Set Parameters for GET
    NSString *urlStr = _url;
    if (_requestMethod == A_Network_GET){
        urlStr = [[_url stringByAppendingFormat:@"?%@", myRequestString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    }
    
    // the Request
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: urlStr]];
    
    // Set Parameters for POST PUT DELETE
    if (_requestMethod != A_Network_GET && _parameters != nil && [_parameters count] > 0) {
        if (_parameterFormat == A_Network_SendAsJSON)
            [theRequest setHTTPBody:[A_JSONHelper A_ConvertDictionaryToData:_parameters]];
        else
            [theRequest setHTTPBody:[myRequestString dataUsingEncoding:NSUTF8StringEncoding]];
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
        case A_Network_DELETE:
            [theRequest setHTTPMethod:@"DELETE"];
            break;
        default:
            break;
    }
    
    [theRequest setAllHTTPHeaderFields:_headers];
    
    __block NSData *resultData = nil;
    if (self.sessionTask && self.sessionTask.state == NSURLSessionTaskStateRunning && self.sessionTask.state == NSURLSessionTaskStateSuspended) {
        [self.sessionTask cancel];
    }
    
    __block requestCompliedBlock compliedBlock = block;
    self.sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:theRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Http request error> \r\n %@ \r\n -------- \r\n\r\n", error);
        }
        
        resultData = data;
        
#ifndef NDEBUG
        NSString *resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Http requested result> \r\n %@ \r\n -------- \r\n\r\n", resultStr);
#endif
        if (compliedBlock){
            compliedBlock(data,response,error);
        }
    }];
    
    return self;
}
- (A_RESTRequest *)A_RequestDictionary:(requestDictionaryCompliedBlock)block {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return [self A_Request:^(NSData *data, NSURLResponse *response, NSError *error) {
        @try {
            NSDictionary *dicResult = [A_JSONHelper A_ConvertJSONDataToDictionary:data];
            if (block) {
                block(dicResult, response, error);
            }
        } @catch (NSException *e) {
            NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Get JSON and get dictionary error>  \r\n %@ \r\n -------- \r\n\r\n", e);
        }@finally {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}
- (A_RESTRequest *)A_RequestArray:(requestArrayCompliedBlock)block {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return [self A_Request:^(NSData *data, NSURLResponse *response, NSError *error) {
        @try {
            NSArray *arrayResult = [A_JSONHelper A_ConvertJSONDataToArray:data];
            if (block) {
                block(arrayResult, response, error);
            }
        } @catch (NSException *e) {
            NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Get JSON and get dictionary error>  \r\n %@ \r\n -------- \r\n\r\n", e);
        }@finally {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}






#pragma mark - Methods For Construct
+ (NSData*) A_Request: (NSString*)_URL
           Parameters: (NSDictionary*)_parameters
              Headers: (NSDictionary*)_headers
               Method: (A_NetworkRequestMethod)_method
          ParamFormat: (A_NetworkParameterFormat)_format {
    
    // Perpare Parameters
    NSString *myRequestString = @"";
    if (_parameters != nil && [_parameters count] > 0 && (_method == A_Network_GET || _format == A_Network_SendAsQuery)) {
        NSArray *reqestdDataKeys = [_parameters allKeys];
        for (NSString *itemKey in reqestdDataKeys) {
            NSString *itemObj = [_parameters objectForKey:itemKey];
            
            if (itemObj != nil)
            {
                if (myRequestString.length > 0){
                    myRequestString = [myRequestString stringByAppendingString:@"&"];
                }
                if ([itemObj isKindOfClass:NSClassFromString(@"NSString")]) {
                    myRequestString = [myRequestString stringByAppendingFormat:@"%@=%@", itemKey, itemObj];
                }
            }
        }
    }
    
    // Set Parameters for GET
    NSString *urlStr = _URL;
    if (_method == A_Network_GET && myRequestString.length > 0){
        urlStr = [[_URL stringByAppendingFormat:@"?%@", myRequestString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    }
    
    // the Request
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: urlStr]];
    
    // Setup upload data
    // TODO: NSMutableData *body = [NSMutableData data];
    
    
    // Set Parameters for POST PUT DELETE
    if (_method != A_Network_GET && _parameters != nil && [_parameters count] > 0) {
        if (_format == A_Network_SendAsJSON)
            [theRequest setHTTPBody:[A_JSONHelper A_ConvertDictionaryToData:_parameters]];
        else
            [theRequest setHTTPBody:[myRequestString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    
    switch (_method) {
        case A_Network_POST:
            [theRequest setHTTPMethod:@"POST"];
            break;
        case A_Network_GET:
            [theRequest setHTTPMethod:@"GET"];
            break;
        case A_Network_PUT:
            [theRequest setHTTPMethod:@"PUT"];
            break;
        case A_Network_DELETE:
            [theRequest setHTTPMethod:@"DELETE"];
            break;
        default:
            break;
    }
    
    [theRequest setAllHTTPHeaderFields:_headers];
    
    
    __block NSData *resultData = nil;
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:theRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Http request error> \r\n %@ \r\n -------- \r\n\r\n", error);
        }
        
        resultData = data;
        
        #ifndef NDEBUG
        NSString *resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Http requested result> \r\n %@ \r\n -------- \r\n\r\n", resultStr);
        #endif
    }];
    
    //TODO: result
    [dataTask resume];
    return resultData;
}

+ (NSMutableURLRequest*) A_UploadRequestConstructor: (NSString*)_URL
                                    QueryParameters: (NSDictionary*)_parameters
                                     FormParameters: (NSDictionary*)_formparameters
                                            Headers: (NSDictionary*)_headers
                                               File: (NSData*)_filedata
                                           FileName: (NSString*)_filename
                                            FileKey: (NSString*)_filekey {
    // Perpare Parameters
    NSString *myRequestString = [[NSString alloc] init] ;
    NSString *urlStr = _URL;
    
    if (_parameters != nil && [_parameters count] > 0)
    {
        NSArray *reqestdDataKeys = [_parameters allKeys];
        for (NSString *itemKey in reqestdDataKeys) {
            NSString *itemObj = [_parameters objectForKey:itemKey];
            
            if (itemObj != nil)
            {
                if (myRequestString.length > 0){
                    myRequestString = [myRequestString stringByAppendingString:@"&"];
                }else{
                    //                    myRequestString = [myRequestString stringByAppendingString:@"?"];
                }
                
                if ([itemObj isKindOfClass:NSClassFromString(@"NSString")])
                {
                    myRequestString = [myRequestString stringByAppendingFormat:@"%@=%@", itemKey, itemObj];
                }
            }
        }
        
        urlStr = [[_URL stringByAppendingFormat:@"?%@", myRequestString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    // Set header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: urlStr]];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // Set Image data
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", _filekey, _filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:_filedata];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Set form data
    if (_formparameters) {
        for (NSString*key in [_formparameters allKeys]) {
            NSString *value = [_formparameters objectForKey:key];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key, value] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [request setHTTPBody:body];
    
    return request;
}

+ (NSData*) A_UploadImage: (NSString*)_URL
          QueryParameters: (NSDictionary*)_parameters
                  Headers: (NSDictionary*)_headers
                    Image: (UIImage*)_image
                 FileName: (NSString*)_filename
                  FileKey: (NSString*)_filekey {
    // Set request
    NSMutableURLRequest *theRequest = [self A_UploadRequestConstructor:_URL QueryParameters:_parameters FormParameters:nil Headers:_headers File:[NSData dataWithData:UIImagePNGRepresentation(_image)] FileName:_filename FileKey:_filekey];
    
    // Send Request
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:&error];
    
    if (error){
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n[MESSAGE FROM A IOS HELPER] \r\n <Http upload image error> \r\n %@ \r\n -------- \r\n\r\n", error);
#endif
        return nil;
    }
#ifndef NDEBUG
    NSString *_str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"\r\n -------- \r\n[MESSAGE FROM A IOS HELPER] \r\n <Http upload image result> \r\n %@ \r\n -------- \r\n\r\n", _str);
#endif
    
    return result;
}

+ (NSData*) A_UploadImageWithForm: (NSString*)_URL
                  QueryParameters: (NSDictionary*)_parameters
                   FormParameters: (NSDictionary*)_formparameters
                          Headers: (NSDictionary*)_headers
                            Image: (UIImage*)_image
                         FileName: (NSString*)_filename
                          FileKey: (NSString*)_filekey {
    // Set request
    NSMutableURLRequest *theRequest = [self A_UploadRequestConstructor:_URL QueryParameters:_parameters FormParameters:_formparameters Headers:_headers File:[NSData dataWithData:UIImagePNGRepresentation(_image)] FileName:_filename FileKey:_filekey];
    
    // Send Request
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:&error];
    
    if (error){
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n[MESSAGE FROM A IOS HELPER] \r\n <Http upload image error> \r\n %@ \r\n -------- \r\n\r\n", error);
#endif
        return nil;
    }
#ifndef NDEBUG
    NSString *_str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"\r\n -------- \r\n[MESSAGE FROM A IOS HELPER] \r\n <Http upload image result> \r\n %@ \r\n -------- \r\n\r\n", _str);
#endif
    
    return result;
}

#pragma mark - Methods For Applicate
+ (NSDictionary*) A_GetDictionary: (NSString*)_URL {
    return [self A_GetDictionary:_URL Parameters:nil Headers:nil];
}
+ (NSArray*) A_GetArray: (NSString*)_URL {
    return [self A_GetArray:_URL Parameters:nil Headers:nil];
}

+ (NSDictionary*) A_GetDictionary: (NSString*)_URL
                       Parameters: (NSDictionary*)_parameters
                          Headers: (NSDictionary*)_headers {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            NSData *_result = [self A_Request:_URL Parameters:_parameters Headers:_headers Method:A_Network_GET ParamFormat:A_Network_SendAsQuery];
            
            NSDictionary *theDataDictionary = nil;
            @try {
                theDataDictionary = [A_JSONHelper A_ConvertJSONDataToDictionary:_result];
            } @catch (NSException *e) {
        #ifndef NDEBUG
                NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Get JSON and get dictionary error>  \r\n %@ \r\n -------- \r\n\r\n", e);
        #endif
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                return nil;
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            return theDataDictionary;
        }
+ (NSArray*) A_GetArray: (NSString*)_URL
             Parameters: (NSDictionary*)_parameters
                Headers: (NSDictionary*)_headers {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSData *_result = [self A_Request:_URL Parameters:_parameters Headers:_headers Method:A_Network_GET ParamFormat:A_Network_SendAsQuery];
            
            NSArray *theDataArray = nil;
            @try {
                theDataArray = [A_JSONHelper A_ConvertJSONDataToArray:_result];
            } @catch (NSException *e) {
        #ifndef NDEBUG
                NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Get JSON and get array error>  \r\n %@ \r\n -------- \r\n\r\n", e);
        #endif
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                return nil;
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            return theDataArray;
        }


+ (NSDictionary*) A_PostQueryReturnDictionary: (NSString*)_URL
                                   Parameters: (NSDictionary*)_parameters
                                       Header: (NSDictionary*)_headers{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSData *_result = [self A_Request:_URL Parameters:_parameters Headers:_headers Method:A_Network_POST ParamFormat:A_Network_SendAsQuery];
    
    NSDictionary *theDataDictionary = nil;
    @try {
        theDataDictionary = [A_JSONHelper A_ConvertJSONDataToDictionary:_result];
    } @catch (NSException *e) {
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Post form and get dictionary error>  \r\n %@ \r\n -------- \r\n\r\n", e);
#endif
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return nil;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return theDataDictionary;
}
+ (NSArray*) A_PostQueryReturnArray: (NSString*)_URL
                         Parameters: (NSDictionary*)_parameters
                             Header: (NSDictionary*)_headers{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSData *_result = [self A_Request:_URL Parameters:_parameters Headers:_headers Method:A_Network_POST ParamFormat:A_Network_SendAsQuery];

    NSArray *theDataArray = nil;
    @try {
        theDataArray = [A_JSONHelper A_ConvertJSONDataToArray:_result];
    } @catch (NSException *e) {
    #ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Post form and get array error>  \r\n %@ \r\n -------- \r\n\r\n", e);
    #endif
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return nil;
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return theDataArray;
}

+ (NSDictionary*) A_PostJSONReturnDictionary: (NSString*)_URL
                                  Parameters: (NSDictionary*)_parameters
                                      Header: (NSDictionary*)_headers {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSData *_result = [self A_Request:_URL Parameters:_parameters Headers:_headers Method:A_Network_POST ParamFormat:A_Network_SendAsJSON];
    
    NSDictionary *theDataDictionary = nil;
    @try {
        theDataDictionary = [A_JSONHelper A_ConvertJSONDataToDictionary:_result];
    } @catch (NSException *e) {
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Post form and get dictionary error>  \r\n %@ \r\n -------- \r\n\r\n", e);
#endif
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return nil;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return theDataDictionary;
}
+ (NSArray*) A_PostJSONReturnArray: (NSString*)_URL
                        Parameters: (NSDictionary*)_parameters
                            Header: (NSDictionary*)_headers {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSData *_result = [self A_Request:_URL Parameters:_parameters Headers:_headers Method:A_Network_POST ParamFormat:A_Network_SendAsJSON];
    
    NSArray *theDataArray = nil;
    @try {
        theDataArray = [A_JSONHelper A_ConvertJSONDataToArray:_result];
    } @catch (NSException *e) {
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Post form and get array error>  \r\n %@ \r\n -------- \r\n\r\n", e);
#endif
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return nil;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return theDataArray;
}



+ (NSDictionary*) A_UploadImage_Dictionary: (NSString*)_URL
                           QueryParameters: (NSDictionary*)_parameters
                                   Headers: (NSDictionary*)_headers
                                     Image: (UIImage*)_image
                                  FileName: (NSString*)_filename
                                   FileKey: (NSString*)_filekey {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSData *_result = [self A_UploadImage:_URL QueryParameters:_parameters Headers:_headers Image:_image FileName:_filename FileKey:_filekey];
    NSDictionary *theDataDictionary = nil;
    @try {
        theDataDictionary = [A_JSONHelper A_ConvertJSONDataToDictionary:_result];
    } @catch (NSException *e) {
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Upload image and get dictionary error>  \r\n %@ \r\n -------- \r\n\r\n", e);
#endif
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return nil;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return theDataDictionary;
}



@end
