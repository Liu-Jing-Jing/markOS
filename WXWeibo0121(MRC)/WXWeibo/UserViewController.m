//
//  UserViewController.m
//  WXWeibo

#import "UserViewController.h"
#import "UserInfoView.h"


@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"User Profile";
    self.userName = self.userModel.screen_name;
    
    UserInfoView *userInfo = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    userInfo.userModel = self.userModel;
    self.tableView.tableHeaderView = userInfo;
}


#pragma mark - Data
- (void)loadUserData
{
    
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
