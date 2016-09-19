//
//  MKImageView.m
//  WXWeibo

#import "MKImageView.h"

@implementation MKImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil)
    {
        self.userInteractionEnabled = YES;
        
        // Tap
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
    }
    
    return self;
}


- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.touchBlock)
    {
        _touchBlock();
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    Block_release(_touchBlock);
    [super dealloc];
}

@end
