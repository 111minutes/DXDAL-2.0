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


@interface NJDXDALParsingCenter() <NJDXDALParsingOperationDelegate>
{
    NSOperationQueue* _parsingQueue;
}
@end


@implementation NJDXDALParsingCenter

-(NJDXDALParsingCenter*)init
{
    self = [super init];
    if(self)
    {
        _parsingQueue = [NSOperationQueue new];
    }
    return self;
}

-(void)addForParsingURLOperation:(NJDXDALHTTPOperation*)op 
{
    NJDXDALParsingOperation* parsingOperation = [[NJDXDALParsingOperation alloc] initWithParentURLOperation:op];
    parsingOperation.delegate = self;
    [_parsingQueue addOperation:parsingOperation];
}

-(void)didFinishParsing:(NJDXDALParsingOperation*)parsOp
{
    parsOp.parentURLOperation.isFinished = YES;
    //NSLog(@"ParsingManager message: parsing is finished");
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
