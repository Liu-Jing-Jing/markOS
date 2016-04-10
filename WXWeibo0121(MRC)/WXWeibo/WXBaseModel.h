//
//  WXBaseModel.h
//  MTWeibo
//  所有对象实体的基类

#import <Foundation/Foundation.h>

@interface WXBaseModel : NSObject <NSCoding>
{
}

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串

@end
