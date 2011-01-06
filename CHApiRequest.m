//
//  CHApiRequest.m
//  ttrack
//
//  Created by Christian Hofstaedtler on 06.01.11.
//  Copyright 2011 at.zeha. All rights reserved.
//

#import "CHApiRequest.h"
#import "JSON.h"
#import "SBJsonParser.h"


@implementation CHApiRequest
@synthesize apiName = _apiName;

- (id) initWithApiName:(NSString *)apiName method:(NSString *)method delegate:(id <CHApiRequestDelegate>)delegate {
	self = [super init];
	if (self) {
		_delegate = [delegate retain];
		_apiName = [apiName copy];
		_method = [method copy];
		_connection = nil;
		_buffer = nil;
	}
	return self;
}

- (void) dealloc {
	[_delegate release], _delegate = nil;
	[_apiName release], _apiName = nil;
	[_method release], _method = nil;
	
	[super dealloc];
}

- (void) startRequest {
	NSString* urlString = [NSString stringWithFormat:@"http://ttrack.zeha.at/api/v1/%@", _apiName];
	NSURL* url = [NSURL URLWithString:urlString];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
	[req setHTTPMethod:_method];

	_connection = [[NSURLConnection connectionWithRequest:req delegate:self] retain];
	[_connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSHTTPURLResponse* resp = (NSHTTPURLResponse*)response;
	
	if ([resp statusCode] != 200) {
		NSLog(@"ERROR Response Code: %d", [resp statusCode]);
		[_connection cancel], [_connection release], _connection = nil;
		[_delegate requestFailed:self];
		return;
	}
	
	_buffer = [[NSMutableData data] retain];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_buffer appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if (_buffer != nil) {
		[_buffer release], _buffer = nil;
	}
	[_connection cancel], [_connection release], _connection = nil;
	[_delegate requestFailed:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString* data = [[NSString alloc] initWithData:_buffer encoding:NSUTF8StringEncoding];
	NSLog(@"response: %@\n", data);
	SBJsonParser* parser = [SBJsonParser new];
	NSDictionary* result = [parser objectWithString:data];
	
	[parser release];
	[data release];
	[_buffer release], _buffer = nil;
	[_connection cancel], [_connection release], _connection = nil;
	
	[_delegate request:self doneWithResponse:result];
}


@end
