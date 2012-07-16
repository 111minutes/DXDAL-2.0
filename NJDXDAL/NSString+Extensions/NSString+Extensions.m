//
//  NSString+Extensions.m
//  TestConnection
//
//  Created by Yury Grinenko on 11.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extended)

- (NSString *)firstCharacterUpperCase 
{
    NSMutableString *tempString = [self mutableCopy];
    NSString *firstCharacter = [[self substringWithRange:NSMakeRange(0,1)] uppercaseString];
    [tempString replaceCharactersInRange:NSMakeRange(0,1) withString:firstCharacter];
    return tempString;
}

- (NSString *)pluralize 
{
    NSString *irregularPath = [[NSBundle mainBundle] pathForResource:@"irregularNouns" ofType:@"plist"];
    NSDictionary *irregularNounsDictionary = [NSDictionary dictionaryWithContentsOfFile:irregularPath];
    NSString *key;
    NSString *newEnd = nil;
    NSMutableString *mutableStringValue = [[self lowercaseString] mutableCopy];
    for (key in [irregularNounsDictionary allKeys]) {
        if ([mutableStringValue hasSuffix:key]) {
            newEnd = [irregularNounsDictionary valueForKey:key];
            break;
        }
    }
    if (!newEnd) {
        NSString *nounsEndsPath = [[NSBundle mainBundle] pathForResource:@"nounsEnds" ofType:@"plist"];
        NSDictionary *nounsEndsDictionary = [NSDictionary dictionaryWithContentsOfFile:nounsEndsPath];
        for (key in [nounsEndsDictionary allKeys]) {
            if ([mutableStringValue hasSuffix:key]) {
                newEnd = [nounsEndsDictionary valueForKey:key];
                break;
            }
        }
    }
    if (newEnd) {
        NSMutableString *returnString = [[mutableStringValue substringToIndex:[mutableStringValue length]-[key length]] mutableCopy];
        [returnString appendString:newEnd];
        return returnString;
    }
    else {
        [mutableStringValue appendString:@"s"];
        return mutableStringValue;
    }
}

- (NSString *)camelizeWithLowerFlag:(BOOL)lowerFlag 
{
    NSMutableArray *wordsArray = [NSMutableArray new];
    int upperCasePosition = 0;
    for (int i = 1; i < [self length]; i++) {
        if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
            [wordsArray addObject:[NSString stringWithFormat:@"%@_",[self substringWithRange:NSMakeRange(upperCasePosition, i-upperCasePosition)]]];
            upperCasePosition = i;
        }
    }
    [wordsArray addObject:[self substringWithRange:NSMakeRange(upperCasePosition, [self length] - upperCasePosition)]];
    
    NSMutableString *tempString;
    NSMutableString *resultString = [NSMutableString new];
    for (NSInteger i = 0; i < [wordsArray count]; i++) {
        tempString = [[wordsArray objectAtIndex:i] mutableCopy];
        if (lowerFlag) {
            tempString = (NSMutableString *)[tempString lowercaseString];
        }
        [resultString appendString:tempString];
    }
    return resultString;
}

@end
