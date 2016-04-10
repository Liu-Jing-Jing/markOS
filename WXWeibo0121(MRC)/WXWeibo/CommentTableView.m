//
//  CommentTableView.m
//  WXWeibo

#import "CommentTableView.h"
#import "CommentCell.h"
@interface CommentTableView()
@end

@implementation CommentTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    
    self = [super initWithFrame:frame style:style];
    if (self != nil)
    {
        
    }
    
    return self;
}

#pragma TableView Datasource Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    CommentModel *commentModel = self.data[indexPath.row];
    cell.commentModel = commentModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = [CommentCell getCommentHeight:self.data[indexPath.row]];
    return h+50;
}

#pragma mark - TableView Datasource Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headerView;
}
//{
//    UILabel *_countLabel = [[UILabel alloc] init];
//    int reposts = [_weiboModel.repostsCount intValue];
//    int comments = [_weiboModel.commentsCount intValue];
//    if (reposts>=0 && comments>=0)
//    {
//        _countLabel.hidden = NO;
//        _countLabel.text = [NSString stringWithFormat:@"Reposts:%d  | Comments:%d",reposts, comments];
//        _countLabel.font = [UIFont systemFontOfSize:12.0];
//        _countLabel.backgroundColor = [UIColor clearColor];
//        _countLabel.textColor = [UIColor lightGrayColor];
//        _countLabel.frame  =CGRectMake(0, _weiboView.bottom+20, 80, 20);
//        [_countLabel sizeToFit];
//        _countLabel.right = _weiboView.right;
//    }
//    
//    // 为下面的小icon计算宽度
//    UILabel *commentLabel = [[UILabel alloc] init];
//    commentLabel.text = [NSString stringWithFormat:@":Comments:%d", comments];
//    commentLabel.font = [UIFont systemFontOfSize:12.0f];
//    commentLabel.backgroundColor = [UIColor clearColor];
//    commentLabel.textColor = [UIColor lightGrayColor];
//    commentLabel.frame  =CGRectMake(0, _weiboView.bottom+20, 80, 20);
//    [commentLabel sizeToFit];
//    
//    
//    _countLabel.top = 5;
//    UIView *selected_icon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, commentLabel.width-4, 1)];
//    selected_icon.backgroundColor = [UIColor blackColor];
//    selected_icon.top = _countLabel.bottom+5;
//    selected_icon.right = _countLabel.right;
//    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
//    headerView.backgroundColor = [UIColor whiteColor];
//    [headerView addSubview:_countLabel];
//    [headerView addSubview:selected_icon];
//    // [tableHeaderView addSubview:selected_icon];
//    // [tableHeaderView addSubview:_countLabel];
//    // tableHeaderView.height += 20;
//    
//    
//    return headerView;
//}

@end
