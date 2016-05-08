//  SendViewController.m
//  WXWeibo

#import "SendViewController.h"
#import "UIFactory.h"
@interface SendViewController ()
@property (retain, nonatomic) NSMutableArray *buttons;
@end

@implementation SendViewController


#pragma mark - Action
- (void)cancelAction:(UIButton *)sender
{
    [self.textVIew resignFirstResponder];
    [self.appDelegate.menuCtrl dismissViewControllerAnimated:YES completion:NULL];
}

- (void)sendAction:(UIButton *)sender
{
    [self doSendData];
}

- (void)doSendData
{
    if (self.textVIew.text.length == 0)
    {
        NSLog(@"微博内容为空");
        return;
    }
    
    NSString *text = self.textVIew.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:text forKey:@"status"];
    [self.sinaweibo requestWithURL:@"statuses/update.json"
                            params:params
                        httpMethod:@"POST"
                             block:^(id result) {
                                 // 发布成功
                                 [self doSendDataFinished:result];
                             }];
    
}

- (void)doSendDataFinished:(NSDictionary *)result
{
    //
    NSLog(@"微博发送成功:%@", result);
    [self.textVIew resignFirstResponder];
    [self.appDelegate.menuCtrl dismissViewControllerAnimated:YES completion:NULL];
}


- (void)initView
{
    
    //show keyboard
    [self.textVIew becomeFirstResponder];
    
    
    NSArray *imageNames = @[@"compose_locatebutton_ready 2.png",
                           @"compose_camerabutton_background.png",
                           @"compose_trendbutton_background.png",
                           @"compose_emoticonbutton_background.png",
                           @"compose_keyboardbutton_background.png"
                           ];
    
    NSArray *imageHighlighedName = @[@"compose_locatebutton_succeeded 3.png",
                                     @"compose_camerabutton_background_highlighted.png",
                                     @"compose_trendbutton_background_highlighted 3.png",
                                     @"compose_emoticonbutton_background_highlighted 2.png",
                                     @"compose_keyboardbutton_background_highlighted 3.png"
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
        button.frame = CGRectMake(20+(64*i), 5, 24, 24);
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
}

#pragma mark editorBar Action
- (void)buttonAction:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 10:
            //
            break;
        case 11:
            //
            break;
        case 12:
            //
            break;
        case 13:
            //
            break;
        case 14:
            //
            break;
            
        default:
            break;
    }
    
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
    
    return self;
}

- (void)keyboardShowNotification:(NSNotification *)notification
{
    // NSLog(@"%@", notification.userInfo);
    // UIKeyboardFrameEndUserInfoKey
    NSValue *userInfoValue = notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyboardFrame = [userInfoValue CGRectValue];
    CGFloat h = keyboardFrame.size.height;
    
    self.editorToolbar.bottom = ScreenHeight - (h); // 20+44
    self.textVIew.height = self.editorToolbar.top;
    
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

    // button
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    // cancel.titleLabel.textColor = [UIColor colorWithRed:0.132811 green:0.68377 blue:0.102996 alpha:1];
    [cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancel];
    [cancelItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [cancelItem autorelease];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    sendButton.titleLabel.textColor = [UIColor colorWithRed:0.132811 green:0.68377 blue:0.102996 alpha:1];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
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
    [_textVIew release];
    [_editorToolbar release];
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
