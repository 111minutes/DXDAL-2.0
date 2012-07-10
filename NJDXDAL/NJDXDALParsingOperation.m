//
//  NJDXDALParsingOperation.m
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALParsingOperation.h"
#import "NJDXDALHTTPOperation.h"

@interface NJDXDALParsingOperation ()
{
    NSData* _data;
    NJDXDALHTTPOperation* _parentURLOp;
}
@end


@implementation NJDXDALParsingOperation

@synthesize delegate;
@synthesize isFinished = _isFinished, isExecuting = _isExecuting, isCancelled = _isCancelled;


-(NJDXDALParsingOperation*)initWithParentURLOperation:(NJDXDALHTTPOperation*)parentOp
{
    self = [super init];
    if(self)
    {
        _data = parentOp.receivedData;
        _parentURLOp = parentOp;
    }
    return self;
}

-(BOOL)isConcurrent
{
    return YES;
}

-(NJDXDALHTTPOperation*)parentURLOperation
{
    return _parentURLOp;
}

-(void)start
{
    // some parsing work...
    [delegate didFinishParsing:self];
}

-(void)cancel
{
    _isExecuting = NO;
    _isCancelled = YES;
}


@end
