//  SendViewController.h
//  WXWeibo

#import "BaseViewController.h"

@interface SendViewController : BaseViewController


// send data
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,copy)UIImage *sendImage;
@property (nonatomic,retain)UIButton *sendImageButton;

@property (retain, nonatomic) IBOutlet UITextView *textVIew;
@property (retain, nonatomic) IBOutlet UIView *editorToolbar;
@property (retain, nonatomic) IBOutlet UIImageView *placeBackgrougView;
@property (retain, nonatomic) IBOutlet UILabel *placeLabel;
@property (retain, nonatomic) IBOutlet UIView *placeView;
@end
