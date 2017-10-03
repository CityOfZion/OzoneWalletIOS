//
//  CHTopic.h
//  Channel
//
//  Created by Apisit Toompakdee on 9/1/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHBase.h"

@interface CHTopic : CHBase

@property (nonatomic, strong) NSString* name;

- (instancetype)initWithJSON:(NSDictionary*)json;

@end
