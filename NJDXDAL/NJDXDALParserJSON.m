//
//  SmartParser.m
//  SmartParser
//
//  Created by android on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALParserJSON.h"

@implementation NJDXDALParserJSON

+ (id)parseData:(NSData *) aData error:(NSError *)anError;
{
    id JSONObj = [NSJSONSerialization JSONObjectWithData:aData 
                                                 options:NSJSONReadingAllowFragments 
                                                   error:&anError]; 
    if (anError==nil && [NSJSONSerialization isValidJSONObject:JSONObj]) {
        if ([JSONObj isKindOfClass:[NSDictionary class]] ||
            [JSONObj isKindOfClass:[NSArray class]]) {
            return JSONObj;
        } 
        else {
            NSLog(@"NJDXDALParserJSON: JSON is not array or dictionary!");
            anError = [NSError errorWithDomain:@"JSON is not array or dictionary" code:0 userInfo:nil];
            return nil;
        }
    }
    else {
        NSLog(@"NJDXDALParserJSON: invalid JSON!");
        NSLog(@"NJDXDALParserJSON: serialization error: %@", anError);
        return nil;
    }
}

+ (BOOL)isDataTypeAcceptable:(NSString *)type;
{
    type = [type lowercaseString];
    if ([type isEqualToString:@"json"]){
        return YES;
    }
    else {
        return NO;
    }
}

@end
