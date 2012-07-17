//
//  Article.h
//  TestConnection
//
//  Created by Yury Grinenko on 09.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *publicationDate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger copies;
@property (nonatomic, assign) NSArray *prices;

- (id)initWithAuthor:(NSString *)author andBody:(NSString *)body andPublicationDate:(NSString *)publicationdate andTitle:(NSString *)title andCopies:(NSInteger)copies;

@end
