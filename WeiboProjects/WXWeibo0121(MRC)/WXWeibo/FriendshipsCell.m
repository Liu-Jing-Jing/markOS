//
//  FriendshipsCell.m
//  WXWeibo
//
//  Created by Mark Lewis on 16-6-3.
//  Copyright (c) 2016年 Mark Lewis. All rights reserved.
//

#import "FriendshipsCell.h"
#import "UserGridView.h"

@implementation FriendshipsCell

- (void)awakeFromNib
{
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        [self initViews];
    }
    return self;
}


-(void)initViews
{
    for (int i = 0 ; i<3; i++)
    {
        UserGridView *gridView = [[UserGridView alloc]initWithFrame:CGRectZero];
        gridView.tag = 2013+i;
        gridView.backgroundColor = [UIColor clearColor];
        // gridView.frame = CGRectMake(10+280/3*i, 10, 96, 96);
        // 在layoutSubview中设置frame
        [self.contentView addSubview:gridView];
        [gridView release];
    }
    
}


-(void)setData:(NSArray *)data
{
    if (_data != data)
    {
        [_data release];
        _data = [data retain];
    }
    
    
    for (int i =0 ; i<3; i++)
    {
        int tag = 2013+i;
        UserGridView *gridView = (UserGridView *)[self.contentView viewWithTag:tag];
        gridView.hidden = YES;
        
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i=0; i<self.data.count; i++)
    {
        UserModel *userModel = [self.data objectAtIndex:i];
        int tag = 2013+i;
        UserGridView *gridView = (UserGridView *)[self.contentView viewWithTag:tag];
        gridView.frame = CGRectMake(100*i+12, 10, 96, 96);
        gridView.userModel = userModel;
        gridView.hidden = NO;//这里data不为空的显示，没有数据的还是隐藏，这是为什么
        // NSLog(@"[55]gridView.userModel=%@",gridView.userModel);
        
        //让gridView异步调用layoutSubviews，解决上下滑动相同cell的问题
        [gridView setNeedsLayout];//
    }
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
