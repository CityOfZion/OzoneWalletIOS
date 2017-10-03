//
//  CHCardPayloadTemplate.h
//  Channel
//
//  Created by Apisit Toompakdee on 3/20/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import "CHCardPayloadBase.h"

@interface CHCardPayloadTemplate : CHCardPayloadBase

@property (nonatomic, strong) NSString* templateType;
@property (nonatomic, strong) NSString* url;

@end
