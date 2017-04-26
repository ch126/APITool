//
//  APITool.m
//  what
//
//  Created by chelsea on 2017/4/24.
//  Copyright © 2017年 ixensor. All rights reserved.
//

#import "ChAPITool.h"

@implementation ChAPITool
+(NSMutableDictionary*) uploadBinary:(NSData * )binary withURL:(NSString * )urlAddress withAttName:(NSString *)attname {
    
    
    NSURL *theURL = [NSURL URLWithString:urlAddress];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:TIME_OUT_INTERVAL];
    [theRequest setHTTPMethod:@"POST"];
    NSString *boundary = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *boundaryString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [theRequest addValue:boundaryString forHTTPHeaderField:@"Content-Type"];
    
    // define boundary separator...
    NSString *boundarySeparator = [NSString stringWithFormat:@"--%@\r\n", boundary];
    
    //adding the body...
    NSMutableData *postBody = [NSMutableData data];
    
    [postBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",attname] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:binary];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r \n",boundary]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    [theRequest setHTTPBody:postBody];
    
    NSData __block *result;
    //+++++
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:[ChAPITool new] delegateQueue:operationQueue];
    NSURLSessionTask *task = [session dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            result = data;
        } else {
            NSLog( @"error:%@", error);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //+++++
    //
    NSString* aStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    //
    NSLog(@"Result: %@", aStr);
    NSLog(@"*********************************");
    
    if (aStr.length<1) {
        NSMutableDictionary *r_pass = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"-99",@"status", nil];
        return r_pass;
    }
    
    NSError *jsonError;
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:result //1
                                                                options:kNilOptions
                                                                  error:&jsonError];
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        
        return dict;
        //注意返回的字典直接nslog的話，顯示為unicode，若將字典內容的value，直接輸出成string即可
    } else {
        NSMutableDictionary *r_pass = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"-99",@"status", nil];
        return r_pass;
    }
}


+(NSMutableDictionary*) uploadWithDataDic:(NSDictionary*)dataDic withURL:(NSString*)urlAddress{
    
    NSURL *theURL = [NSURL URLWithString:urlAddress];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:TIME_OUT_INTERVAL];
    [theRequest setHTTPMethod:@"POST"];
    NSString *boundary = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *boundaryString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [theRequest addValue:boundaryString forHTTPHeaderField:@"Content-Type"];
    
    // define boundary separator...
    NSString *boundarySeparator = [NSString stringWithFormat:@"--%@\r\n", boundary];
    
    //adding the body...
    NSMutableData *postBody = [NSMutableData data];
    NSArray * attnames = [dataDic allKeys];
    
    for(NSString *aKey in attnames){
        [postBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",aKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[dataDic objectForKey:aKey]];
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r \n",boundary]
                              dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [theRequest setHTTPBody:postBody];
    
    NSData __block *result;
    //+++++
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:[ChAPITool new] delegateQueue:operationQueue];
    NSURLSessionTask *task = [session dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            result = data;
        } else {
            NSLog( @"error:%@", error);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //+++++
    //
    NSString* aStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    //
    NSLog(@"Result: %@", aStr);
    NSLog(@"*********************************");
    
    if (aStr.length<1) {
        NSMutableDictionary *r_pass = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"-99",@"status", nil];
        return r_pass;
    }
    
    NSError *jsonError;
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:result //1
                                                                options:kNilOptions
                                                                  error:&jsonError
                                 ];
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        
        return dict;
        //注意返回的字典直接nslog的話，顯示為unicode，若將字典內容的value，直接輸出成string即可
    }
    else {
        NSMutableDictionary *r_pass = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"-99",@"status", nil];
        return r_pass;
    }
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    
    NSURLProtectionSpace * protectionSpace = challenge.protectionSpace;
    if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef serverTrust = protectionSpace.serverTrust;
        completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust: serverTrust]);
    }
    else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

@end
