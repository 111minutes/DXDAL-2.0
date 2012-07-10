//
//  NJDXDALRequestBuilderTests.m
//  NJDXDAL
//
//  Created by Maks on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALRequestBuilderTests.h"
#import "NJDXDALRequestBuilder.h"

@implementation NJDXDALRequestBuilderTests

- (void)testRequestBuilderBlock
{
    NJDXDALRequestBuilder *requestBuilder = [[NJDXDALRequestBuilder alloc] init];
    
    NSMutableURLRequest *req = [NSMutableURLRequest new];
    NJDXDALRequestConfigurationBlock configBlock = ^(NSMutableURLRequest *request)
    {
        request.HTTPMethod = @"POST";
        request.URL = [NSURL URLWithString:@"url"];
    };
    
    [requestBuilder operationWithRequest:req configurationBlock:configBlock];
    STAssertTrue([req.HTTPMethod isEqualToString:@"POST"],@"should be equal");
    STAssertTrue([req.URL isEqual:[NSURL URLWithString:@"url"]],@"should be equal");
}

@end
