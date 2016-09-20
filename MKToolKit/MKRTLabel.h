//
//  RTLabel.h
//  Pure-Weibo
//
//  Created by Mark Lewis on 16-8-15.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.


#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

typedef enum
{
	RTTextAlignmentRight = kCTRightTextAlignment,
	RTTextAlignmentLeft = kCTLeftTextAlignment,
	RTTextAlignmentCenter = kCTCenterTextAlignment,
	RTTextAlignmentJustify = kCTJustifiedTextAlignment
} RTTextAlignment;

typedef enum
{
	RTTextLineBreakModeWordWrapping = kCTLineBreakByWordWrapping,
	RTTextLineBreakModeCharWrapping = kCTLineBreakByCharWrapping,
	RTTextLineBreakModeClip = kCTLineBreakByClipping,
}RTTextLineBreakMode;

@protocol RTLabelDelegate <NSObject>

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url;

@end

@interface RTLabel : UIView {
	NSString *_text;
	UIFont *font;
	UIColor *textColor;
	RTTextAlignment _textAlignment;
	RTTextLineBreakMode _lineBreakMode;
	NSString *_plainText;
	NSMutableArray *_textComponents;
	CGSize _optimumSize;
	CGFloat _lineSpacing;
	int currentSelectedButtonComponentIndex;
	NSDictionary *linkAttributes;
    NSDictionary *selectedLinkAttributes;
	__weak id<RTLabelDelegate> delegate;
	CTFrameRef frame;
    CFRange visibleRange;
    NSString *paragraphReplacement;
}

@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) NSDictionary *linkAttributes;
@property (nonatomic, retain) NSDictionary *selectedLinkAttributes;
@property (nonatomic, weak) id<RTLabelDelegate> delegate;
@property (nonatomic, copy) NSString *paragraphReplacement;

- (NSString*)text;
- (void)setText:(NSString*)text;

- (void)setTextAlignment:(RTTextAlignment)textAlignment;
- (void)setLineBreakMode:(RTTextLineBreakMode)lineBreakMode;

- (CGSize)optimumSize;
- (void)setLineSpacing:(CGFloat)lineSpacing;
- (NSString*)visibleText;

@end
