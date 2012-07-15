//
//  NJDXDALMappingError.h
//  NJDXDAL
//
//  Created by Yury Grinenko on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJDXDALMappingError : NSObject

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) id propertyValue;

- (id)initWithclassName:(NSString *)className propertyName:(NSString *)propertyName propertyValue:(id)propertyValue;

@end
