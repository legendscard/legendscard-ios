//
//  UIView+Animation.m
//  LegendsCard
//
//  Created by Josh Sklar on 7/3/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "UIView+Animation.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Animation)

-(void) partialFadeWithDuration: (NSTimeInterval) duration afterDelay: (NSTimeInterval) delay withFinalAlpha:(double)finalAlpha completionBlock:(void (^)(BOOL finished))block {
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self setAlpha:finalAlpha];
                         
                     } 
                     completion:block];
}

-(void)shakeScreen {
    CABasicAnimation *animation = 
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.1];
    [animation setRepeatCount:2];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake(self.center.x - 10.0f, self.center.y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake(self.center.x + 10.0f, self.center.y)]];
    [self.layer addAnimation:animation forKey:@"position"];
}

-(void)move:(UIViewMoveDirection)direction by:(NSInteger)amount withDuration:(NSTimeInterval)duration completionBlock:(void (^)(BOOL finished))block {
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (direction == UIViewMoveDirectionUp) {
                             [self setCenter:CGPointMake(self.center.x, self.center.y-amount)];
                         }
                         if (direction == UIViewMoveDirectionDown) {
                             [self setCenter:CGPointMake(self.center.x, self.center.y+amount)];
                         }
                         if (direction == UIViewMoveDirectionLeft) {
                             [self setCenter:CGPointMake(self.center.x - amount, self.center.y)];
                         }
                         if (direction == UIViewMoveDirectionRight) {
                             [self setCenter:CGPointMake(self.center.x + amount, self.center.y)];
                         }
                     }
                     completion:block];
}

@end
