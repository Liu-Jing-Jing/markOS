//
//  FriendshipsViewController.h
//  WXWeibo
//
//  Created by Mark Lewis on 16-6-3.
//  Copyright (c) 2016年 Mark Lewis. All rights reserved.
//

#import "BaseViewController.h"
#import "MKDateService.h"
#import "UserModel.h"
#import "FriendShipsTableView.h"

@protocol UITableViewEvenDelegate;

typedef enum
{
    Attention,
    Fans
}FriendshipsType;



@interface FriendshipsViewController : BaseViewController<UITableViewEvenDelegate>

@property(nonatomic,copy)NSString *userId;
@property(nonatomic,retain)NSMutableArray *data;
@property(retain, nonatomic) IBOutlet FriendShipsTableView *tableView;
@property(nonatomic,retain)NSString *cursor; //下一页游标
@property (assign,nonatomic)FriendshipsType shipType;

@end
