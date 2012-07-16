//
//  NJDXDALParsingOperation.m
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "NJDXDALParsingOperation.h"
#import "NJDXDALHTTPOperation.h"


@interface NJDXDALParsingOperation ()
{
    NSData *_data;
    NSString *_dataType;
    NJDXDALHTTPOperation *_parentURLOp;
    NJDXDALParser *_parser;
}
@end

@implementation NJDXDALParsingOperation

@synthesize delegate;
@synthesize isFinished = _isFinished, isExecuting = _isExecuting, isCancelled = _isCancelled;
@synthesize parsedData = _parsedData;

- (NJDXDALParsingOperation *)initWithParentURLOperation:(NJDXDALHTTPOperation *)parentOp parser:(NJDXDALParser *)aParser
{
    self = [super init];
    if(self) {
        _data = parentOp.receivedData;        
        _dataType = parentOp.contentType;
        _parentURLOp = parentOp;
        _parser = aParser;
    }
    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (NJDXDALHTTPOperation*)parentURLOperation
{
    return _parentURLOp;
}

- (void)start
{
    // start parsing work
    _parsedData = [_parser parseData:_data type:_dataType];
    [delegate didFinishParsing:self];
}

- (void)cancel
{
    _isExecuting = NO;
    _isCancelled = YES;
}

@end
