//
//  NJDXDALRequest.m
//  NJDXDAL
//
//  Created by LimeStore on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALRequest.h"
#import "NJDXDALParam.h"


@implementation NJDXDALRequest
{
    NJDXDALHTTPOperation* _opeartion;
    NSMutableArray* _params;
}

-(NJDXDALRequest*)initWithOperation:(NJDXDALHTTPOperation*)operation
{
    self = [super init];
    if(self)
    {
        _opeartion = operation;
        _params = [NSArray array];
    }
    return self;
}


-(void)start
{
    //adding params
    NSMutableString* paramString = [NSMutableString new];
    for(int i = 0; i < [_params count]; i++)
    {
        if(i == 0)
        {
            [paramString stringByAppendingString:[NSString stringWithFormat:@"%@", [[_params objectAtIndex:i] toString]]];
        }
        else 
        {
            [paramString stringByAppendingString:[NSString stringWithFormat:@"&%@", [[_params objectAtIndex:i] toString]]];
        }
    }
    [_opeartion.request setHTTPBody: [paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [_opeartion start];
}

-(void)cancel
{
    [_opeartion cancel];
}

-(void)addParam:(NSString*)key value:(NSString*)aValue
{
    NJDXDALParam* param = [[NJDXDALParam alloc] initWithKey:key value:aValue];
    [_params addObject: param];
}

@end
