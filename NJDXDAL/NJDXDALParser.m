//
//  SmartParser.m
//  SmartParser
//
//  Created by android on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALParser.h"
#import "NJDXDALParserJSON.h"
#import "NJDXDALParserXML.h"

@implementation NJDXDALParser

@synthesize delegate = _delegate;

- (id)parseData:(NSData *)aData type:(NSString *)aType;
{
    id<NJDXDALParserProtocol> parser;
    id parsedData = nil;
    
    if ([aType isEqualToString:@"json"]) {
        NSLog(@"data type recognized: %@", aType);
        parser = [NJDXDALParserJSON new];
    }
    else if ([aType isEqualToString:@"xml"]) {
        NSLog(@"data type recognized: %@", aType);
        parser = [NJDXDALParserXML new];
    }
    else if ([aType isEqualToString:@"bplist"]){
        NSLog(@"data type recognized: %@", aType);
    }
    else {
        NSLog(@"don't recognise data type!");
        return nil;
    }
    parsedData = [parser parseData:aData];    
    [_delegate didFinishedParsing:parsedData];
    return parsedData;
}

@end
