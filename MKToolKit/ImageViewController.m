//
//  ImageViewController.m
//  Apple Store Demo
//
//  Created by Mark Lewis on 16-8-10.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import "ImageViewController.h"
#import "UIViewExt.h"
@interface ImageViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) CGSize boundsSize;
@property (nonatomic) CGFloat currentScale;

@end


@implementation ImageViewController

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation == UIDeviceOrientationLandscapeLeft || toInterfaceOrientation == UIDeviceOrientationLandscapeRight)
    {
        NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
        self.imageView.frame = self.scrollView.bounds;
        
        NSLog(@"%f", self.navigationController.navigationBar.height+20);
        self.imageView.top += self.navigationController.navigationBar.height+20;
        self.imageView.height -= self.navigationController.navigationBar.height+20;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.scrollView.contentSize = self.imageView ? self.imageView.size : CGSizeZero;
    }
    else
    {
        self.imageView.frame = self.scrollView.bounds;
        self.imageView.top += kNavWithStatusBarHeight;
        self.imageView.height -= kNavWithStatusBarHeight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.scrollView.contentSize = self.imageView ? self.imageView.size : CGSizeZero;
    }
}

#pragma mark - View Controller Lifecycle

// add the UIImageView to the MVC's View
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.boundsSize = self.view.bounds.size;
    [self.imageView setBackgroundColor:[UIColor lightGrayColor]];
    //双击手势
    UITapGestureRecognizer *doubelGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleGesture:)];
    doubelGesture.numberOfTapsRequired=2;
    [self.imageView addGestureRecognizer:doubelGesture];
    [self.scrollView addSubview:_imageView];
    
    
    // add Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageDownlodFinish:)
                                                 name:kImageDownloadFinshNotifcation
                                               object:nil];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kImageDownloadFinshNotifcation
                                                  object:nil];
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        // 显示之前执行

    }
    return self;
}

- (void)imageDownlodFinish:(NSNotification *)notification
{
    self.imageView.frame = self.scrollView.bounds;
    self.imageView.top += kNavWithStatusBarHeight;
    self.imageView.height -= kNavWithStatusBarHeight;
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.scrollView.contentSize = self.imageView ? self.imageView.size : CGSizeZero;
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;
}


#pragma mark - Properties

// lazy instantiation
- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.frame = self.scrollView.bounds;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = image; // does not change the frame of the UIImageView
    // [self.imageView sizeToFit];   // update the frame of the UIImageView
    
    // self.scrollView could be nil on the next line if outlet-setting has not happened yet
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    // next three lines are necessary for zooming
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    
    // next line is necessary in case self.image gets set before self.scrollView does
    // for example, prepareForSegue:sender: is called before outlet-setting phase
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

#pragma mark - Setting the Image from the Image's URL
- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    //    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]]; // blocks main queue!
    // [self startDownloadingImage];
    
    // 通过URL创建ImageView
    [self.imageView setImageWithURL:_imageURL];
}

- (void)startDownloadingImage
{
    self.image = nil;
    
    if (self.imageURL)
    {
        [self.spinner startAnimating];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        
        // another configuration option is backgroundSessionConfiguration (multitasking API required though)
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        // create the session without specifying a queue to run completion handler on (thus, not main queue)
        // we also don't specify a delegate (since completion handler is all we need)
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                                                            // this handler is not executing on the main queue, so we can't do UI directly here
                                                            if (!error)
                                                            {
                                                                if ([request.URL isEqual:self.imageURL])
                                                                {
                                                                    // UIImage is an exception to the "can't do UI here"
                                                                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                                                                    // but calling "self.image =" is definitely not an exception to that!
                                                                    // so we must dispatch this back to the main queue
                                                                    dispatch_async(dispatch_get_main_queue(), ^{ self.image = image; });
                                                                }
                                                            }
                                                        }];
        [task resume]; // don't forget that all NSURLSession tasks start out suspended!
    }
}


#pragma mark - UIScrollViewDelegate

// mandatory zooming method in UIScrollViewDelegate protocol
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    _currentScale=scale;
}

#pragma mark -DoubleGesture Action
-(void)doubleGesture:(UIGestureRecognizer *)sender
{
    CGFloat _maxScale=1.0, _minScale=1.0;
    //当前倍数等于最大放大倍数
    //双击默认为缩小到原图
    if (_currentScale== 2.0) {
        _currentScale=1.0;
        [self.scrollView setZoomScale:_currentScale animated:YES];
        return;
    }
    //当前等于最小放大倍数
    //双击默认为放大到最大倍数
    if (_currentScale== 1.0) {
        _currentScale=2.0;
        [self.scrollView setZoomScale:_currentScale animated:YES];
        return;
    }
    
    CGFloat aveScale =_minScale+(_maxScale-_minScale)/2.0;//中间倍数
    
    //当前倍数大于平均倍数
    //双击默认为放大最大倍数
    if (_currentScale>=aveScale) {
        _currentScale=2.0;
        [self.scrollView setZoomScale:_currentScale animated:YES];
        return;
    }
    
    //当前倍数小于平均倍数
    //双击默认为放大到最小倍数
    if (_currentScale<aveScale) {
        _currentScale=1.0;
        [self.scrollView setZoomScale:_currentScale animated:YES];
        return;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
