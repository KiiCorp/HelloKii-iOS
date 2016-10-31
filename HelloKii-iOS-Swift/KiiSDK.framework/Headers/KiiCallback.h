//
//  KiiCallback.h
//  KiiSDK-Private
//
//  Created by Chris Beauchamp on 2/7/12.
//  Copyright (c) 2012 Kii Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KiiCallback : NSObject {
    id delegate;
    SEL selector;
    SEL progress;
}

- (id) delegate;
- (SEL) selector;
- (SEL) progress;

- (id) initWithDelegate:(id)del andCallback:(SEL)sel;
+ (id) callbackWithDelegate:(id)del andCallback:(SEL)sel;

- (id) initWithDelegate:(id)del andCallback:(SEL)sel andProgress:(SEL)progress;
+ (id) callbackWithDelegate:(id)del andCallback:(SEL)sel andProgress:(SEL)progress;

@end
