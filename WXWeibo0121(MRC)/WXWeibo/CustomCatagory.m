//
//  CustomCatagory.m
//  WXMovie

#import "CustomCatagory.h"

//5.0以下系统自定义UINavigationBar背景
@implementation UINavigationBar(setbackgroud)

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"navigationbar_background.png"];
    [image drawInRect:rect];
}

@end
