//
//  TestConnectionTests.m
//  TestConnectionTests
//
//  Created by Yury Grinenko on 03.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "NJDXDALArticleMappingTest.h"
#import "Article.h"
#import "NJDXDALMappingController.h"
#import "NJDXDALMappingConfigurator.h"

@interface NJDXDALArticleMappingTest () 
{
    NSArray *_mappedArray;
    NJDXDALMappingController *_mappingController;
    NJDXDALMappingConfigurator *_mappingConfigurator;
}

@end

@implementation NJDXDALArticleMappingTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testMapping
{
    Article *article1 = [[Article alloc] initWithAuthor:@"Blake Watters" andBody:@"This article details how to use RestKit object mapping..." andPublicationDate:@"7/4/2011" andTitle:@"RestKit Object Mapping Intro" andCopies:1];
    
    
    Article *article2 = [[Article alloc] initWithAuthor:@"Blake Watters" andBody:@"RestKit 1.0 has been released to much fanfare across the galaxy..." andPublicationDate:@"9/4/2011" andTitle:@"RestKit 1.0 Released" andCopies:2];
    
    _mappedArray = [NSArray arrayWithObjects:article1, article2, nil];
        
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"inputJSON" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    _mappingConfigurator = [[NJDXDALMappingConfigurator alloc] initForClass:[Article class]];
    
    _mappingController = [[NJDXDALMappingController alloc] initWithContainer:parsedData mappingConfigurator:_mappingConfigurator];
    NSArray *mappedResult = [_mappingController start];
    
    STAssertTrue([_mappedArray count] == [mappedResult count], @"Should be equals");
    for (int i = 0; i < [_mappedArray count]; i++) {
        STAssertEqualObjects([[_mappedArray objectAtIndex:i] description], [[mappedResult objectAtIndex:i] description], @"mapping works wrong!");
    }

}

@end
