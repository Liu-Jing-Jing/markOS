//
//  DiscoverViewController.m
//  WXWeibo

#import "DiscoverViewController.h"
#import "MKFaceView.h"
#import "MKFaceScrollView.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Discover";
        MKFaceScrollView *faceView = [[MKFaceScrollView alloc] initWithFrame:CGRectMake(0, 64, 0, 0)];
        faceView.bottom = ScreenHeight-59;
        [self.view addSubview:faceView];

    }
    return self;
}

void faceViewTest()
{
    /*
    MKFaceView *faceView = [[MKFaceView alloc] initWithFrame:CGRectZero];
    // faceView.backgroundColor = [UIColor greenColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.contentSize = faceView.frame.size;
    scrollView.pagingEnabled = YES;
    [scrollView addSubview:faceView];
    [self.view addSubview:scrollView];
    
    NSLog(@"%@", faceView);
     */
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
