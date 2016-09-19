//
//  RightViewController.m
//  WXWeibo

#import "RightViewController.h"
#import "SendViewController.h"
#import "BaseNavigationController.h"
@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendAction:(UIButton *)sender
{
    if (sender.tag == 100)
    {
        // 第一个按钮
        SendViewController *sendVC = [[SendViewController alloc] init];
        BaseNavigationController *sendNav = [[BaseNavigationController alloc] initWithRootViewController:sendVC];
        sendNav.navigationBar.tintColor = [UIColor colorWithRed:0.132811 green:0.68377 blue:0.102996 alpha:1];
        
        [self.appDelegate.menuCtrl presentViewController:sendNav animated:YES completion:NULL];
        
        [sendVC release];
        [sendNav release];
    }
}
@end
