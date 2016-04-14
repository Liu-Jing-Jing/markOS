//
//  BaseViewController.m
//  WXWeibo
//
#import "BaseViewController.h"
#import "AppDelegate.h"
#import "WXHLGlobalUICommon.h"
@interface BaseViewController ()

@end

@implementation BaseViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

// 内存不足时调用该方法，iOS6.0或者更老的版本都会调用
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if(WXHLOSVersion() >= 6.0)
    {
        if(self.view.window == nil)
        {
            self.view = nil;
            
            
        }
    }
}

//override
//设置导航栏上的标题 title
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = [titleLabel autorelease];
}
//-(void)initCustomNavigationTitleView
//{
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , 100, 44)];
//    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
//    titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
//    //titleLabel.textColor = [UIColor colorWithRed:(0.0/255.0) green:(255.0 / 255.0) blue:(0.0 / 255.0) alpha:1];  //设置文本颜色
//    titleLabel.textColor = [UIColor redColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    // titleLabel.text = @"自定义标题";  //设置标题
//    self.navigationItem.titleView = titleLabel;
//}
- (SinaWeibo *)sinaweibo
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegate.sinaweibo;
    return sinaweibo;
}

- (void)showHUBLoadingTitle:(NSString *)title withDim:(BOOL)isDim
{
    self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hub.dimBackground = isDim;
    self.hub.labelText = title;
}

- (void)showHUBLoading
{
    self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hub.dimBackground = YES;
}

- (void)hideHUBLoading
{
    [self.hub hide:YES];
}

- (AppDelegate *)appDelegate
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate;
}
@end