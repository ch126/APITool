/*
 Created by Chelsea Huang on 2017/4/25.
 https://github.com/ch126
 */


#import <Foundation/Foundation.h>

#define TIME_OUT_INTERVAL 20.0

@interface ChAPITool : NSObject <NSURLSessionDelegate>
+(NSMutableDictionary*) uploadBinary:(NSData*)binary withURL:(NSString*)urlAddress withAttName:(NSString *)attname;

/* Dictionary NSString(att name) : NSData */
+(NSMutableDictionary*) uploadWithDataDic:(NSDictionary*)dataDic withURL:(NSString*)urlAddress;


@end
