//
//  NJDXDALHTTPOperation.m
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "NJDXDALHTTPOperation.h"
#import "NJDXDALParam.h"

@interface NJDXDALHTTPOperation ()
{
    NSURLConnection* _connection;
    NSMutableData *_receivedData;
    NSThread* _thread;
    NSMutableArray* _params;
}
@end


@implementation NJDXDALHTTPOperation

@synthesize delegate, request = _request;
@synthesize isFinished = _isFinished, isExecuting = _isExecuting, isCancelled = _isCancelled;
@synthesize httpPath = _httpPath, httpMethod = _httpMethod, entityClass = _entityClass, httpContentType = _httpContentType;
@synthesize contentType = _contentType;
@synthesize mapper = _mapper;


- (NJDXDALHTTPOperation*)initWithURL:(NSString *)url delegate:(id<NJDXDALHTTPOperationDelegate>)aDelegate thread:(NSThread *)aThread contentType:(NSString *)aContentType
{
    self = [super init];
    if(self) {
        _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        _thread = aThread;
        delegate = aDelegate;
        _contentType = aContentType;
    }
    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (NSData*)receivedData
{
    return _receivedData;
}

- (void)start
{
    // creating connection 
    _request.HTTPMethod = [_httpMethod copy];
    NSString *absoluteString = _request.URL.absoluteString;
    _request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",absoluteString,_httpPath]];                    
    //adding params
    NSMutableString* paramString = [NSMutableString stringWithFormat:@""];
    if ([_request.HTTPMethod isEqualToString:@"POST"] || [_request.HTTPMethod isEqualToString:@"PUT"]) {            
        for(int i = 0; i < [_params count]; i++) {
            if(i == 0) {
                [paramString stringByAppendingString:[NSString stringWithFormat:@"%@", [[_params objectAtIndex:i] toString]]];
            }
            else {
                [paramString stringByAppendingString:[NSString stringWithFormat:@"&%@", [[_params objectAtIndex:i] toString]]];
            }
        }
        [_request setHTTPBody: [paramString dataUsingEncoding:NSUTF8StringEncoding]];
        [_request setValue:_httpContentType forHTTPHeaderField:@"Content-Type"];
        [_request setValue:[NSString stringWithFormat:@"%d",[paramString length]] forHTTPHeaderField:@"Content-Length"];
    }
    else if([_request.HTTPMethod isEqualToString:@"GET"] || [_request.HTTPMethod isEqualToString:@"DELETE"]) {
        for(int i = 0; i < [_params count]; i++) {
            if(i == 0) {
                [paramString appendString:[NSString stringWithFormat:@"?%@", [[_params objectAtIndex:i] toString]]];
            }
            else {
                [paramString appendString:[NSString stringWithFormat:@"&%@", [[_params objectAtIndex:i] toString]]];
            }
        }
        absoluteString = _request.URL.absoluteString;
        _request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",absoluteString,paramString]];
    }
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
    if (_connection) {
        // start loading
        NSLog(@"Connecting...");
        _isExecuting = YES;
        _receivedData = [NSMutableData data];
        [_connection performSelector:@selector(start) onThread:_thread withObject:nil waitUntilDone:NO];
    }
    else {
        NSLog(@"Connection error!");
        _isExecuting = NO;
        _isFinished = YES;
    }
}

- (void)cancel
{
    [_connection cancel];
    _isExecuting = NO;
    _isCancelled = YES;
    _connection = nil;
    [delegate cancelOperation:self];
}

- (void)addParam:(NSString *)key value:(NSString *)aValue
{
    assert(key != nil);
    assert(aValue != nil);
    if (!_params) {
        _params = [NSMutableArray array];
    }    
    [_params addObject: [[NJDXDALParam alloc] initWithKey:key value:aValue]];
}


// ------- NSURLConnectionDelegate -------

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0]; // have recived answer from the server
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data]; // add new data to receivedData
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    NSString *errorString = [[NSString alloc] initWithFormat:@"Connection failed! Error - %@ %@ %@",
                             [error localizedDescription],
                             [error description],
                             [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
    NSLog(@"%@",errorString); // error message
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection // all data have taken
{    
    // send to delegate that we've finished
    _isExecuting = NO;
    [delegate loadingFinished:self];
}

#pragma mark -
#pragma mark MappingDelegate

- (void)didFinishMapping:(NSArray *)realObjects withErrorLog:(NSArray *)mappingErrorArray
{
    if ([mappingErrorArray count] == 0) 
    {
        self.mappedData = realObjects;
    }
    NSLog(@"\n\n%@\n\n",self.mappedData);
}

- (void)didCrashedParsing:(NSError *)parsingError
{
    NSLog(@"%@",parsingError);
}

@end
