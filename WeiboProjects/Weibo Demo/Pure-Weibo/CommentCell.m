//
//  CommentCell.m
//  WXWeibo
#import <QuartzCore/QuartzCore.h>
#import "UserModel.h"
#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"

@interface CommentCell ()

@property (nonatomic, strong) UIImageView *userImage;
@property (nonatomic, strong) UILabel     *nickLabel;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UIImageView *bottomImage;
@property (nonatomic, strong) RTLabel     *contentLabel;
@end

@implementation CommentCell

- (void)awakeFromNib
{
    // Initialization code
    _userImage = (UIImageView *)[self viewWithTag:100];
    _nickLabel = (UILabel *)[self viewWithTag:101];
    _timeLabel = (UILabel *)[self viewWithTag:102];
    
    _contentLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.delegate = self;
    //设置链接的颜色
    _contentLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];
    //设置链接高亮的颜色
    _contentLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self.contentView addSubview:_contentLabel];
    
}

- (void)layoutSubviews
{
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(8, 0, ScreenWidth, 0.3)];
    topLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:topLine];
    _userImage.frame = CGRectMake(8, 8, 40, 40);
    _userImage.layer.cornerRadius = 20;  //圆弧半径
    _userImage.layer.masksToBounds = YES; //隐藏圆角区域
    _userImage.backgroundColor = [UIColor clearColor];
    _userImage.layer.borderWidth = .1;
    _userImage.layer.borderColor = [UIColor grayColor].CGColor;
    
    NSString *urlStr = self.commentModel.user.profile_image_url;
    [_userImage sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    
    
    _nickLabel.text = self.commentModel.user.screen_name;
//    _timeLabel = [[UILabel alloc] init];
//    _timeLabel.frame = CGRectMake(0, 8, 80, 21);
//    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
//    _timeLabel.textColor = [UIColor lightGrayColor];
//    _timeLabel.left = ScreenWidth - 87;
    _timeLabel.text = [UIUtils fomateString:self.commentModel.created_at];
//    [self.contentView addSubview:_timeLabel];
    
    
    _contentLabel.frame = CGRectMake(_userImage.right+10, _nickLabel.bottom+10, 240, 21);
    NSString *contentText = self.commentModel.text;
    contentText = [UIUtils parseLink:contentText];
    _contentLabel.text = contentText;
    _contentLabel.height = _contentLabel.optimumSize.height;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCommentHeight:(CommentModel *)commentModel
{
    RTLabel *rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 240, 0)];
    rtLabel.font = [UIFont systemFontOfSize:14.0f];
    rtLabel.text = commentModel.text;
    
    return rtLabel.optimumSize.height;
}
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    
}
@end
