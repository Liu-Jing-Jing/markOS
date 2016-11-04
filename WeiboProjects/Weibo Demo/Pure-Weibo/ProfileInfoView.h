//  ProfileInfoView.h
//  WXWeibo

#import <UIKit/UIKit.h>
@class RectButton;
@class UserModel;


@interface ProfileInfoView : UIView

@property (retain, nonatomic) UserModel *userModel;
@property (assign, nonatomic) long int followingCount;
@property (assign, nonatomic) long int fansCount;
@property (assign, nonatomic) long int weibosCount;


@property (retain, nonatomic) IBOutlet UIImageView *userImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel;
@property (retain, nonatomic) IBOutlet UILabel *countLabel;

@property (retain, nonatomic) IBOutlet RectButton *attButton; // 关注的按钮
@property (retain, nonatomic) IBOutlet RectButton *fansButton;
@property (retain, nonatomic) IBOutlet RectButton *weiboCountButton;
@end
