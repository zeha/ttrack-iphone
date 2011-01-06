//
//  CHApiRequestDelegate.h
//  ttrack
//
//  Created by Christian Hofstaedtler on 06.01.11.
//  Copyright 2011 at.zeha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHApiRequest;

@protocol CHApiRequestDelegate <NSObject>

- (void) request:(CHApiRequest*)request doneWithResponse:(NSDictionary*)response;
- (void) requestFailed:(CHApiRequest*)request;

@end
