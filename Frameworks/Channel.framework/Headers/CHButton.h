//
//  CHButton.h
//  Channel
//
//  Created by Apisit Toompakdee on 2/6/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCardButton.h"

IB_DESIGNABLE
@interface CHButton : UIButton

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic, nullable) CHCardButton* data;

@end
