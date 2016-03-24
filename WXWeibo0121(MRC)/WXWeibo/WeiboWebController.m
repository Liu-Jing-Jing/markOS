//
//  WeiboWebController.m
//  WXWeibo
//
//  Created by Mark Lewis on 16-2-19.
//  Copyright (c) 2016年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WeiboWebController.h"

@interface WeiboWebController ()

@end

@implementation WeiboWebController

- (void)setUrlString:(NSURL *)urlString
{
    if (_urlString != urlString)
    {
        [_urlString release];
        _urlString = [urlString retain];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.urlString];
    [self.webView loadRequest:request];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.webView = [[UIWebView alloc] init];
    self.webView.frame = self.view.bounds;
    self.webView.frame = CGRectMake(0, 0, 320, 500);
    [self.view addSubview:_webView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}
@end
