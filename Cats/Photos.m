//
//  photos.m
//  Cats
//
//  Created by Javier Xing on 2017-11-20.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

#import "Photos.h"

@implementation Photos

- (instancetype)initWithInfo:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        _photoId = info[@"id"];
        _photoTitle = info[@"title"];
        _photoURL = [NSURL URLWithString:info[@"url_m"]];
    }
    return self;
}

-(UIImage *)photoImage{
    self.photoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];
    return self.photoImage;
}

-(NSString *)title{
    return self.photoTitle;
}

@end
