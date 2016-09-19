//
//  FoldableView.m
//  ToDoList
//
//  Created by Mark Lewis on 15-9-12.
//  Copyright (c) 2015年 TechLewis. All rights reserved.
//

#import "FoldableView.h"
#import "UIImage+ImageEffects.h"
#define kContentViewHeight 150

@interface FoldableView ()

@end

@implementation FoldableView


- (void)openImageViews
{
    // 上移

    // 下移
    CGRect temp = self.bottomImageView.frame;
    temp.origin.y += kContentViewHeight;
    
    self.contentCellView.frame = CGRectMake(0, (temp.origin.y-2*kContentViewHeight), self.bounds.size.width, self.bounds.size.height);
    CGRect tempFrameOfContentView = self.contentCellView.frame;
    tempFrameOfContentView.origin.y += kContentViewHeight;
    
    // 动画
    [UIView animateWithDuration:0.3 animations:^{
        self.contentCellView.frame = tempFrameOfContentView;
        self.bottomImageView.frame = temp;
    }];
}

- (void)closeImageViews
{
    if ([self.superview isKindOfClass:[UITableView class]])
    {
        // NSLog(@"willClose \nmy delegate = %@", [self.delegate class]);
        
        // 下移
        //CGRect tempTopRect = self.topImageView.frame;
        //tempTopRect.origin.y += 10;
        // 上移
        CGRect temp = self.bottomImageView.frame;
        temp.origin.y -= 150;
        
        // animation
        [UIView animateWithDuration:0.3 animations:^{
            //self.topImageView.frame = tempTopRect;
            self.bottomImageView.frame = temp;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
        [self.delegate foldableView:self didClosedImageViewWithContentCell:self.contentCellView isClickEditButton:self.isClickEditButton];
        // Resetting tableView state
        // if(![self.superview isKindOfClass:[UITableView class]]) return;
        // UITableView *tableView = (UITableView *)self.superview;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

        // Resetting tableView and buttons state
    
        if (CGRectContainsPoint(self.topImageView.frame, point)||
            CGRectContainsPoint(self.bottomImageView.frame, point))
        {
            self.item.weiboModel.name = self.contentCellController.noteTextView.text;
            // 闭合这个视图的imageView
            [self closeImageViews];
        }
    
}

// lazy init
- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    if(self.isOpen == YES)
    {
        [self closeImageViews];
    }
}

- (void)setIsClickEditButton:(BOOL)isClickEditButton
{
    _isClickEditButton = isClickEditButton;
    if(self.isClickEditButton == YES)
    {
        [self closeImageViews];
    }
}

- (void)setItem:(WeiboFrame *)item
{
    _item = item;
    if (self.contentCellController)
    {
        self.contentCellController.showItem = self.item;
    }
}

- (void)setBottomImage:(UIImage *)bottomImage
{
    //updateUI
    self.topImageView = [[UIImageView alloc] initWithImage:_topImage];
    [self addSubview:self.topImageView];
    
    //self.topImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    //self.topImageView.layer.shadowOffset = CGSizeMake(3, 2);
    //self.topImageView.layer.shadowOpacity = 0.6;
    //self.topImageView.layer.shadowRadius = 1;
    
    // add Tap gesture
    UITapGestureRecognizer *tapTop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeImageViews)];
    [self.topImageView addGestureRecognizer:tapTop];
    
    
    
    //updateUI
    self.backgroundColor = [UIColor grayColor];
    self.bottomImageView = [[UIImageView alloc] initWithImage:bottomImage];
    self.bottomImageView.frame = CGRectMake(0, self.topImageView.bounds.size.height, self.bounds.size.width, self.bounds.size.height-self.topImageView.bounds.size.height);
    // 剪切图片的重要代码
    self.bottomImageView.contentMode = UIViewContentModeBottomLeft;
    self.bottomImageView.clipsToBounds = YES;
    [self addSubview:_bottomImageView];
    
    UITapGestureRecognizer *tapBottom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeImageViews)];
    [self.bottomImageView addGestureRecognizer:tapBottom];
    

    [self openImageViews];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentCellController = [[ContentCellViewController alloc] init];
        self.contentCellView = self.contentCellController.view;
        [self addSubview:self.contentCellView];
        
        // NO代表edit按钮没有点击
        self.isClickEditButton = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
