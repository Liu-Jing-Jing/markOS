//
//  MKImageView.m
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-14.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import "MKImageView.h"

@implementation MKImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil)
    {
        self.userInteractionEnabled = YES;
        
        // Tap
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}


- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.touchBlock)
    {
        _touchBlock();
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
