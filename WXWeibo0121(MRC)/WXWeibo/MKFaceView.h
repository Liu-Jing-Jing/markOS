//  MKFaceView.h
//  WXWeibo
//
//  Created by Mark Lewis on 16-5-8.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectBlock)(NSString *faceName);
@interface MKFaceView : UIView
{
@private
    NSMutableArray *items;
    UIImageView *magnifierView;
    
}

@property (nonatomic,copy)NSString *selectFaceName;
@property (nonatomic,assign)NSInteger pageNumber;
@property (nonatomic,copy)SelectBlock block;

@end
