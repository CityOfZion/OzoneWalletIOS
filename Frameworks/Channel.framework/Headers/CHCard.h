//
//  CHCard.h
//  Channel
//
//  Created by Apisit Toompakdee on 3/11/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardTypeEnum.h"
#import "CHCardPayload.h"

@interface CHCard : NSObject

@property (nonatomic, nonnull) CardType type;
@property (nonatomic, nonnull, strong) CHCardPayloadBase* payload;
@property (nonatomic, nullable) NSNumber* widthRatio;
@property (nonatomic, nullable) NSNumber* heightRatio;

- (instancetype _Nonnull)initWithJSON:(NSDictionary* _Nonnull)json;

- (NSDictionary* _Nonnull)toJSON;


@end
