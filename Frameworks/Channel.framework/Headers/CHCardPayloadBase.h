//
//  CHCardPayloadBase.h
//  Channel
//
//  Created by Apisit Toompakdee on 3/11/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHCardPayloadBase : NSObject

@property (nonatomic, strong) NSArray* buttons;

-(instancetype)initWithJSON:(NSDictionary *)json;
- (NSDictionary*)toJSON;

@end
