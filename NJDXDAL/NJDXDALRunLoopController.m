//
//  NJDXDALRunLoopController.m
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALRunLoopController.h"

@interface NJDXDALRunLoopController()
{
    NSThread* _primaryThread;
}
@end


@implementation NJDXDALRunLoopController

-(NSThread*)thread
{
    return _primaryThread;
}

-(NJDXDALRunLoopController*)init
{
    self = [super init];
    if(self)
    {
        _primaryThread = [[NSThread alloc] initWithTarget:self selector:@selector(mainLoop) object:nil];
        [_primaryThread start];
    }
    return self;
}

-(void)mainLoop
{
    do
    {
        @autoreleasepool 
        {            
            [[NSRunLoop currentRunLoop] run];
        }
    }while (YES);
}

@end
