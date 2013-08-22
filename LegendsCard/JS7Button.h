//
//  JS7Button.h
//  Merge
//
//  Created by Josh Sklar on 7/22/13.
//  Copyright (c) 2013 Josh Sklar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^block)(id sender);

@interface JS7Button : UIButton

- (void)performBlockOnTouchUpInside:(block)b;

- (void)setTitle:(NSString*)title;

- (void)setTextColor:(UIColor*)mainColor_ highlightedTextColor:(UIColor*)highLightedColor_;

@end
