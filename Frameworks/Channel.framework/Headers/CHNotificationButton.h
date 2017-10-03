//
//  CHNotificationButton.h
//  Channel
//
//  Created by Apisit Toompakdee on 4/9/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CHNotificationButton : NSObject
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* type;
@property (nonatomic) NSString* backgroundColor;
@property (nonatomic) NSString* textColor;
@property (nonatomic) NSString* payload;
@property (nonatomic) NSURL* URL;

- (instancetype)initWithJSON:(NSDictionary*)json;
- (instancetype)initWithTitle:(NSString*)title payload:(NSString*)payload;

- (NSDictionary*)toJSON;

@end
