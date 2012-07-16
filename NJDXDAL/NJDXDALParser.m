//
//  SmartParser.m
//  SmartParser
//
//  Created by android on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <objc/runtime.h>
#import "NJDXDALParser.h"
#import "NJDXDALParserJSON.h"
#import "NJDXDALParserXML.h"
#import "NJDXDALParserProtocol.h"

@interface NJDXDALParser ()

- (NSArray*)retrieveParsers;

@end

@implementation NJDXDALParser

@synthesize delegate = _delegate;

- (id)parseData:(NSData *)aData type:(NSString *)aType;
{
    NSArray *parsers = [NSArray arrayWithArray: [self retrieveParsers]];
    id parsedData = nil;    
    NSError *error = nil;
    for (Class<NJDXDALParserProtocol> currentClass in parsers) {
        if ([currentClass isDataTypeAcceptable: aType]) {
            NSLog(@"NJDXDALParser: data type recognized - %@", aType);
            parsedData = [currentClass parseData:aData error: error];
            if (!error) {
                [_delegate didFinishedParsing:parsedData];
                return parsedData;
            }
            else {
                [_delegate didFailedWithError:error];
                return nil;
            }
        }
    }
    
    NSLog(@"NJDXDALParser: data type DID NOT recognized - %@", aType);
    error = [NSError errorWithDomain:[NSString stringWithFormat:@"Parsing error. Data type %@ did not recognized.", aType] 
                                code:1 userInfo:nil];
    [_delegate didFailedWithError:error];
    return nil;
}

- (NSArray*)retrieveParsers
{
    Class rootClass = [NSObject class];
    NSMutableArray *parsers = [NSMutableArray array];
    
    int classesAmount = objc_getClassList(NULL, 0);
    
    Class *allClasses = (Class*) malloc(sizeof(Class) * classesAmount);
    classesAmount = objc_getClassList(allClasses, classesAmount);   
    
    NSString *parserNameTemplate = @"NJDXDALParser";
    
    for (uint i = 0; i < classesAmount; i++) {
        Class superClass = allClasses[i];        
        do {
            superClass = class_getSuperclass(superClass);
        } while (superClass && superClass != rootClass);                
        if (superClass != nil) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@ and self.length > %i", parserNameTemplate, [parserNameTemplate length]];
            if ([predicate evaluateWithObject:NSStringFromClass([allClasses[i] class])] &&
                [[allClasses[i] class] conformsToProtocol: @protocol(NJDXDALParserProtocol)]) {
                [parsers addObject:allClasses[i]];
            }
        }
    }    
    free(allClasses);     
    return parsers;
}

@end
