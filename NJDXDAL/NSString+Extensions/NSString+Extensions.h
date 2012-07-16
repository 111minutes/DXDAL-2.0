//
//  NSString+Extensions.h
//  TestConnection
//
//  Created by Yury Grinenko on 11.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extended)

- (NSString *)firstCharacterUpperCase;
- (NSString *)pluralize;
- (NSString *)camelizeWithLowerFlag:(BOOL)lowerFlag;

@end
