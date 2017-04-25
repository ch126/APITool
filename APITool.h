//
//  APITool.h
//  what
//
//  Created by chelsea on 2017/4/24.
//  Copyright © 2017年 ixensor. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TIME_OUT_INTERVAL 20.0

@interface APITool : NSObject <NSURLSessionDelegate>
+(NSMutableDictionary*) uploadBinary:(NSData*)binary withURL:(NSString*)urlAddress withAttName:(NSString *)attname;

/* Dictionary NSString(att name) : NSData */
+(NSMutableDictionary*) uploadWithDataDic:(NSDictionary*)dataDic withURL:(NSString*)urlAddress;


@end
