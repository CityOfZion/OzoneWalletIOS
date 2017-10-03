//
//  CHCardPayloadImage.h
//  Channel
//
//  Created by Apisit Toompakdee on 3/11/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCardPayloadBase.h"

@import UIKit;

@interface CHCardPayloadImage : CHCardPayloadBase

@property (nonatomic) NSURL* imageURL;


- (instancetype)initWithImageURL:(NSURL*)imageURL;


@end
