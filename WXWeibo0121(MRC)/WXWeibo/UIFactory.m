//
//  UIFactory.m
//  WXWeibo

#import "UIFactory.h"

@implementation UIFactory

+ (ThemeButton *)createButton:(NSString *)imageName highlighted:(NSString *)highlightedName
{
    ThemeButton *button = [[ThemeButton alloc] initWithImage:imageName highlighted:highlightedName];
    return [button autorelease];
}

+ (ThemeButton *)createButtonWithBackground:(NSString *)backgroundImageName
                      backgroundHighlighted:(NSString *)highlightedName
{
    ThemeButton *button = [[ThemeButton alloc] initWithBackground:backgroundImageName highlightedBackground:highlightedName];
    return [button autorelease];
}

+ (ThemeImageView *)createImageView:(NSString *)imageName
{
    ThemeImageView *themeImage = [[ThemeImageView alloc] initWithImageName:imageName];
    return [themeImage autorelease];
}

+ (ThemeLabel *)createLabel:(NSString *)colorName
{
    ThemeLabel *themeLabel = [[ThemeLabel alloc] initWithColorName:colorName];
    return [themeLabel autorelease];
}

+ (UIButton *)createNavigationButton:(CGRect)frame
                               title:(NSString *)title
                              target:(id)aTarget
                              action:(SEL)action
{
    ThemeButton *button = [self createButtonWithBackground:@"" backgroundHighlighted:@""];
    
    button.frame = frame;
    button.titleLabel.text = title;
    [button addTarget:aTarget action:action forControlEvents:UIControlStateNormal];
    
    // 记得重新修改ThemeButton的拉伸属性的setter方法
    // 设置拉伸属性
    
    return nil;
}
@end
