//
//  CHApiRequest.h
//  ttrack
//
//  Created by Christian Hofstaedtler on 06.01.11.
//  Copyright 2011 at.zeha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHApiRequestDelegate.h"

@interface CHApiRequest : NSObject {

	NSURLConnection* _connection;
	id<CHApiRequestDelegate> _delegate;
	NSString* _apiName;
	NSString* _method;
	NSMutableData* _buffer;
}

@property (readonly, copy) NSString* apiName;

- (id) initWithApiName:(NSString *)apiName method:(NSString *)method delegate:(id <CHApiRequestDelegate>)delegate;
- (void) startRequest;

@end
