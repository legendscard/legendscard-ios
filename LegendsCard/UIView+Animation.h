//
//  UIView+Animation.h
//  LegendsCard
//
//  Created by Josh Sklar on 7/3/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIViewMoveDirectionLeft,
    UIViewMoveDirectionRight,
    UIViewMoveDirectionUp,
    UIViewMoveDirectionDown
} UIViewMoveDirection;

@interface UIView (Animation)
-(void)partialFadeWithDuration: (NSTimeInterval) duration afterDelay: (NSTimeInterval) delay withFinalAlpha:(double)finalAlpha completionBlock:(void (^)(BOOL finished))block;

-(void)shakeScreen;
-(void)move:(UIViewMoveDirection)direction by:(NSInteger)amount withDuration:(NSTimeInterval)duration completionBlock:(void (^)(BOOL finished))block;
@end
