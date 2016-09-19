//
//  DiscoverViewController.h
//  WXWeibo
//  广场控制器

#import "BaseViewController.h"

@interface DiscoverViewController : BaseViewController
@property (retain, nonatomic) IBOutlet UIButton *nearWeiboButton;
@property (retain, nonatomic) IBOutlet UIButton *nearUserButton;
- (IBAction)nearWeiboAction:(id)sender;
// - (IBAction)nearUserAction:(id)sender;
@end
