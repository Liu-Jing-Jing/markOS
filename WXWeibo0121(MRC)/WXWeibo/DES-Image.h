//
//  DES-Image.h
//  LesDo
//
//  Created by xindaoapp on 13-9-4.
//  Copyright (c) 2013年 xin wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"
@interface DES_Image : NSObject
+ (NSString *)encryptWithText:(NSString *)sText;//加密
+ (NSString *)decryptWithText:(NSString *)sText;//解密
@end
