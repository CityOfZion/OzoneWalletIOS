//
//  CHNotificationPayload.h
//  Channel
//
//  Created by Apisit Toompakdee on 4/16/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHNotificationPayload : NSObject

@property (nonatomic) NSURL* imageURL;
@property (nonatomic) NSString* text;
@property (nonatomic) NSString* templateType;
@property (nonatomic) NSArray* buttons;

- (instancetype)initWithJSON:(NSDictionary*)json;

@end
