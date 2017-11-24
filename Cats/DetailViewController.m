//
//  DetailViewController.m
//  Cats
//
//  Created by Javier Xing on 2017-11-21.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

#import "DetailViewController.h"
#import <MapKit/MapKit.h>

@interface DetailViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
    [self mapSetup];
    
}

#pragma mark - SetUp Methods
-(void)configureView{
    if (self.photo) {
        self.title = self.photo.photoTitle;
//        put other configurations
    }
}

-(void)setPhoto:(Photos *)photo{
    if (_photo != photo) {
        _photo = photo;
        [self configureView];
    }
}

#pragma mark - MapView Delegate Methods

-(void)mapSetup{
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.1f,0.1f);
//    self.mapView.region = MKCoordinateRegionMake(self.photo.coordinate, span);
    MKMapCamera *camera = [MKMapCamera camera];
    camera.centerCoordinate = self.photo.coordinate;
    camera.altitude = 1000;
    self.mapView.camera = camera;
    [self.mapView addAnnotation:self.photo];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:MKUserLocation.class]) {
        return nil;
    }
    MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        view.animatesDrop = YES;
        view.canShowCallout = YES;
    } else {
        view.annotation = annotation;
    }
    return view;
}



@end
