//
//  DiscoverViewController.m
//  WXWeibo

#import "DiscoverViewController.h"
#import "MKFaceView.h"
#import "MKFaceScrollView.h"
#import "NearWeiboMapViewController.h"


@interface DiscoverViewController ()<UIScrollViewDelegate>
{
    UIPageControl *pageControl;
}
@end

@implementation DiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Discover";
        // MKFaceScrollView *faceView = [[MKFaceScrollView alloc] initWithFrame:CGRectMake(0, 100, 0, 0)];
        // [self.view addSubview:faceView];

        UIView *faceWrapView = [self loadFaceKeyboardView];
        faceWrapView.bottom = ScreenHeight;
        [self.view addSubview:faceWrapView];
    }
    return self;
}

- (UIView *)loadFaceKeyboardView
{
    UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 320, 300)];
    UIImage *backImage = [UIImage imageNamed:@"emoticon_keyboard_background.png"];
    wrapView.backgroundColor = [UIColor colorWithPatternImage:backImage];
    MKFaceView *faceView = [[MKFaceView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    // faceView.backgroundColor = [UIColor greenColor];
    // faceView.top -= 64;
    
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
    // scrollView.backgroundColor = [UIColor grayColor];
    scrollView.delegate = self;
    scrollView.contentSize = faceView.frame.size;
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView addSubview:faceView];
    
    
    
    
    pageControl  = [[UIPageControl alloc]initWithFrame:CGRectMake((ScreenWidth-40)/2, 200, 40, 30)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages = faceView.pageNumber;
    pageControl.currentPage = 0;
    pageControl.tag = 2011;
    
    [wrapView addSubview:pageControl];
    [wrapView addSubview:scrollView];

    [pageControl release];
    [scrollView release];
    return wrapView;
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    
    int pageNumber = _scrollView.contentOffset.x / 320;
    pageControl.currentPage = pageNumber;
    
    
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
    
    for (int i = 100; i<=101; i++)
    {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(3, 3);
        button.layer.shadowOpacity = 1;
        button.layer.shadowRadius = 3;
        
        button.showsTouchWhenHighlighted = YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_nearWeiboButton release];
    [_nearUserButton release];
    [super dealloc];
}


- (IBAction)nearWeiboAction:(id)sender
{
    NearWeiboMapViewController *nearWeiboMapVC = [[NearWeiboMapViewController alloc] init];
    // 传递数据
    
    [self.navigationController pushViewController:nearWeiboMapVC animated:YES];
    [nearWeiboMapVC release];
    
}
@end
