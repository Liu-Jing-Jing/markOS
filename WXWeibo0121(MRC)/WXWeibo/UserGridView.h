//
//  UserGridView.h
//  WXWeibo
//
//  Created by Mark Lewis on 16-5-27.
//  Copyright (c) 2016年 Mark Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "UIButton+WebCache.h"
#import "UserViewController.h"

@interface UserGridView : UIView
@property (nonatomic,retain)UserModel *userModel;

@property (assign, nonatomic) long int followingCount;
@property (assign, nonatomic) long int fansCount;
@property (assign, nonatomic) long int weibosCount;


@property (retain, nonatomic) IBOutlet UILabel *nickLabel;
@property (retain, nonatomic) IBOutlet UILabel *fansLabel;
@property (retain, nonatomic) IBOutlet UIButton *imageButton;
- (IBAction)userImageAction:(UIButton *)sender;
@end
