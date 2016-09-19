//
//  UserGridView.m
//  WXWeibo
//
//  Created by Mark Lewis on 16-5-27.
//  Copyright (c) 2016年 Mark Lewis. All rights reserved.
//

#import "UserGridView.h"

@implementation UserGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        UIView *gridView = [[[NSBundle mainBundle]loadNibNamed:@"UserGridView" owner:self options:nil]lastObject];
        gridView.backgroundColor = [UIColor clearColor];
        self.size = gridView.size; // xib的view大小为准
        [self addSubview:gridView];
        
        UIImage *image = [UIImage imageNamed:@"profile_button3_1.png"];
        UIImageView *backgroudView = [[UIImageView alloc]initWithImage:image];
        backgroudView.frame = self.bounds;
        [self insertSubview:backgroudView atIndex:0];//把背景视图插入到最底部
        [backgroudView release];
    }
    return self;
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    
    // 昵称
    self.nickLabel.text = _userModel.screen_name;
    
    // NSLog(@"[66]screen_name=%@",_userModel.screen_name);
    // NSLog(@"[77]self.nickLabel.text=%@",self.nickLabel.text);
    
    
    // 粉丝数
    // Fans
    long fansCount = self.fansCount;    // [self.userModel.followers_count longValue];
    if(fansCount>=1000)
    {
        fansCount = fansCount/1000;
        // NSLog(@"%ld k", fansCount);
        self.fansLabel.text = [NSString stringWithFormat:@"%ldK", fansCount];
    }
    else
    {
        NSLog(@"%ld", fansCount);
        self.fansLabel.text = [NSString stringWithFormat:@"%ld", fansCount];
    }

    /*
    long favo = [self.userModel.followers_count longValue];
    NSString *fans = [NSString stringWithFormat:@"%ld",favo ];
    if (favo > 10000)
    {
        favo = favo/10000;
        fans = [NSString stringWithFormat:@"@%ld",favo ];
    }
    self.fansLabel.text = fans;
     */
    
    // 用户头像url
    NSString *urlstring = self.userModel.profile_image_url;
    [self.imageButton setImageWithURL:[NSURL URLWithString:urlstring ]];
}

- (IBAction)userImageAction:(UIButton *)sender
{
    UserViewController *userCtrl = [[UserViewController alloc]init];
    userCtrl.userId = self.userModel.idstr;
    userCtrl.userName = self.userModel.screen_name;
    [self.viewController.navigationController pushViewController:userCtrl animated:YES];
    [userCtrl release];
}

- (void)dealloc
{
    [_nickLabel release];
    [_fansLabel release];
    [_imageButton release];
    [super dealloc];
}

@end
