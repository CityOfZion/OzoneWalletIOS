//
//  CHNotification.h
//  Channel
//
//  Created by Apisit Toompakdee on 4/9/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CHNotificationPayload.h"
#import "CHNotificationButton.h"

@interface CHNotification : NSObject

@property (nonatomic) NSString* publicID;
@property (nonatomic) NSString* type;
@property (nonatomic) CHNotificationPayload* payload;

- (instancetype)initWithJSON:(NSDictionary*)json;

@end
