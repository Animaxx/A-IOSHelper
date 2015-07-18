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

@implementation A_RESTRequest

#pragma mark - Methods For Construct
+ (NSData*) A_Request: (NSString*)_URL
           Parameters: (NSDictionary*)_parameters
              Headers: (NSDictionary*)_headers
               Method: (A_NetworkRequestMethod)_method
          ParamFormat: (A_NetworkParameterFormat)_format {
    
    // Perpare Parameters
    NSString *myRequestString = [[NSString alloc] init] ;
    if (_parameters != nil && [_parameters count] > 0
        && (_method == A_Network_GET || _format == A_Network_SendAsJSON))
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
    NSString *urlStr = _URL;
    if (_method == A_Network_GET){
        urlStr = [[_URL stringByAppendingFormat:@"?%@", myRequestString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    // the Request
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: urlStr]];
    
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
    
    // Send Request
    NSError *error = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:&error];
    
    if (error){
#ifndef NDEBUG
        NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Http request error> \r\n %@ \r\n -------- \r\n\r\n", error);
#endif
        return nil;
    }
#ifndef NDEBUG
    NSString *_str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"\r\n -------- \r\n [MESSAGE FROM A IOS HELPER] \r\n <Http requested result> \r\n %@ \r\n -------- \r\n\r\n", _str);
#endif
    
    return result;
}

+ (NSMutableURLRequest*) A_UploadRequestConstructor: (NSString*)_URL
                                    QueryParameters: (NSDictionary*)_parameters
                                     FormParameters: (NSDictionary*)_formparameters
                                            Headers: (NSDictionary*)_headers
                                               File: (NSData*)_filedata
                                           FileName: (NSString*)_filename
                                            FileKey: (NSString*)_filekey {
    NSString *boundary = @"A_iOS_Helper";
    
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
