#import "BaseViewController.h"

@interface WebViewController : BaseViewController<UIWebViewDelegate>
{
    NSString *_urlStr;
}

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;

- (id)initWithURL:(NSString *)urlString;
- (IBAction)goForward:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)reload:(id)sender;

@end
