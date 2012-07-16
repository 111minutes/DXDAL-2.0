//
//  NJDXDALParsingCenter.m
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALParsingCenter.h"
#import "NJDXDALHTTPOperation.h"
#import "NJDXDALParsingOperation.h"
#import "NJDXDALParser.h"

@interface NJDXDALParsingCenter() <NJDXDALParsingOperationDelegate>
{
    NSOperationQueue *_parsingQueue;
    NJDXDALParser *_parser;
}
@end


@implementation NJDXDALParsingCenter

- (NJDXDALParsingCenter *)init
{
    self = [super init];
    if(self)
    {
        _parsingQueue = [NSOperationQueue new];
        _parser = [NJDXDALParser new];
    }
    return self;
}

- (void)addForParsingURLOperation:(NJDXDALHTTPOperation *)op 
{
    NJDXDALParsingOperation *parsingOperation = [[NJDXDALParsingOperation alloc] initWithParentURLOperation:op parser: _parser];
    parsingOperation.delegate = self;
    
    if(!_parser.delegate) {
        _parser.delegate = op.mapper;
    }
    
    [_parsingQueue addOperation:parsingOperation];
}

- (void)didFinishParsing:(NJDXDALParsingOperation*)parsOp
{
    parsOp.parentURLOperation.isFinished = YES;
    NSLog(@"ParsingСenter message: parsing/mapping operation's finished");
}

-(void)cancellOperationWithParent:(NJDXDALHTTPOperation*)op
{
    NSArray* operations = [_parsingQueue operations];
    for(NJDXDALParsingOperation* pOp in operations)
    {
        if([pOp.parentURLOperation isEqual:op])
        {
            [pOp cancel];
        }
    }
}

@end
