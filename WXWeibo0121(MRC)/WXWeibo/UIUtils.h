//
//  UIUtils.h

#import <Foundation/Foundation.h>

@interface UIUtils : NSObject

//获取documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName;
// date 格式化为 string
+ (NSString*) stringFromFomate:(NSDate*)date formate:(NSString*)formate;
// string 格式化为 date
+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate;

+ (NSString *)fomateString:(NSString *)datestring;

@end
