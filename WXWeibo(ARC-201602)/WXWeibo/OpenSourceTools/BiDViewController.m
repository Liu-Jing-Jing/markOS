//
//  BiDViewController.m
//  WeiboCell
//
//  Created by Mark Lewis on 15-2-28.
//  Copyright (c) 2015年 TechLewis. All rights reserved.
//

#import "BiDViewController.h"
#import "Weibo.h"
#import "WeiboFrame.h"
#import "WeiboCell.h"
#import "FoldableView.h"



@interface BiDViewController ()<FoldableDelegate>
{
    NSMutableArray *_weiboFrames;
}
@property (nonatomic, strong) FoldableView *foldableView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UILongPressGestureRecognizer *lpGesture;
@end

@implementation BiDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"weibo" ofType:@"plist"]];
    _weiboFrames = [NSMutableArray array];
    
    for (NSDictionary *dict in array)
    {
        // 将字典转为模型
        Weibo *weibo = [Weibo weiboWithDict:dict];
        // WeiboFrame模型
        WeiboFrame *wFrame = [[WeiboFrame alloc] init];
        wFrame.weiboModel = weibo;
        [_weiboFrames addObject:wFrame];
    }
    
    
    // add long press gesture
    self.lpGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedCell:)];
    [self.tableView addGestureRecognizer:self.lpGesture];
    
    [self.tableView registerClass:[WeiboCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - 数据源方法
#pragma mark 多少行数据
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _weiboFrames.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark 每一行显示怎样的cell（内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.定义一个标识
    static NSString *ID = @"cell";
    // 2.去缓存池中取出可循环利用的cell
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 3.如果缓存中没有可循环利用的cell
    if (cell == nil) {
        cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    // 4.设置数据
    WeiboFrame *wf = _weiboFrames[indexPath.section];
    cell.weiboFrame = wf;
    cell.tag = indexPath.row;
    return cell;
}


#pragma mark - delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboFrame *wf = _weiboFrames[indexPath.section];
    return [wf cellHeight];
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"willSelectRow");
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRow");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //  _aWeibo = [tableView cellForRowAtIndexPath:indexPath];
    
}





- (void)longPressedCell:(UILongPressGestureRecognizer *)sender
{
    // 获得长按的那个Cell
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[sender locationInView:self.tableView]];
    if(indexPath == nil) return;
    self.selectedIndexPath = indexPath;
    // UITableViewCell *selectedCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    CGPoint point = [sender locationInView:self.navigationController.view];
    
    
    // 手势处理代码, 长按打开
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        // NSLog(@"%@", NSStringFromCGPoint(selectedCell.frame.origin));
        
        
        CGSize imageSize = CGSizeMake(self.view.bounds.size.width, point.y);
        
        // 截图代码
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 2.0);
        [self.navigationController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *topImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // save this image
        // UIImageWriteToSavedPhotosAlbum(topImage, nil, nil, nil);
        
        // 下半部分
        imageSize = self.tableView.bounds.size;
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 2.0);
        [self.navigationController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //
        self.foldableView = [[FoldableView alloc] initWithFrame:self.view.bounds];
        [self.view insertSubview:self.foldableView aboveSubview:self.tableView];
        // NSLog(@"%@", NSStringFromCGRect(self.foldableView.frame));
        
        
        // 保存两种版本的Image对象
        self.foldableView.originTopImage = topImage;
        self.foldableView.originBottomImage = image;
        self.foldableView.translucentTopImage = [topImage applyBlurWithRadius:3.3 tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.8 maskImage:nil];
        self.foldableView.translucentBottomImage = [image applyBlurWithRadius:3.3 tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.8 maskImage:nil];
        
        self.foldableView.topImage = self.foldableView.translucentTopImage;
        self.foldableView.bottomImage = self.foldableView.translucentBottomImage;
        self.foldableView.delegate = self;
        // 传递DataModel
        self.foldableView.item = _weiboFrames[self.selectedIndexPath.row];
        // setting TableView and button state
        self.tableView.scrollEnabled = NO;
        self.editButtonItem.enabled = NO;
//        self.addButton.enabled = NO;
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        // NSLog(@"end gesture");
        // 禁用LongPress手势
        self.lpGesture.enabled = NO;
    }
    
}

#pragma mark - FoldableView delegate
- (void)foldableView:(FoldableView *)foldableView didClosedImageViewWithContentCell:(UIView *)view isClickEditButton:(BOOL)isClick
{
    // 更新该行的Item备注
    WeiboFrame *selectedItem = _weiboFrames[self.selectedIndexPath.row];
    selectedItem = foldableView.item;
    
    // NSLog(@"%d", isClick);
    
    // 启用LongPress手势
    self.lpGesture.enabled = YES;
    // NSLog(@"关闭通知");
    // setting TableView and button state
    self.tableView.scrollEnabled = YES;
    self.editButtonItem.enabled = YES;
//    self.addButton.enabled = YES;
//    
//    if (isClick)
//    {
//        self.editorViewController = [[BiDEditorViewController alloc] init];
//        [self performSelector:@selector(segueToEditorView)
//                   withObject:nil
//                   afterDelay:0.5];
//    }
}

@end
