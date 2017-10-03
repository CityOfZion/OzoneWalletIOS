//
//  CHPhoto.h
//  Channel
//
//  Created by Apisit Toompakdee on 3/16/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYTPhoto.h"
@interface CHPhoto : NSObject<NYTPhoto>

@property (nonatomic, strong) UIImage* image;

-(instancetype)initWithImage:(UIImage*)image;

@end
