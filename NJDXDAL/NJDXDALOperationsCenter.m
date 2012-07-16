//
//  NJDXDALOperationsCenter.m
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALOperationsCenter.h"
#import "NJDXDALHTTPOperation.h"

@interface NJDXDALOperationsCenter () <NJDXDALHTTPOperationDelegate>
{
    NSOperationQueue *_opQueue;
}

-(NJDXDALOperationsCenter *)initWithRunLoopManager:(NJDXDALRunLoopController *)rlm;

@end


@implementation NJDXDALOperationsCenter

@synthesize runLoopManager = _runLoopManager, parsingManager = _parsingManager;

-(NJDXDALOperationsCenter *)init
{
    self = [self initWithRunLoopManager:[NJDXDALRunLoopController new]];
    return self;
}

-(NJDXDALOperationsCenter *)initWithRunLoopManager:(NJDXDALRunLoopController *)rlm
{
    self = [super init];
    if(self) {
        _opQueue = [NSOperationQueue new];
        _runLoopManager = rlm;
        _parsingManager = [NJDXDALParsingCenter new];
    }
    return self;
}

-(NJDXDALHTTPOperation *)addRequest:(NSString *)url contentType:(NSString *)aContentType
{
    return [[NJDXDALHTTPOperation alloc] initWithURL:url delegate:self thread:_runLoopManager.thread contentType:aContentType];
}

-(void)cancelOperation:(NJDXDALOperation *)operation
{
    NSArray *operations = [_opQueue operations];
    for(NJDXDALHTTPOperation *op in operations)
    {
        if([op isEqual:operation]) {
            [op cancel];
            [_parsingManager cancellOperationWithParent:op]; // cancelling parsing operation
        }
    }
}

-(void)loadingFinished:(NJDXDALHTTPOperation *)op
{
    NSLog(@"HTTPOperationsCenter message: Loading data is finished.");
    [_parsingManager addForParsingURLOperation:op];
}

-(void)startOperation:(NJDXDALHTTPOperation *)op
{
    [_opQueue addOperation:op];
}

@end
