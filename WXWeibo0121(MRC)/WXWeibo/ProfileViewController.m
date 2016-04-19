//
//  ProfileViewController.m
//  WXWeibo

#import "ProfileViewController.h"

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    NSArray *_data;
    NSArray *_detailDescs;
    int mode;
}
@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
    }
    return self;
}


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"More Settings";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
    }
    
    cell.textLabel.text = _data[indexPath.row];
    if(indexPath.row == 1)
    {
        if (mode ==1 || mode ==2)
        {
            if(mode == 1)
            {
                cell.detailTextLabel.text = @"Large Mode";
            }
            else if(mode == 2)
            {
                cell.detailTextLabel.text = @"Small Mode";
            }
        }
    }
    return cell;
}

/* refresh detail text
 if(indexPath.row == 1)
 {
     mode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowserMode];
     if (mode ==1 || mode ==2)
     {
        if(mode == 1)
        {
            cell.detailTextLabel.text = @"Large Mode";
        }
        else if(mode == 2)
        {
        cell.detailTextLabel.text = @"Small Mode";
        }
     }
 }

 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        UIActionSheet *alertSwitch = [[UIActionSheet alloc] initWithTitle:@"Change Image Mode"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:@"test(大图模式会消耗更多流量)"
                                                         otherButtonTitles:@"Large Image", @"Small Image", @"Auto Mode", nil];
        alertSwitch.tag = 201;
        [alertSwitch showInView:self.view];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 201) // 切换图片浏览模式的actionSheet
    {
        UITableViewCell *modeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if(buttonIndex == 1) // 大图浏览模式
        {
            mode = kLargeBrowserMode;
            modeCell.detailTextLabel.text = @"Large Mode";
        }
        else if(buttonIndex == 2) // 小图浏览模式
        {
            mode = kSmallBrowserMode;
            modeCell.detailTextLabel.text = @"Small Mode";
        }
        // reload tableView
        NSLog(@"%d", [[NSUserDefaults standardUserDefaults] integerForKey:kBrowserMode]);
        // 发送刷新微博列表的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWeiboTableNotification object:nil];
        // NSLog(@"%d", buttonIndex);
        
        if(buttonIndex==1 || buttonIndex==2)[[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kBrowserMode];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
}
#pragma mark- Controller Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _data = @[@"Theme", @"Image Mode"];
    // mode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowserMode];
    // if(mode!=1 || mode!=2) mode = kLargeBrowserMode; // 默认为小图浏览模式
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
