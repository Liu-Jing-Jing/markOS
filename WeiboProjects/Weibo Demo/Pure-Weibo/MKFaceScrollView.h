//
//  MKFaceScrollView.h
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-5-10.
//  Copyright (c) 2016年 MarkLewis All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKFaceView.h"

@interface MKFaceScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *scrollView ;
    MKFaceView *faceView;
    UIPageControl *pageControl;
}

- (id)initWithSelectBlock:(SelectBlock)block;
@end
