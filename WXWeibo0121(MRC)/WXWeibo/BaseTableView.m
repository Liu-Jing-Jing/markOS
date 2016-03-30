//
//  BaseTableView.m
//  WXWeibo
//

#import "BaseTableView.h"
#import "EGORefreshTableHeaderView.h"
@interface BaseTableView()<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>
@end

@implementation BaseTableView

// create from xib or storyboard
- (void)awakeFromNib
{
    [self initView];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self != nil)
    {
        [self initView];
    }
    return self;
    
}

- (void)initView
{
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    [self addSubview:_refreshHeaderView];
    // setting delegate for tableView
    self.dataSource = self;
    self.delegate = self;
    
    // turn off refreshHeader
    self.isRefreshHeader = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"WeiboCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    
    return cell;
}

- (void)setIsRefreshHeader:(BOOL)isRefreshHeader
{
    _isRefreshHeader = isRefreshHeader;
    
    if (_isRefreshHeader)
    {
        [self addSubview:_refreshHeaderView];
    }
    else
    {
        if ([_refreshHeaderView superview])
        {
            [_refreshHeaderView removeFromSuperview];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.eventDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [self.eventDelegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - 下拉刷新的相关代码
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    // [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3];
    //停止加载，弹回下拉
    // 写代码要严谨， 避免方法错误调用导致崩溃
    if([self.eventDelegate respondsToSelector:@selector(pullDown:)])
        [self.eventDelegate pullDown:self];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return self.reloading; // should return if data source model is reloading
	
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
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
