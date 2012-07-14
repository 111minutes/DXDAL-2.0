//
//  BookStore.m
//  TestConnection
//
//  Created by Yury Grinenko on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookStore.h"

@implementation BookStore

@synthesize name = _name;
@synthesize territory = _territory;
@synthesize catalogue = _catalogue;
@synthesize foundationDate = _foundationDate;
@synthesize numberOfArticles = _numberOfArticles;

- (NSString *)description 
{
    return [NSString stringWithFormat:@"name = %@ territory = %@ catalogue = %@ foundationDate = %@, numberOfArticles = %@", _name, _territory, _catalogue, _foundationDate, _numberOfArticles];
}

@end
