//
//  CHContent.h
//  Channel
//
//  Created by Apisit Toompakdee on 1/8/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCard.h"
#import "CHPostback.h"
#import "CHTopic.h"

@interface CHContent : NSObject

@property (nonatomic, nullable) NSString* text;
@property (nonatomic, nullable) CHCard* card;
@property (nonatomic, nullable) CHPostback* postback;
@property (nonatomic, nullable) NSArray* buttons;
@property (nonatomic, nullable) CHTopic* topic;

- (instancetype _Nonnull)initWithText:(NSString* _Nonnull)text;
- (instancetype _Nonnull)initWithJSON:(NSDictionary* _Nonnull)json;
- (instancetype _Nonnull)initWithCard:(CHCard* _Nonnull)card;
- (instancetype _Nonnull)initWithText:(NSString* _Nonnull)text postbackPayload:(NSString* _Nonnull)payload;

@end
