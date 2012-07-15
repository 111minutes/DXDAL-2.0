//
//  NJDXDALMappingError.m
//  NJDXDAL
//
//  Created by Yury Grinenko on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALMappingError.h"

@implementation NJDXDALMappingError

@synthesize className = _className;
@synthesize propertyName = _propertyName;
@synthesize propertyValue =  _propertyValue;

- (id)initWithclassName:(NSString *)className propertyName:(NSString *)propertyName propertyValue:(id)propertyValue {
    self = [super init];
    if (self) {
        _className = className;
        _propertyName = propertyName;
        _propertyValue = propertyValue;
    }
    return self;
}

@end
