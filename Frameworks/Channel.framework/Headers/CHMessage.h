//
//  CHMessage.h
//  Channel
//
//  Created by Apisit Toompakdee on 1/8/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHContent.h"
#import "CHSender.h"

@class CHSender;

@interface CHMessage : NSObject

@property (nonatomic) NSString* clientObjectID;
@property (nonatomic) NSDate* createdAt;
@property (nonatomic) Boolean isFromBusiness;
@property (nonatomic) CHContent* content;
@property (nonatomic) CHSender* sender;

@property (nonatomic) BOOL isFromClient;

- (instancetype)initWithJSON:(NSDictionary*)json;
- (instancetype)initWithText:(NSString*)text;
- (instancetype)initWithText:(NSString*)text postbackPayload:(NSString*)payload;
- (instancetype)initWithImageURL:(NSURL*)imageURL;
- (NSDictionary*)toJSON;

@end
