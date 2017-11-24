//
//  ViewController.m
//  Cats
//
//  Created by Javier Xing on 2017-11-20.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

#import "ViewController.h"
#import "Photos.h"
#import "PhotoCollectionViewCell.h"
#import "FlikrAPI.h"
#import <MapKit/MapKit.h>
#import "DetailViewController.h"
#import "SearchViewController.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, SearchTagProtocol, CLLocationManagerDelegate>
@property (nonatomic,strong) NSArray <Photos*> *photos;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)NSString *searchTag;
@property (weak, nonatomic) IBOutlet UISwitch *enableCurrentLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self searchImages:@"cat"];
}

-(void)searchImages:(NSString*)tag{
    [FlikrAPI searchFor:tag complete:^(NSArray *results) {
        self.photos = results;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
        }];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    NSLog(@"%ld", indexPath.row);
    
    [FlikrAPI getCoordinatesForPhoto:self.photos[indexPath.row] complete:^(CLLocationCoordinate2D coordinate) {
        self.photos[indexPath.row].coordinate = coordinate;
//        NSNumber *latitude = [NSNumber numberWithDouble:coordinate.latitude];
//        NSNumber *longitude = [NSNumber numberWithDouble:coordinate.longitude];
//        double latitudeD = [latitude doubleValue];
//        double longitudeD = [longitude doubleValue];
//        NSLog(@"%f, %f", latitudeD, longitudeD);
    }];

    [cell setCellImage:self.photos[indexPath.row].photoURL];
    cell.photoLabel.text = self.photos[indexPath.row].photoTitle;
    return cell;
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"detail"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems][0];
        Photos *photo = self.photos[indexPath.item];
        
        DetailViewController *detailVC = (DetailViewController*)[segue destinationViewController];
        [detailVC setPhoto:photo];
    }
    if ([[segue identifier] isEqualToString:@"search"]) {
        UINavigationController *navController = segue.destinationViewController;
        SearchViewController *controller = [navController viewControllers][0];
        controller.delegate = self;
    }
}

#pragma mark - SearchTag Delegate Methods

-(void)searchTagCancel:(SearchViewController*)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)searchViewController:(SearchViewController *)controller didSaveTag:(NSString *)tag{
    [self searchImages:tag];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)enableCurrentLocation:(id)sender {
    if (self.enableCurrentLocation.on) {
        [self enableLocationServices];
    }
}

-(void)enableLocationServices{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    switch (CLLocationManager.authorizationStatus) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
            
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self disableLocationFeatures];
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self enableLocationFeatures];
            break;
    }
}

-(void)enableLocationFeatures{
    [self.locationManager startUpdatingLocation];
//    self.mapView.showsUserLocation = YES;
//    use func requestLocation() ?? request one time delivery of user's current location
}
-(void)disableLocationFeatures{
    [self.locationManager stopUpdatingLocation];
//    self.mapView.showsUserLocation = NO;
}




- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self enableLocationFeatures];
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            [self disableLocationFeatures];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusNotDetermined:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count >0) {
        [self.locationManager stopUpdatingLocation];
        self.locationManager = nil;
    }
    NSLog(@"Got Location Updates!");
    
    for (CLLocation *location in locations) {
        NSLog(@"Found Location: (%f, %f)", location.coordinate.latitude, location.coordinate.longitude);
    };
}



@end
