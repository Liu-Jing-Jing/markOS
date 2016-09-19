//  SendViewController.m
//  WXWeibo

#import "SendViewController.h"
#import "UIFactory.h"
#import "BaseNavigationController.h"
#import "NearbyViewController.h"
@interface SendViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UITextViewDelegate>
{
    UIImageView *_fullImageView;
    UIView *_faceView; // 表情视图
    UIPageControl *pageControl;
    // CGAffineTransform _originTransform;
}

@end

@implementation SendViewController


#pragma mark - Action
- (void)cancelAction
{
    [self.textVIew resignFirstResponder];
    [self.appDelegate.menuCtrl dismissViewControllerAnimated:YES completion:NULL];
}

- (void)sendAction:(UIButton *)sender
{
    [self doSendData];
}

- (void)imageAction:(UIButton *)sender
{
    // 全屏显示图片，显示在Window上
    if (_fullImageView == nil)
    {
        
        _fullImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _fullImageView.backgroundColor = [UIColor blackColor];
        _fullImageView.userInteractionEnabled = YES;
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleImageAction:)];
        tapGesture.delegate = self;
        [_fullImageView addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        
        // 创建删除按钮
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"trash.png" ] forState:UIControlStateNormal];
        deleteButton.tag = 100;
        deleteButton.frame = CGRectMake(ScreenWidth-40, ScreenHeight-40, 25, 29);
        deleteButton.hidden = YES;
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [_fullImageView addSubview:deleteButton];
        
        
    }
    
    [self.textVIew resignFirstResponder];
    
    // 添加到Window上
    if (![_fullImageView superview])
    {
        
        _fullImageView.image = self.sendImage;
        [self.view.window addSubview:_fullImageView];//当该view显示出来时window就不为空
        
        _fullImageView.frame = CGRectMake(12 , ScreenHeight-250, 20, 20);
        [UIView animateWithDuration:0.4 animations:^{
            
            _fullImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight) ;
            
        } completion:^(BOOL finished) {
            
            // 显示删除按钮
            UIButton *button = (UIButton *) [_fullImageView viewWithTag:100];
            button.hidden = NO; // 动画结束显示删除按钮
            [UIApplication sharedApplication].statusBarHidden = YES;
            
        }];
    }
}


//缩小图片
-(void)scaleImageAction:(UITapGestureRecognizer *)tap
{
    
    //    隐藏删除按钮
    UIButton *deleteButton = (UIButton *)[_fullImageView viewWithTag:100];
    deleteButton.hidden = YES;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        _fullImageView.frame = CGRectMake(12, ScreenHeight-250, 20, 20) ;
        
    } completion:^(BOOL finished) {
        
        [_fullImageView removeFromSuperview];
    }];
    
    // show statusBar
    [UIApplication sharedApplication].statusBarHidden = NO;
    // show keyboard
    [self.textVIew becomeFirstResponder];
}


//取消图片
-(void)deleteAction:(UIButton *)deleteButton
{
    
    // NSLog(@"[LBB]deleteAction");
    
    _fullImageView.userInteractionEnabled = NO;
    
    // 1.删除图片button
    //1.先缩小
    [self scaleImageAction:nil];
    //2.移除缩略图按钮
    [self.sendImageButton removeFromSuperview];
    //3.发送图片设置为nil
    
    self.sendImage = nil;
    
    /*
    UIButton *button1 = [_buttons objectAtIndex:0];
    UIButton *button2 = [_buttons objectAtIndex:1];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        button1.transform = CGAffineTransformIdentity;
        button2.transform = CGAffineTransformIdentity;
        
    }];
     */
    
}


#pragma mark - Data
- (void)doSendData
{
    if (self.textVIew.text.length == 0)
    {
        NSLog(@"微博内容为空");
        return;
    }
    
    NSString *text = self.textVIew.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:text forKey:@"status"];
    
    if (self.longitude.length>0 || self.latitude.length>0)
    {
        [params setObject:self.longitude forKey:@"long"];
        [params setObject:self.latitude forKey:@"lat"];
    }

    [params setObject:@"114.4" forKey:@"long"];
    [params setObject:@"30.5" forKey:@"lat"];
    
    if(self.sendImage == nil)
    {
        // 不带图片的
        [self.sinaweibo requestWithURL:@"statuses/update.json"
                                params:params
                            httpMethod:@"POST"
                                 block:^(id result) {
                                     // 发布成功
                                     [self doSendDataFinished:result];
                                 }];
    }
    else
    {
        // 带图片的
        NSData *data= UIImageJPEGRepresentation(self.sendImage, 0.5);
        [params setObject:data forKey:@"pic"];
        // statuses/upload.json
        [self.sinaweibo requestWithURL:@"statuses/upload.json"
                                params:params
                            httpMethod:@"POST"
                                 block:^(id result) {
                                     // 发布成功
                                     [self doSendDataFinished:result];
                                 }];
    }

    
}

- (void)doSendDataFinished:(NSDictionary *)result
{
    // NSLog(@"微博发送成功:%@", result);
    // [self showHUBComplete:@"Succeeded"];
    [self.textVIew resignFirstResponder];
    // [self performSelector:@selector(cancelAction) withObject:nil afterDelay:1];
    [self.appDelegate.menuCtrl dismissViewControllerAnimated:YES completion:NULL];
}


- (void)initView
{
    
    //show keyboard
    [self.textVIew becomeFirstResponder];
    
    
    NSArray *imageNames = @[@"compose_locatebutton_background.png",
                           @"compose_camerabutton_background.png",
                           @"compose_trendbutton_background.png",
                           @"compose_mentionbutton_background.png",
                           @"compose_emoticonbutton_background.png",
                           @"compose_keyboardbutton_background.png",
                           ];
    NSArray *imageHighlighedName = @[@"compose_locatebutton_background_highlighted.png",
                                     @"compose_camerabutton_background_highlighted.png",
                                     @"compose_trendbutton_background_highlighted.png",
                                     @"compose_mentionbutton_background_highlighted.png",
                                     @"compose_emoticonbutton_background_highlighted.png",
                                     @"compose_keyboardbutton_background_highlighted.png"
                                     ];

    
    for(int i = 0; i < imageNames.count; i++)
    {
        NSString *imageName = imageNames[i];
        NSString *highlightedName = imageHighlighedName[i];
        UIButton *button = [UIFactory createButton:imageName highlighted:highlightedName];
        [button setImage:[UIImage imageNamed:imageHighlighedName[i]] forState:UIControlStateHighlighted];
        
        [button addTarget:self
                   action:@selector(buttonAction:)
         forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(20+(64*i), 35, 24, 24);
        // if(i == 0) button.frame = CGRectMake(20, 35, 24, 24);
        button.tag = (10+i);
        [self.editorToolbar addSubview:button];
        [self.buttons addObject:button];
        
        // keyboard icon
        if (i == 5)
        {
            button.hidden = YES;
            button.left -= 64;
        }
    }
    
    
    // place backgroundView
    UIImage *stretchableImage = [self.placeBackgrougView.image stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    self.placeBackgrougView.image = stretchableImage;
    self.placeBackgrougView.width = 250;
    
}


//定位
-(void)location
{
    NearbyViewController *nearby = [[NearbyViewController alloc]init];
    BaseNavigationController *nearbyNav = [[BaseNavigationController alloc]initWithRootViewController:nearby];
    [self presentViewController:nearbyNav animated:YES completion:NULL];
    // [nearby release];
    // [nearbyNav release];
    
    nearby.selectBlock = ^(NSDictionary *result){
        
        NSLog(@"%@",result);
        //        纪录位置坐标
        if([result respondsToSelector:@selector(objectForKey:)])
        {
            self.latitude = [result objectForKey:@"lat"];
            self.longitude = [result objectForKey:@"lon"];
        }
        
        NSString *address = [result objectForKey:@"address"];
        
        if ([address isKindOfClass:[NSNull class]] || address.length == 0) {
            
            address = [result objectForKey:@"title"];
        }
        
        self.placeView.hidden = NO;
        self.placeLabel.text = address;
        UIButton *locationButton =  [_buttons objectAtIndex:0];
        locationButton.hidden = YES;
        // locationButton.selected = YES;
    };
    
    // [self becomeFirstResponder];
    [nearby release];
    [nearbyNav release];
}

//使用相片
-(void)selectImage
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:@"Take a photo"
                                                   otherButtonTitles:@"Photos Album", nil];
    
    [actionSheet showInView:self.view];
    [actionSheet release];
}


- (UIView *)loadFaceKeyboardViewWithBlock:(SelectBlock)block
{
    UIView *wrapView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 320, 300)];
    UIImage *backImage = [UIImage imageNamed:@"emoticon_keyboard_background.png"];
    wrapView.backgroundColor = [UIColor colorWithPatternImage:backImage];
    MKFaceView *faceView = [[MKFaceView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    // faceView.backgroundColor = [UIColor greenColor];
    // faceView.top -= 64;
    faceView.block = block;
    
    
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


// 显示表情面板
- (void)showFaceView
{
    [self.textVIew resignFirstResponder];
    
    
    if (_faceView == nil)
    {
        __block SendViewController *this = self;
        _faceView = [self loadFaceKeyboardViewWithBlock:^(NSString *faceName) {
            NSString *text = this.textVIew.text;
            // 把表情符号追加到text后面
            NSString *appendText = [text stringByAppendingString:faceName];
            this.textVIew.text = appendText;
        }];
        _faceView.top = ScreenHeight;
        [self.view addSubview:_faceView];
        
        
        //        __block SendViewController *this = self;
        //        _faceView = [[WXFaceScrollView alloc]initWithSelectBlock:^(NSString *faceName){
        //
        //            NSString *text = this.textView.text;
        //            //            把表情符号追加到text后面
        //            NSString *appendText = [text stringByAppendingString:faceName];
        //            this.textView.text = appendText;
        //        }];
        
        
        // _faceView.top = ScreenHeight-20-44- _faceView.height;
        
        // 利用transform属性来改变faceView的纵坐标，使它位于屏幕的底部
        // _faceView.transform = CGAffineTransformTranslate(_faceView.transform, 0, ScreenHeight-44-20);
        _faceView.top = ScreenHeight;
        [self.view addSubview:_faceView];
    }
    
    UIButton *faceButton = _buttons[4];
    UIButton *keyboard = _buttons[5];
    
    faceButton.alpha = 1;
    keyboard.alpha = 0;
    keyboard.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        // _originTransform = _faceView.transform;
        // _faceView.transform = CGAffineTransformIdentity;
        // faceView的y坐标改为ScreenHeight－自己的高度
        _faceView.top = ScreenHeight-240;
        faceButton.alpha = 0;
        
        // 调整textView／editorbar的y坐标，解决了切换中英文输入法editorBar空白一块的问题
        // float height = _faceView.height;
        self.editorToolbar.bottom = ScreenHeight-240;
        self.textVIew.height = self.editorToolbar.top;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3  animations:^{
            
            keyboard.alpha = 1;
            
        }];
        
    }];
}


-(void)showKeyboardWithDelegate:(BOOL)isDelegate
{
    if(isDelegate == NO) [self.textVIew becomeFirstResponder];
    
    UIButton *faceButton = _buttons[4];
    UIButton *keyboard = _buttons[5];
    
    keyboard.alpha= 1;
    faceButton.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        // CGAffineTransformTranslate(_faceView.transform, 0, ScreenHeight - 64 -20);
        // 复位到键盘的底部
        // _faceView.transform = _originTransform;
        _faceView.top = ScreenHeight;
        keyboard.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        faceButton.alpha = 1;
    }];
}



#pragma mark editorBar Action
- (void)buttonAction:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 10:
            // 点击了定位按钮
            [self location];
            break;
        case 11:
            // 点击了拍照按钮
            [self selectImage];
            break;
        case 12:
            // 点击了添加话题按钮
            break;
        case 13:
            // 点击了AT用户按钮
            break;
        case 14:
            // 点击了显示表情按钮
            [self showFaceView];
            break;
        case 15:
            // 点击了显示键盘按钮
            [self showKeyboardWithDelegate:NO];
            break;
            
        default:
            break;
    }
    
}


#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerControllerSourceType sourceType;
    
    if (buttonIndex == 0) {
        //判断是否有摄像头
        BOOL isCamera =  [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        
        if (!isCamera)
        {
            
            UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:@"Alert"
                                                                message:@"此设备没有摄像头"
                                                               delegate:self
                                                      cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            return;
        }
        
        // 拍照
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if(buttonIndex == 1)
    {
        // 用户相册
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        // sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if(buttonIndex == 2)
    {
        // 取消
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
    [imagePicker release];
    
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // NSLog(@"[lbb]info = %@",info);
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.sendImage = image;
    
    
    //    因为button在有图片时才有，所以在此时创建
    if (self.sendImageButton == nil) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.frame = CGRectMake(12, 33, 25, 25);
        [button addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
        self.sendImageButton = button;
        
    }
    
    UIImage *icon = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.5)];
    [self.sendImageButton setImage:icon forState:UIControlStateNormal];
    
    [self.editorToolbar addSubview:self.sendImageButton];
    
    /*
    UIButton *button1 =[_buttons objectAtIndex:0];
    UIButton *button2 =[_buttons objectAtIndex:1];
    [UIView animateWithDuration:0.5 animations:^{
        
        
        button1.transform = CGAffineTransformTranslate(button1.transform, 20, 0);
        button2.transform = CGAffineTransformTranslate(button2.transform,5, 0);
        // 这里之所以用transform 不用设置frame就是因为button1.transform = CGAffineTransformIdentity 这句可以很方便的在不选图片的情况下让这两个button回到原来的位置。
        // button1.transform = CGAffineTransformIdentity;
    }];
     */
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardShowNotification:)
                                                     name:UIKeyboardDidShowNotification object:nil];
    }
    
    self.isCancelButton = YES;
    return self;
}

- (void)keyboardShowNotification:(NSNotification *)notification
{
    // NSLog(@"%@", notification.userInfo);
    // UIKeyboardFrameEndUserInfoKey
    NSValue *userInfoValue = notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyboardFrame = [userInfoValue CGRectValue];
    CGFloat h = keyboardFrame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.editorToolbar.bottom = ScreenHeight - (h); // 20+44
        self.textVIew.height = self.editorToolbar.top;
    }];
    
    
}

#pragma mark -- UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // 显示键盘
    [self showKeyboardWithDelegate:YES];
    // [self.textVIew becomeFirstResponder];
    return YES;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"POST";
    self.buttons = [[NSMutableArray alloc] init];
    
    
    //设置item普通状态
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    attrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    //设置item不可用状态
    NSMutableDictionary *disabledAttrs = [NSMutableDictionary dictionary];
    disabledAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    disabledAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];

    UIButton *sendbutton = [UIFactory creatNavigationButton:CGRectMake(0, 0, 45, 30) title:@"发送" target:self action:@selector(sendAction:)];
    // sendbutton.tintColor = [UIColor colorWithRed:0.132811 green:0.68377 blue:0.102996 alpha:1];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc]initWithCustomView:sendbutton];
    self.navigationItem.rightBarButtonItem = [sendItem autorelease];

    
    
    [self initView];
    UIButton *firstButton = [self.buttons firstObject];
    firstButton.frame = CGRectMake(17, 2, 30, 30);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_faceView release];
    [_textVIew release];
    [_editorToolbar release];
    [_placeBackgrougView release];
    [_placeLabel release];
    [_placeView release];
    [super dealloc];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
