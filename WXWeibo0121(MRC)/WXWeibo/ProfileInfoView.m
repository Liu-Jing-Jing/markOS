//  ProfileInfoView.m
//  WXWeibo

#import "ProfileInfoView.h"
#import "UserInfoView.h"
#import "UserModel.h"
#import "RectButton.h"
#import "UIImageView+WebCache.h"

@implementation ProfileInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ProfileInfoView"
                                                      owner:self
                                                    options:nil] lastObject];
        [self addSubview:view];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // code...  fill UserData
    
    // 头像
    self.userImage.layer.cornerRadius = 10;  //圆弧半径
    self.userImage.layer.masksToBounds = YES; //隐藏圆角区域
    self.userImage.backgroundColor = [UIColor clearColor];
    self.userImage.layer.borderWidth = .1;
    self.userImage.layer.borderColor = [UIColor blackColor].CGColor;
    NSString *urlStr = self.userModel.avatar_large;
    [self.userImage setImageWithURL:[NSURL URLWithString:urlStr]];
    
    //nick name
    self.nameLabel.text = self.userModel.screen_name;
    
    //性别
    NSString *gender = self.userModel.gender;
    NSString *sexName = @"未知";//
    sexName = @"";
    if([gender isEqualToString:@"f"])
    {
        sexName = @"Girl";
    }
    else if ([gender isEqualToString:@"m"])
    {
        sexName = @"Man";
    }
    
    // 地址
    NSString *address = self.userModel.location;
    if(address == nil) address = @"";
    self.addressLabel.text = [NSString stringWithFormat:@"%@  %@", sexName, address];
    
    // desc bug,没有返回数据
    NSString *userDesc = self.userModel.description;
    self.infoLabel.text = (userDesc==nil)? @"" : userDesc;
    
    // 微博数
    self.countLabel.text = [NSString stringWithFormat:@"Weibos Count: %ld", self.weibosCount];
    
    
    [self.weiboCountButton setTitle:[_userModel.statuses_count stringValue]];
    [self.weiboCountButton setSubtitle:@"Weibos"];
    // 关注数目
    [self.attButton setTitle:[NSString stringWithFormat:@"%ld", self.followingCount]];
    [self.attButton setSubtitle:@"Following"];
    
    // Fans
    long fansCount = self.fansCount;    // [self.userModel.followers_count longValue];
    if(fansCount>=1000)
    {
        fansCount = fansCount/1000;
        // NSLog(@"%ld k", fansCount);
        [self.fansButton setTitle:[NSString stringWithFormat:@"%ldK", fansCount]];
    }
    else
    {
        NSLog(@"%ld", fansCount);
        [self.fansButton setTitle:[NSString stringWithFormat:@"%ld", fansCount]];
    }
    [self.fansButton setSubtitle:@"Follower"];
    
    
    
}

- (void)dealloc {
    [_weiboCountButton release];
    [super dealloc];
}
@end
