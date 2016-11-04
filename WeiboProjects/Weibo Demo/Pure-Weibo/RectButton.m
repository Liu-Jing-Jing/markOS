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
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 69, 22)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, 69, 22)];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.textColor = [UIColor grayColor];
    _subtitleLabel.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:_titleLabel];
    [self addSubview:_subtitleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.text = self.title;
    // [_titleLabel sizeToFit];
    
    _subtitleLabel.text = self.subtitle;
    // [_subtitleLabel sizeToFit];
}

- (void)setTitle:(NSString *)newTitle
{
    if (_title != newTitle)
    {
        _title = newTitle;
        _titleLabel.text = _title;
    }
}

- (void)setSubtitle:(NSString *)newSubtitle
{
    if (_subtitle != newSubtitle)
    {
        _subtitle = newSubtitle;
        _subtitleLabel.text = _subtitle;
        // [self setNeedsDisplay];
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
