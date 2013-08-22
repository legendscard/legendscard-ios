
//
//  JS7Button.m
//  Merge
//
//  Created by Josh Sklar on 7/22/13.
//  Copyright (c) 2013 Josh Sklar. All rights reserved.
//

#import "JS7Button.h"

@implementation JS7Button
{
    block tappedButtonBlock;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAdjustsImageWhenHighlighted:NO];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setTextColor:(UIColor*)mainColor_ highlightedTextColor:(UIColor*)highLightedColor_
{
    [self setTitleColor:mainColor_ forState:UIControlStateNormal];
    [self setTitleColor:highLightedColor_ forState:UIControlStateHighlighted];
}

- (void)performBlockOnTouchUpInside:(block)b
{
    tappedButtonBlock = b;
    [self addTarget:self action:@selector(didTapBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTitle:(NSString*)title
{
    [super setTitle:title forState:UIControlStateNormal];
}

- (void)didTapBtn:(id)sender
{
    tappedButtonBlock(sender);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
