//
//  BaseTableView.m
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-15.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import "BaseTableView.h"
#define kTriggerOffset 320

@interface BaseTableView()<UITableViewDataSource, UITableViewDelegate>
@end

@interface BaseTableView ()
{
    UIActivityIndicatorView *activityView;
}
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
    // _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    // _refreshHeaderView.delegate = self;
    // _refreshHeaderView.backgroundColor = [UIColor clearColor];
    // [self addSubview:_refreshHeaderView];
    
    // setting delegate for tableView
    self.dataSource = self;
    self.delegate = self;
    
    // turn on refreshHeader
    self.isRefreshHeader = YES;
    
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreButton.backgroundColor = [UIColor whiteColor];
    self.moreButton.frame = CGRectMake(0, 0, ScreenWidth, 40);
    self.moreButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.moreButton setTitle:@"More..." forState:UIControlStateNormal];
    [self.moreButton addTarget:self
                        action:@selector(loadMoreAction:)
              forControlEvents:UIControlEventTouchUpInside];
    
    //添加一条分割线
    UIView *separetorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    separetorLine.backgroundColor = [UIColor lightGrayColor];
    [self.moreButton addSubview:separetorLine];
    // 添加loading旋转小图标
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(100, 10, 20, 20);
    [activityView stopAnimating];
    self.isMore = YES; // 默认情况下有数据
    [self.moreButton addSubview:activityView];
    self.tableFooterView = self.moreButton;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    
    return self;
}

- (void)refreshData
{
    // [self.refreshHeaderView refreshLoading:self];
}

- (void)startLoadMore
{
    [_moreButton setTitle:@"Loading..." forState:UIControlStateNormal];
    [_moreButton setEnabled:NO];
    [activityView startAnimating];
}

- (void)stopLoadMore
{
    if(self.data.count>0)
    {
        _moreButton.hidden = NO;
        [_moreButton setTitle:@"More..." forState:UIControlStateNormal];
        [_moreButton setEnabled:YES];
        [activityView stopAnimating];
        
        if(! _isMore)
        {
            [_moreButton setTitle:@"Done(No More)" forState:UIControlStateNormal];
            _moreButton.enabled = NO;;
        }
    }
    else
    {
        _moreButton.hidden = YES;
    }
    
    
}

- (void)reloadData
{
    // NSLog(@"change mode");
    [super reloadData];
    // 停止加载更多
    [self stopLoadMore];
}

- (void)loadMoreAction:(UIButton *)sender
{
//    if([self.eventDelegate respondsToSelector:@selector(pullUp:)])
//    {
//        [self.eventDelegate pullUp:self];
//        [self startLoadMore];
//    }
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    return cell;
}

//- (void)setIsRefreshHeader:(BOOL)isRefreshHeader
//{
//    _isRefreshHeader = isRefreshHeader;
//    
//    if (_isRefreshHeader)
//    {
//        [self addSubview:_refreshHeaderView];
//    }
//    else
//    {
//        if ([_refreshHeaderView superview])
//        {
//            [_refreshHeaderView removeFromSuperview];
//        }
//    }
//}


#pragma mark - 下拉刷新的相关代码
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData
{
	_reloading = NO;
	// [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
// 当滑动时，实时调用此方法（不断调用）
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//	// [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
//}

// 手指停止拖拽的时候调用此方法
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
	
//	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
//	
//    if(!self.isMore) return;
//    
//    // offset
//    CGFloat offset = scrollView.contentOffset.y;
//    CGFloat contentHeight = scrollView.contentSize.height;
//    // 当offset偏移，滑动到底部时，差值为屏幕的高度(初略计算480-20-44-49)
//    CGFloat sub = contentHeight-offset;
//    NSLog(@"%f",sub);
//    if (sub < kTriggerOffset)
//    {
//        if([self.eventDelegate respondsToSelector:@selector(pullUp:)])
//        {
//            [self.eventDelegate pullUp:self];
//            [self startLoadMore];
//        }
//    }
    
//    if (sub < 30+300)
//    {
//        if([self.eventDelegate respondsToSelector:@selector(pullUp:)])
//        {
//            [self.eventDelegate pullUp:self];
//            [self startLoadMore];
//        }
//    }

//}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
//- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
//{
//	[self reloadTableViewDataSource];
//    
//    // [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3];
//    //停止加载，弹回下拉
//    // 写代码要严谨， 避免方法错误调用导致崩溃
//    if([self.eventDelegate respondsToSelector:@selector(pullDown:)])
//        [self.eventDelegate pullDown:self];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
