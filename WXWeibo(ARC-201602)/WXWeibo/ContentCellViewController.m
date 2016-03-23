//
//  ContentCellViewController.m
//  ToDoList
//
//  Created by Mark Lewis on 15-9-13.
//  Copyright (c) 2015年 TechLewis. All rights reserved.
//

#import "ContentCellViewController.h"
#import "FoldableView.h"

@interface ContentCellViewController ()
{
    CGSize _subjectStrSize;
}
@end

@implementation ContentCellViewController


- (void)initializeSubjectLabel
{
    // Subject Label
    // subjectStrSize = CGSizeMake([self.showItem.itemName length]*10, 24);
    _subjectStrSize = [self.showItem.weiboModel.name sizeWithAttributes:@{
                                                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:20]
                                                                   }];
    
    self.subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, _subjectStrSize.width, 27)];
    self.subjectLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    self.subjectLabel.textColor = [UIColor whiteColor];
    self.subjectLabel.text = self.showItem.weiboModel.source;

    self.itemSubjectScrollView.contentSize = CGSizeMake(_subjectStrSize.width+20, 33);
    // self.itemSubjectScrollView.showsVerticalScrollIndicator = NO;
    // self.itemSubjectScrollView.showsHorizontalScrollIndicator = YES;
    self.itemSubjectScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self.itemSubjectScrollView addSubview:self.subjectLabel];
    
    // NSLog(@"%@", NSStringFromCGSize(_subjectStrSize));

}
- (void)setShowItem:(WeiboFrame *)showItem
{
    _showItem = showItem;
    
    self.subjectLabel.text = self.showItem.weiboModel.name;
    self.noteTextView.text = self.showItem.weiboModel.content;
    [self initializeSubjectLabel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // [self.view addSubview:self.noteTextView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect bounds =self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(bounds.size.width*2, bounds.size.height);
    self.scrollView.showsVerticalScrollIndicator = NO;
    // self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.scrollView.pagingEnabled = YES;
    // 在scrollView中添加View
    CGSize tempSzie = self.firstContentView.bounds.size;
    self.firstContentView.frame = CGRectMake(0, 0, tempSzie.width, tempSzie.height);
    [self.scrollView addSubview:self.firstContentView];
    
    tempSzie = self.secondContentView.bounds.size;
    self.secondContentView.frame = CGRectMake(bounds.size.width, 0, tempSzie.width, tempSzie.height);
    [self.scrollView addSubview:self.secondContentView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editButtonPressed:(id)sender
{    
    if ([[self.backgroundView superview] isKindOfClass:[FoldableView class]])
    {
        // 设置isOpen来关闭foldview
        FoldableView *mySuperview = (FoldableView *)self.backgroundView.superview;
        mySuperview.isClickEditButton = YES;
    }
}
@end
