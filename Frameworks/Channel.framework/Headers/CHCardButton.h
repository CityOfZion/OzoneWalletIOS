//
//  CHCardButton.h
//  Channel
//
//  Created by Apisit Toompakdee on 3/22/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CHCardButton : NSObject

@property (nonatomic) NSString* type;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* url;
@property (nonatomic) NSString* payload;

@property (nonatomic) UIColor* backgroundColor;
@property (nonatomic) UIColor* textColor;

-(instancetype)initWithJSON:(NSDictionary *)json;

@end
