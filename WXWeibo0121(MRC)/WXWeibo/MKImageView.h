//
//  MKImageView.h
//  WXWeibo

#import <UIKit/UIKit.h>
typedef void(^ImageBlock)(void);

@interface MKImageView : UIImageView

@property (nonatomic, copy) ImageBlock touchBlock;
@end
