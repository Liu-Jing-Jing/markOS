//  MKFaceView.m
//  WXWeibo
//
//  Created by Mark Lewis on 16-5-8.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import "MKFaceView.h"
#define item_width 42
#define item_height 45

@implementation MKFaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initData];
        self.pageNumber = items.count;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/**
 *  行  row：    4
 *  列  colum：  7
 *  表情尺寸：    30*30 pixels
 */

/*
 *items = [
 ["表情1","表情2","表情3",..."表情28"],//一页28个表情
 
 ["表情1","表情2","表情3",..."表情28"],
 
 ["表情1","表情2","表情3",..."表情28"],
 
 ];
 */

-(void)initData
{
    
    items = [[NSMutableArray alloc]init];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    //该文件下有104个表情
    //    NSLog(@"[LBB]filePath =%@",filePath);
    NSArray *fileArray = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *items2D = nil;
    for (int i = 0; i< fileArray.count; i++)
    {
        
        NSDictionary *item = [fileArray objectAtIndex:i];
        if (i % 28 == 0)
        {
            
            items2D = [NSMutableArray arrayWithCapacity:28];
            [items addObject:items2D];
        }
        
        [items2D addObject:item];
    }
    // 设置尺寸
    self.width = items.count *320;
    self.height = 4 * item_height;
    // self.pageNumber = items.count;
    
    //    放大镜
    magnifierView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 92)];
    magnifierView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier.png"];
    magnifierView.hidden = YES;
    magnifierView.backgroundColor = [UIColor clearColor];
    [self addSubview:magnifierView];
    [magnifierView release];
    
    UIImageView *faceItem = [[UIImageView alloc]initWithFrame:CGRectMake((64-30)/2, 15, 30, 30)];
    faceItem.tag = 2013;
    faceItem.backgroundColor = [UIColor clearColor];
    [magnifierView addSubview:faceItem];
    [faceItem release];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

/*
 *items = [
 
 ["表情1","表情2","表情3",..."表情28"],//一页28个表情
 
 ["表情1","表情2","表情3",..."表情28"],
 
 ["表情1","表情2","表情3",..."表情28"],
 
 ];
 */


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    int row = 0,colum = 0;
    
    for (int i = 0; i<items.count; i++)
    {
        
        NSArray *items2D = [items objectAtIndex:i];
        
        for (int j = 0; j<items2D.count; j++)
        {
            
            NSDictionary *item = [items2D objectAtIndex:j];
            NSString *imageName = [item objectForKey:@"png"];
            UIImage *image = [UIImage imageNamed:imageName];
            
            CGRect frame = CGRectMake(colum *item_width+16,row*item_height+16, 30, 30);
            
            //            考虑页数，需要加上前几页的宽度
            float x = i*320 +frame.origin.x;
            frame.origin.x = x;
            [image drawInRect:frame];
            
            //            更新列与行
            colum ++;//列数
            
            if (colum % 7 == 0)
            {
                row ++ ;//行数
                colum = 0;//列数归零
            }
            
            if (row == 4)
            {
                
                row = 0;
            }
        }
    }

}


-(void)touchFace:(CGPoint)point
{
    
    int page = point.x /320;
    
    float x = point.x - page *ScreenWidth;
    float y = point.y;
    
    //    NSLog(@"[LBB--touchFace]x= %g,y=%g",x,y);
    
    //    计算列与行
    int colum = x / item_width ;
    int row = y / item_height ;
    
    //    NSLog(@"[LBB--touchFace]colum =%d,row = %d",colum,row);
    
    if (colum >6)
    {
        colum = 6;
    }
    if (colum <0 )
    {
        colum = 0;
    }
    
    if (row > 3)
    {
        row = 3;
    }
    
    if (row < 0)
    {
        row = 0;
    }
    
    //    计算选中表情的索引
    int index = colum + row*7;
    NSArray *items2D = [items objectAtIndex:page];
    if(page==3 && index>items2D.count-1) return; // 最后一页没有28个表情，会因为数组越界导致崩溃
    NSDictionary *item = [items2D objectAtIndex:index];
    
    NSString *faceName = [item objectForKey:@"chs"];
    NSLog(@"[lbb]facename = %@",faceName);
    
    
    if (![self.selectFaceName isEqualToString:faceName] || (self.selectFaceName == nil))
    {
        
        NSString *imageName = [item objectForKey:@"png"];
        UIImage *image = [UIImage imageNamed:imageName];
        
        UIImageView *faceItem = (UIImageView *)[magnifierView viewWithTag:2013];
        faceItem.image = image;
        self.selectFaceName = faceName;
        
        
        magnifierView.left = (page *320)+colum *item_width ;
        magnifierView.bottom = row *item_height + 40;
    }
}

// touch事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    // 触摸开始让放大镜显示
    magnifierView.hidden = NO;
    UITouch *touch = [touches anyObject];
    CGPoint point =[touch locationInView:self];
    
    NSLog(@"%@",NSStringFromCGPoint(point));
    
    [self touchFace:point];
    
    // 由于要使得 滑动的时候scroll滑动而导致表情在触摸滑动的时候不能跟着一起变化，所以先禁止
    if ([self.superview isKindOfClass:[UIScrollView class]])
    {
        
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = NO;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint point =[touch locationInView:self];
    
    // NSLog(@"%@",NSStringFromCGPoint(point));
    
    
    [self touchFace:point];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // 触摸结束时让放大镜隐藏
    magnifierView.hidden = YES;
    
    
    if ([self.superview isKindOfClass:[UIScrollView class]])
    {
        
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
    
    if (self.block !=nil)
    {
        _block(_selectFaceName);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    magnifierView.hidden = NO;
    
    if ([self.superview isKindOfClass:[UIScrollView class]])
    {
        
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
    
}

@end
