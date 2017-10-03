//
//  CHPostback.h
//  Channel
//
//  Created by Apisit Toompakdee on 4/11/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHPostback : NSObject

@property (nonatomic, nullable) NSString* payload;

- (instancetype _Nonnull)initWithPayload:(NSString* _Nonnull)payload;
- (NSDictionary* _Nullable)toJSON;

@end
