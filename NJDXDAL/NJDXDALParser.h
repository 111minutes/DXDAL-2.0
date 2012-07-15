//
//  SmartParser.h
//  SmartParser
//
//  Created by android on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SmartParserDelegate <NSObject>

- (void)didFinishedParsing:(id) data;
- (void)didFailedWithError:(NSError*) error;

@end

@interface NJDXDALParser : NSObject

@property (nonatomic, strong) id<SmartParserDelegate> delegate;

- (id)parseData:(NSData *)aData type:(NSString *)aType;

@end
