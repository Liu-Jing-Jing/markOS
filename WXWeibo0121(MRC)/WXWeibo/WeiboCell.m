//
//  WeiboCell.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-23.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WeiboCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WeiboView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "RegexKitLite.h"
#import "UIUtils.h"
@interface WeiboCell ()

@end
@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

//初始化子视图
- (void)_initView {
    //用户头像
    _userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _userImage.backgroundColor = [UIColor clearColor];
    _userImage.layer.cornerRadius = 5;  //圆弧半径
    _userImage.layer.borderWidth = .5;
    _userImage.layer.borderColor = [UIColor grayColor].CGColor;
    _userImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_userImage];
    
    //昵称
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nickLabel.backgroundColor = [UIColor clearColor];
    _nickLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_nickLabel];
    
    //转发数
    _repostCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _repostCountLabel.font = [UIFont systemFontOfSize:12.0];
    _repostCountLabel.backgroundColor = [UIColor clearColor];
    _repostCountLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_repostCountLabel];
    
    //回复数
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.font = [UIFont systemFontOfSize:12.0];
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_commentLabel];
    
    
    //微博来源
    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.font = [UIFont systemFontOfSize:12.0];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_sourceLabel];
    
    //发布时间
    _createLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _createLabel.font = [UIFont systemFontOfSize:12.0];
    _createLabel.backgroundColor = [UIColor clearColor];
    _createLabel.textColor = [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1]; // 0 0.478431 1 1
    [self.contentView addSubview:_createLabel];
    
    
    //评论和转发数量Label
    _countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _countLabel.font = [UIFont systemFontOfSize:12.0];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_countLabel];
    
    // 转发的微博视图
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //-----------用户头像视图_userImage--------
    _userImage.frame = CGRectMake(5, 5, 35, 35);
    NSString *userImageUrl = _weiboModel.user.profile_image_url;
    [_userImage setImageWithURL:[NSURL URLWithString:userImageUrl]];
    
    //昵称_nickLabel
    _nickLabel.frame = CGRectMake(50, 5, 200, 20);
    _nickLabel.text = _weiboModel.user.screen_name;
    
    
    //微博视图_weiboView
    _weiboView.weiboModel = _weiboModel;
    //获取微博视图的高度
    float h = [WeiboView getWeiboViewHeight:_weiboModel isRepost:NO isDetail:NO];
    _weiboView.frame = CGRectMake(50, _nickLabel.bottom+10, kWeibo_Width_List, h);
    
    
    //----------------------
    //微博创建时间_createLabel
    NSString *createDate = _weiboModel.createDate;
    if(createDate != nil)
    {
        _createLabel.hidden = NO;   // 显示这个Label
        
        // fomateString:类方法可以将新浪的Date转化为目标字符串
        NSString *readableDateStr = [UIUtils fomateString:createDate];
        _createLabel.text = readableDateStr;
        _createLabel.textColor = [UIColor lightGrayColor];
        _createLabel.frame = CGRectMake(_nickLabel.right-10, _nickLabel.top, 100, 20);
        [_createLabel sizeToFit];
        _createLabel.bottom = _nickLabel.bottom;
    }
    else
    {
        _createLabel.hidden = YES;
    }
    
    //----------------------
    //微博来源_sourceLabel
    //"source": "<a href="http://weibo.com" rel="nofollow">新浪微博</a>"
    //取出<a> </a>之间的内容
    // NSString *weiboSource = _weiboModel.source;
    /*
    NSString *sourceString = [self parseSourceToReadable:weiboSource];
    if (sourceString != nil)
    {
        _sourceLabel.hidden = NO;
        _sourceLabel.text = [NSString stringWithFormat:@"来自:%@", sourceString];
        _sourceLabel.frame = CGRectMake(_createLabel.right+10, self.height-20, 100, 20);
        [_sourceLabel sizeToFit];
    }
    else
    {
        _sourceLabel.text = [NSString stringWithFormat:@"来自:新浪微博"];
        _sourceLabel.frame = CGRectMake(_createLabel.right+10, self.height-20, 100, 20);
        [_sourceLabel sizeToFit];
        // _sourceLabel.hidden = YES;
    }
     */
    
    
    int reposts = [_weiboModel.repostsCount intValue];
    int comments = [_weiboModel.commentsCount intValue];
    if (reposts>=0 && comments>=0)
    {
        _countLabel.hidden = NO;
        _countLabel.text = [NSString stringWithFormat:@"『Reposts:%d  Comments:%d』",reposts, comments];
        _countLabel.frame  =CGRectMake(_weiboView.left, self.height-20, 80, 20);
        [_countLabel sizeToFit];
    }
}


- (NSString *) parseSourceToReadable:(NSString *)str
{
    NSString *regexExpression = @">\\w+<";
    NSArray *array = [str componentsMatchedByRegex:regexExpression];
    if(array.count > 0)
    {
        //找出正确的来源
        NSString *source = array[0];
        NSRange range = NSMakeRange(1, source.length-2);
        NSString *result = [source substringWithRange:range];
        return result;
    }
    
    return nil;
}
@end
