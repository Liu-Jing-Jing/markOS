//
//  WeiboTableView.m
//  WXWeibo

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "WeiboView.h"
@implementation WeiboTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self setSeparatorInset:UIEdgeInsetsZero];
        if ([self respondsToSelector:@selector(setSeparatorInset:)])
        {
            
            [self setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)])
        {
            
            [self setLayoutMargins:UIEdgeInsetsZero];
            
        }
        
        
        // 监听这个切换图片浏览模式的Notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadData)
                                                     name:kReloadWeiboTableNotification
                                                   object:nil];

    }
    return self;
}


#pragma mark - TableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"WeiboCell";
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        // cell.weiboView.textLabel.delegate = self;
    }
    
    WeiboModel *weibo = self.data[indexPath.row];
    cell.weiboModel = weibo;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboModel *weibo = self.data[indexPath.row];
    float height = [WeiboView getWeiboViewHeight:weibo isRepost:NO isDetail:NO];
    
    height += 76.0;
    
    return height;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
