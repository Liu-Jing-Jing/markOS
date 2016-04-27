//
//  LeftViewController.m
//  WXWeibo


#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

//#pragma mark - Action
//- (void)cancelAction:(UIButton *)sender
//{
//    [self.appDelegate.menuCtrl dismissViewControllerAnimated:YES completion:NULL];
//}
//
//- (void)sendAction:(UIButton *)sender
//{
//    [self.appDelegate.menuCtrl dismissViewControllerAnimated:YES completion:NULL];
//}


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
    self.view.backgroundColor = [UIColor grayColor];
    
    //

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
