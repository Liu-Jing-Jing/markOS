//
//  RightViewController.m
//  WXWeibo
//
//  Created by Mark Lewis on 16-2-4.
//  Copyright (c) 2016年 TechLewis. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.textView.text = @"随\n时\n随\n地\n记\n录\n生\n边\n点\n滴\n！\n";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
