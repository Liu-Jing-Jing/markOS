//
//  FriendShipsTableView.m
//  WXWeibo
//
//  Created by Mark Lewis on 16-6-3.
//  Copyright (c) 2016年 Mark Lewis. All rights reserved.
//

#import "FriendShipsTableView.h"

@implementation FriendShipsTableView

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    
    self = [super initWithFrame:frame style:style];
    
    if (self != nil )
    {
        
        self.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"FriendshipsCell";
    FriendshipsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil )
    {
        cell = [[FriendshipsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        // 去掉选中效果
        cell.selected = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *array = [self.data objectAtIndex:indexPath.row];
    cell.data = array;
    return cell;
}


-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
