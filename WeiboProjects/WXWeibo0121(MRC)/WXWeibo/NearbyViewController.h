//  NearbyViewController.h
//  WXWeibo

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

typedef void (^SelectDoneBlock)(NSDictionary *);

@interface NearbyViewController : BaseViewController<UITableViewDataSource, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic)NSArray *data;
@property (copy,nonatomic)SelectDoneBlock selectBlock;
@end
