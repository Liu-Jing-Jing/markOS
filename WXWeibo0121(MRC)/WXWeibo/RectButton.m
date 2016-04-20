//
//  RectButton.m
//  WXWeibo

#import "RectButton.h"

@implementation RectButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initView];
    }
    
    return self;
}


- (void)initView
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 22)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 22)];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.font = [UIFont systemFontOfSize:12];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.text = self.title;
    [_titleLabel sizeToFit];
    _titleLabel.center = self.center;
    _titleLabel.top = 6;
    
    _subtitleLabel.text = self.subtitle;
    [_subtitleLabel sizeToFit];
    _subtitleLabel.center = self.center;
    _subtitleLabel.top = _titleLabel.bottom+3;
    
}

- (void)setTitle:(NSString *)newTitle
{
    if (_title != newTitle)
    {
        [_title release];
        _title = [newTitle retain];
        _titleLabel.text = _title;
        [self setNeedsLayout];
    }
}

- (void)setSubtitle:(NSString *)newSubtitle
{
    if (_subtitle != newSubtitle)
    {
        [_subtitle release];
        _subtitle  =[newSubtitle retain];
        _subtitleLabel.text = _subtitle;
        [self setNeedsLayout];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
