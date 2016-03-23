//
//  ContentCellViewController.h
//  ToDoList
//
//  Created by Mark Lewis on 15-9-13.
//  Copyright (c) 2015年 TechLewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboFrame.h"
@interface ContentCellViewController : UIViewController

@property (nonatomic, strong) WeiboFrame *showItem;
@property (strong, nonatomic) IBOutlet UIView *firstContentView;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@property (strong, nonatomic) IBOutlet UIView *secondContentView;
@property (nonatomic, strong) UILabel *subjectLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *itemSubjectScrollView;

@property (strong, nonatomic) IBOutlet UIView *backgroundView;
// action

@end
