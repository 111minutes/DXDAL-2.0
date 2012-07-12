//
//  NJDXDALHTTPOperation.m
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALHTTPOperation.h"

@interface NJDXDALHTTPOperation ()
{
    NSURLConnection* _connection;
    NSMutableData *_receivedData;
    NSThread* _thread;
}

@property (nonatomic,readonly) id<NJDXDALHTTPOperationDelegate> delegate; //for informing when data is loaded

@end


@implementation NJDXDALHTTPOperation

@synthesize delegate, request = _request;
@synthesize isFinished = _isFinished, isExecuting = _isExecuting, isCancelled = _isCancelled;


-(NJDXDALHTTPOperation*)initWithRequest:(NSURLRequest*)req delegate:(id<NJDXDALHTTPOperationDelegate>)aDelegate thread:(NSThread*)aThread
{
    self = [super init];
    if(self)
    {
        _request = req;
        _thread = aThread;
        delegate = aDelegate;
    }
    return self;
}

-(BOOL)isConcurrent
{
    return YES;
}

-(NSData*)receivedData
{
    return _receivedData;
}

- (void)start
{
    // creating connection 
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
    if (_connection) 
    {
        NSLog(@"Connecting...");
        _isExecuting = YES;
        _receivedData = [NSMutableData data];
        // start loading
        [_connection performSelector:@selector(start) onThread:_thread withObject:nil waitUntilDone:NO];
    } 
    else 
    {
        NSLog(@"Connection error!");
        _isExecuting = NO;
        _isFinished = YES;
    }
}

-(void)cancel
{
    [_connection cancel];
    _isExecuting = NO;
    _isCancelled = YES;
    _connection = nil;
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
    // our recived data is string
    NSString *dataString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",dataString);
    
    // send to delegate that we've finished
    _isExecuting = NO;
    [delegate loadingFinished:self];
}

@end
