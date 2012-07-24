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
    NSData *_uploadingFile;
    NSString *_uploadingFileName;
}
@end


@implementation NJDXDALHTTPOperation

@synthesize delegate, request = _request;
@synthesize isFinished = _isFinished, isExecuting = _isExecuting, isCancelled = _isCancelled;
@synthesize httpPath = _httpPath, httpMethod = _httpMethod, entityClass = _entityClass;
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
    if (_httpPath) {
        _request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",absoluteString,_httpPath]];
    }
    
    //adding params
    NSMutableString* paramString = [NSMutableString stringWithFormat:@""];
    if ([_request.HTTPMethod isEqualToString:@"POST"] || [_request.HTTPMethod isEqualToString:@"PUT"]) {            
        for(int i = 0; i < [_params count]; i++) {
            if(i == 0) {
                [paramString appendString:[NSString stringWithFormat:@"%@", [[_params objectAtIndex:i] toString]]];
            }
            else {
                [paramString appendString:[NSString stringWithFormat:@"&%@", [[_params objectAtIndex:i] toString]]];
            }
        }
        [_request setHTTPBody: [paramString dataUsingEncoding:NSUTF8StringEncoding]];
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
    else if([_request.HTTPMethod isEqualToString:@"FILES"]) {
        assert(_uploadingFile);
        assert(_uploadingFileName);
        [self uploadFile:_uploadingFile withName:_uploadingFileName withParams:_params];
    }
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
    if (_connection) {
        // start loading
        NSLog(@"Connecting...");
        _isExecuting = YES;
        _receivedData = [NSMutableData new];
        [_connection performSelector:@selector(start) onThread:_thread withObject:nil waitUntilDone:NO];
    }
    else {
        NSLog(@"Connection error!");
        _isExecuting = NO;
        _isFinished = YES;
    }
}

-(void)uploadFile:(NSData *)file withName:(NSString *)name withParams:(NSArray *)params
{
//	NSString *urlString = url;
    
	NSMutableURLRequest *request = _request;
//	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
    
	NSString *boundary = [NSString stringWithString:@"------------0xKhTmLbOuNdArY"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\n",name] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:file]];
    
    if(params)
    {
        id myKey;
        id myValue;
        
        for(int i=0; i<[params count]; i++)
        {
            myKey = [[params objectAtIndex:i] myKey];
            myValue = [[params objectAtIndex:i] myValue];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",myKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[myValue dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
	[request setHTTPBody:body]; 
    
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
	NSLog(@"%@",returnString);
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
        _params = [[NSMutableArray alloc] init];
    }    
    [_params addObject: [[NJDXDALParam alloc] initWithKey:key value:aValue]];
}

- (void)addFile:(NSData *)anUploadingFile withName:(NSString *)aName
{
    _uploadingFile = anUploadingFile;
    _uploadingFileName = aName;
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
    NSLog(@"\n\n%@\n\n",[[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding]);
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
