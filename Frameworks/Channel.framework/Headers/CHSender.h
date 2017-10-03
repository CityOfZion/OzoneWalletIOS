//
//  CHSender.h
//  Channel
//
//  Created by Apisit Toompakdee on 2/2/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <Channel/Channel.h>

@interface CHSender : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* imageUrl;


- (instancetype)initWithJSON:(NSDictionary*)json;

@end
