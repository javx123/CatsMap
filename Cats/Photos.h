//
//  photos.h
//  Cats
//
//  Created by Javier Xing on 2017-11-20.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Photos : NSObject <MKAnnotation>
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) UIImage *photoImage;

@property (nonatomic, strong) NSString *photoId;
@property (nonatomic,strong) NSString *photoTitle;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSURL *smallPhotoURL;

- (instancetype)initWithInfo:(NSDictionary*)info;
//-(void)photoImageURL;


@end
