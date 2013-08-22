//
//  NSBundle+LoadNib.m
//  LegendsCard
//
//  Created by Josh Sklar on 6/26/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "NSBundle+LoadNib.h"

@implementation NSBundle (LoadNib)

- (id)loadFromNib:(NSString*)nibName withClass:(Class)class
{
	NSArray *objects = [self loadNibNamed:nibName owner:nil options:0];
	for (id obj in objects) {
		if ([obj isKindOfClass:class]) {
			return obj;
		}
	}	
	return nil;
}

@end
