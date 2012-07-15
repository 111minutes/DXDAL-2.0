//
//  SmartParser.m
//  SmartParser
//
//  Created by android on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALParserJSON.h"

@implementation NJDXDALParserJSON

- (id)parseData:(NSData*) aData;
{
    NSError *serializationError = nil;
    id JSONObj = [NSJSONSerialization JSONObjectWithData:aData 
                                                 options:NSJSONReadingAllowFragments 
                                                   error:&serializationError]; 
    if (serializationError==nil && [NSJSONSerialization isValidJSONObject:JSONObj]) {
        if ([JSONObj isKindOfClass:[NSDictionary class]] ||
            [JSONObj isKindOfClass:[NSArray class]]) {
            return JSONObj;
        } 
        else {
            NSLog(@"JSON is not array or dictionary!");
            return nil;
        }
    }
    else {
        NSLog(@"invalid JSON!");
        NSLog(@"serialization error: %@", serializationError);
        return nil;
    }
}

@end
