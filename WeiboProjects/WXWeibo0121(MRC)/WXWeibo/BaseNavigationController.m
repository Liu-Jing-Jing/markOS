//
//  BaseNavigationController.m
//  WXWeibo
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

//- (void)setTitle:(NSString *)title
//{
//    [super setTitle:title];
//    [self initCustomNavigationTitleView];
//}
//
//
//-(void)initCustomNavigationTitleView
//{
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , 100, 44)];
//    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
//    titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
//    //titleLabel.textColor = [UIColor colorWithRed:(0.0/255.0) green:(255.0 / 255.0) blue:(0.0 / 255.0) alpha:1];  //设置文本颜色
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    // titleLabel.text = @"自定义标题";  //设置标题
//    self.navigationItem.titleView = titleLabel;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
//    float version = WXHLOSVersion();
//    if (version >= 5.0)
//    {
//        UIImage *image = [UIImage imageNamed:@"navigationbar_background.png"];
//        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    }
//    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//    {
//        [self.navigationBar setBackgroundImage:<#(UIImage *)#> forBarMetrics:<#(UIBarMetrics)#>]
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
