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
    NSArray *parsers = [NSArray arrayWithObjects: [NJDXDALParserXML class], [NJDXDALParserJSON class], nil];
    id parsedData = nil;    
    for (Class<NJDXDALParserProtocol> currentClass in parsers) {
        if ([currentClass isDataTypeAcceptable: aType]) {
            parsedData = [currentClass parseData:aData];
            [_delegate didFinishedParsing:parsedData];
            NSLog(@"NJDXDALParser: data type recognized - %@", aType);
            return parsedData;
        }
    }
    return nil;
}

@end
