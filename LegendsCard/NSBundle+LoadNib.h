//
//  NSBundle+LoadNib.h
//  LegendsCard
//
//  Created by Josh Sklar on 6/26/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//


#import <Foundation/Foundation.h>
@interface NSBundle (LoadNib)

-(id)loadFromNib:(NSString*)nibName withClass:(Class)class;

@end
