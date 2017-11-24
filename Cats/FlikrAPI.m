//
//  FlikrAPI.m
//  Cats
//
//  Created by Javier Xing on 2017-11-20.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

#import "FlikrAPI.h"

@implementation FlikrAPI

+ (void)searchFor:(NSString*)tag complete:(void (^)(NSArray *results))done{
    NSURL *flikrUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=549cb973d6beee15fc4157a6941d17ae&tags=%@&has_geo=1&extras=url_m&format=json&nojsoncallback=1", tag]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL: flikrUrl];
    
    NSURLSessionTask *task= [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
        if (resp.statusCode > 299) {
            NSLog(@"Bad status code: %ld", resp.statusCode);
            abort();
        }
        
        //        Start json parsing
        NSError *jsonError = nil;
        NSDictionary* photos = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"Error:%@",jsonError.localizedDescription);
            return;
        }
        NSMutableArray *allPhotos = [[NSMutableArray alloc]init];
        
        for (NSDictionary* photoInfo in photos[@"photos"][@"photo"]) {
            NSString* photoTitle = photoInfo[@"title"];
            NSLog(@"Title: %@", photoTitle);
            Photos *photo = [[Photos alloc]initWithInfo:photoInfo];
            [allPhotos addObject:photo];
        }
        done([NSArray arrayWithArray:allPhotos]);
        }];
    [task resume];
}





//+ (void)loadImage:(Photos*)photo completionHandler:(void (^)(UIImage *image))finishedCallback{
//    if (photo.photoImage != nil) {
//        finishedCallback(photo.photoImage);
//    }
//    else{
//        NSURLSessionTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:photo.photoURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            UIImage * image = [UIImage imageWithContentsOfFile:location.path];
//            photo.photoImage = image;
//        }];
//        [task resume];
//    }
//}

+(void)getCoordinatesForPhoto:(Photos*)photo complete:(void(^)(CLLocationCoordinate2D coordinate))done{
//    if (photo.coordinate) {
//        <#statements#>
//    }

    
    NSURL *photoWithCoordinate = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=549cb973d6beee15fc4157a6941d17ae&photo_id=%@&format=json&nojsoncallback=1",photo.photoId]];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:photoWithCoordinate completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        JSON parsing
        
        NSError *jsonError = nil;
        NSDictionary * photoData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"Error:%@",jsonError.localizedDescription);
            return;
        }
//        CLLocationDegrees latitude =
        CLLocationDegrees latitude = [photoData[@"photo"][@"location"][@"latitude"] doubleValue];
        CLLocationDegrees longitude =[photoData[@"photo"][@"location"][@"longitude"] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
        done(coordinate);
    }];
    [task resume];
}


@end
