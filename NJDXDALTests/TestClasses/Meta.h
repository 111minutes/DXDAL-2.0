//
//  Meta.h
//  NJDXDAL
//
//  Created by Maks on 15.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meta : NSObject

@property (nonatomic, assign) NSInteger codeData;
@property (nonatomic, strong) NSString *errorType;
@property (nonatomic, strong) NSString *errorDetail;
@property (nonatomic, strong) NSString *something;

@end