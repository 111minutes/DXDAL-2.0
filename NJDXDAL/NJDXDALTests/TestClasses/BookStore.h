//
//  BookStore.h
//  TestConnection
//
//  Created by Yury Grinenko on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookStore : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSNumber *territory;
@property (nonatomic, strong) NSArray *catalogue;
@property (nonatomic, strong) NSDate *foundationDate;
@property (nonatomic, strong) NSDictionary *numberOfArticles;

@end
