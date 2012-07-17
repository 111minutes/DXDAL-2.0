//
//  Article.m
//  TestConnection
//
//  Created by Yury Grinenko on 09.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "Article.h"

@implementation Article

@synthesize author = _author;
@synthesize body = _body;
@synthesize publicationDate = _publicationDate;
@synthesize title = _title;
@synthesize copies = _copies;
@synthesize prices = _prices;

- (id)initWithAuthor:(NSString *)author andBody:(NSString *)body andPublicationDate:(NSString *)publicationDate andTitle:(NSString *)title andCopies:(NSInteger)copies {
    
    self = [super init];
    if (self) {
        self.author = author;
        self.body = body;
        self.publicationDate = publicationDate;
        self.title = title;
        self.copies = copies;
    }    
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"author = %@, body = %@, publicationDate = %@, title = %@, copies = %d",_author, _body, _publicationDate, _title, _copies]; 
    
}

@end