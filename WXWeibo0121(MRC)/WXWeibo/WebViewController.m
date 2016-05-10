#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.title = @"Loading...";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    UIView *view = [self.tabBarController.view.subviews firstObject];
//    NSLog(@"%@", self.view.subviews);
//    view.height +=150;
//    self.view.height += 49;
//    self.toolBar.bottom+=40;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithURL:(NSString *)urlString
{
    self = [super init];
    if(self != nil)
    {
        _urlStr = [urlString copy];
    }
    
    return self;
}

#pragma mark - Button Action
- (IBAction)goBack:(id)sender
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
    }
}

- (IBAction)reload:(id)sender
{
    if([self.webView canGoForward])
    {
        [self.webView goForward];
    }
}

- (IBAction)goForward:(id)sender
{
    [self.webView reload];
}

#pragma mark - WebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // 执行Javascript代码
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc
{
    [_webView release];
    [_toolBar release];
    [super dealloc];
}

@end
