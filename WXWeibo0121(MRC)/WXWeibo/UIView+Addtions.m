//
//  UIView+Addtions.m
//  WXWeibo

#import "UIView+Addtions.h"

@implementation UIView (Addtions)

- (UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    
    do
    {
        if ([next isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)next;
        }
        
        // 继续
        next = next.nextResponder;
        
    }while(next != nil);
    
    return nil;
}
@end
