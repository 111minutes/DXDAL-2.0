//
//  NJDXDALParam.m
//  NJDXDAL
//
//  Created by LimeStore on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALParam.h"

@implementation NJDXDALParam

-(NJDXDALParam*)initWithKey:(NSString*)aKey value:(NSString*)aValue
{
    self = [super init];
    if(self)
    {
        _key = aKey;
        _value = aValue;
    }
    return self;
}

-(NSString*)toString
{
    return [NSString stringWithFormat:@"%@=%@",_key,_value];
}

@end
