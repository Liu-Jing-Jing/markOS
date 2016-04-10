//
//  UIUtils.m
//  WXTime

#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"


@implementation UIUtils

+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    //两种获取document路径的方式
//    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    return path;
}

+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	[formatter release];
	return str;
}

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

//Sat Jan 12 11:50:16 +0800 2013
+ (NSString *)fomateString:(NSString *)datestring {
    NSString *formate = @"E MMM d HH:mm:ss Z yyyy";
    NSDate *createDate = [UIUtils dateFromFomate:datestring formate:formate];
    NSString *text = [UIUtils stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}

+ (NSString *)parseLink:(NSString *)text
{
    // Regular expression
    //\w配的是：匹配字母或数字或下划线或汉字
    //        NSString *regex = @"@\\w+";   //匹配 "@用户"
    //        NSString *regex = @"#\\w+#";  //匹配 "#话题#"
    //        NSString *regex = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";   //匹配 “http://...”
    //三种表达式集成一起
    NSString *regex = @"(@\\w+)|(#\\w+#)|(http(s)?://([A-Za-z0-9._-]+(/)?)*)";
    NSArray *matchedArray = [text componentsMatchedByRegex:regex];
    
    NSString *replacementStr = nil;
    for (NSString *linkString in matchedArray)
    {
        if ([linkString hasPrefix:@"@"])
        {
            // @用户
            replacementStr = [NSString stringWithFormat:@"<a href='users://%@'>%@</a>", [linkString URLEncodedString], linkString];
        }
        else if ([linkString hasPrefix:@"#"])
        {
            // 话题
            replacementStr = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>", [linkString URLEncodedString], linkString];
        }
        else if ([linkString hasPrefix:@"http"])
        {
            // 网页超链接
            replacementStr = [NSString stringWithFormat:@"<a href='%@'>%@</a>", linkString, linkString];
        }
        
        
        //开始替换原有位置的字符串
        if(replacementStr != nil) text = [text stringByReplacingOccurrencesOfString:linkString withString:replacementStr];
    }
    
    return text;
}
@end
