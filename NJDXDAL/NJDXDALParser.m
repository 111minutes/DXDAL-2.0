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
<<<<<<< HEAD
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
=======
    NSLog(@"NJDXDALParser: data type DID NOT recognized - %@", aType);
    return nil;
>>>>>>> 52d0c4de9f638ea0a9a2eea0a6c41e65e2d5aa3c
}

@end
