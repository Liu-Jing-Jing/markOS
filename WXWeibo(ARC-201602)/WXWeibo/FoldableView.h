//
//  FoldableView.h
//  ToDoList
//
//  Created by Mark Lewis on 15-9-12.
//  Copyright (c) 2015年 TechLewis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentCellViewController.h"
#import "UIImage+ImageEffects.h"
#import "WeiboFrame.h"
#import "Weibo.h"
@class FoldableView;
@protocol FoldableDelegate <NSObject>

- (void)foldableView:(FoldableView *)foldableView didClosedImageViewWithContentCell:(UIView *)view isClickEditButton:(BOOL)isClick;

@end

@interface FoldableView : UIView

@property (nonatomic, strong) UIImage *topImage;
@property (nonatomic, strong) UIImage *bottomImage;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (nonatomic, strong)UIImage *originTopImage;
@property (nonatomic, strong)UIImage *originBottomImage;
@property (nonatomic, strong)UIImage *translucentTopImage;
@property (nonatomic, strong)UIImage *translucentBottomImage;
@property (nonatomic, strong) id<FoldableDelegate> delegate;

@property (nonatomic, strong) ContentCellViewController *contentCellController;
@property (nonatomic, strong) UIView *contentCellView;
@property (nonatomic, strong) WeiboFrame *item;
@property (nonatomic) BOOL isOpen;
@property (nonatomic) BOOL isClickEditButton;

- (void)openImageViews;
- (void)closeImageViews;
@end
