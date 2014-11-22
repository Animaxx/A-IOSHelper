//
//  A_RESTRequest.m
//  A-IOSHelper
//
//  Created by Animax on 11/21/14.
//  Copyright (c) 2014 AnimaxStudio. All rights reserved.
//

#import "A_RESTRequest.h"
#import "A_JSONHelper.h"

@implementation A_RESTRequest

+ (NSData*) A_Request: (NSDictionary*)_parameters
                  URL: (NSString*)_URL
               Header: (NSDictionary*)_headers
               Method: (A_NetworkRequestMethod)_method
          ParamFormat: (A_NetworkParameterFormat)_format {
    
    // Perpare Parameters
    NSString *myRequestString = [[NSString alloc] init] ;
    if (_parameters != nil && [_parameters count] > 0
        && (_method == A_Network_GET || _format == A_Network_SendAsJSON))
    {
        NSArray *reqestdDataKeys = [_parameters allKeys];
        for (NSString *itemKey in reqestdDataKeys) {
            NSString* itemObj = [_parameters objectForKey:itemKey];
            
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
    if (_method != A_Network_GET) {
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
    NSData* result = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:&error];
    
    if (error){
#ifndef NDEBUG
        NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <Http request error> \r\n %@", error);
#endif
        return nil;
    }
#ifndef NDEBUG
    NSString* _str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"[MESSAGE FROM A IOS HELPER] \r\n <Http requested result> \r\n %@", _str);
#endif
    
    return result;
}

//Upload Image and file

//Content-Disposition: form-data;
//Content-Type:application/octet-stream ||multipart/form-data

@end
