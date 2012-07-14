//
//  BookStoreHardMappingTest.m
//  TestConnection
//
//  Created by Yury Grinenko on 13.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALBookStoreHardMappingTest.h"
#import "NJDXDALMappingController.h"
#import "NJDXDALMappingConfigurator.h"
#import "BookStore.h"
#import "Article.h"

@interface NJDXDALBookStoreHardMappingTest () 
{
    BookStore *_handMadeBookStore;
}
@end

@implementation NJDXDALBookStoreHardMappingTest

// All code under test must be linked into the Unit Test bundle
- (void)setUp
{
    _handMadeBookStore = [BookStore new];
    _handMadeBookStore.name = @"HappyBook";
    _handMadeBookStore.territory = [NSNumber numberWithFloat:24.56];
    
    Article *article1 = [[Article alloc] initWithAuthor:@"Blake Watters" andBody:@"This article details how to use RestKit object mapping..." andPublicationDate:@"7/4/2011" andTitle:@"RestKit Object Mapping Intro" andCopies:1];
    Article *article2 = [[Article alloc] initWithAuthor:@"Blake Watters" andBody:@"RestKit 1.0 has been released to much fanfare across the galaxy..." andPublicationDate:@"9/4/2011" andTitle:@"RestKit 1.0 Released" andCopies:2];
    _handMadeBookStore.catalogue = [NSArray arrayWithObjects:article1, article2, nil];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    _handMadeBookStore.foundationDate = [dateFormat dateFromString:@"20100223"];
     
    NSArray *keysArray = [NSArray arrayWithObjects:@"firstKey", @"secondKey", @"thirdKey", nil];
    NSArray *valuesArray = [NSArray arrayWithObjects:@"firstValue", @"secondValue", article1, nil];
    _handMadeBookStore.numberOfArticles = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
}

- (void)testMapping 
{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"inputJSONHarderWhenEver" ofType:@"txt"];
    NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath] options:kNilOptions error:nil];
    
    NJDXDALMappingConfigurator *rootConfigurator = [[NJDXDALMappingConfigurator alloc] initForClass:[BookStore class]];
    [rootConfigurator setMappingOfProperty:@"catalogue" toType:@"Article"];
    [rootConfigurator setDateFormat:@"yyyyMMdd"];
    [rootConfigurator setCorrespondenceOfProperty:@"numberOfArticles" toDataField:@"numberOf"];
        
    NJDXDALMappingConfigurator *numberOfArticlesConfigurator = [[NJDXDALMappingConfigurator alloc] initForClass:[NSDictionary class]];
    [numberOfArticlesConfigurator setMappingOfProperty:@"thirdKey" toType:@"Article"];
    
    [rootConfigurator setMappingOfProperty:@"numberOfArticles" toMappingConfigurator:numberOfArticlesConfigurator];
        
    NJDXDALMappingController *mappingController = [[NJDXDALMappingController alloc] initWithContainer:parsedData mappingConfigurator:rootConfigurator];
    NSArray *mappedResult = [mappingController start];
    
    STAssertEqualObjects([_handMadeBookStore description], [[mappedResult objectAtIndex:0] description], @"Mapping failed");    
}

@end
