//
//  MapController.m
//  ThinkWeather
//
//  Created by Andriy Lukashchuk on 9/16/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

@import GoogleMaps;
#import "MapController.h"

@interface MapController () {
    GMSMapView *mapView_;
    CLLocation    *coordinates;
    NSString   *markerName;
}
@end

@implementation MapController

- (id) initWithCoordinates: (CLLocation*) coords andName: (NSString*) name {
    self = [super init];
    coordinates = coords;
    markerName = name;
    if (!self) return nil;
    return self;
}

- (void)viewDidLoad {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinates.coordinate.latitude
                                                            longitude:coordinates.coordinate.longitude
                                                                 zoom:6.0];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(coordinates.coordinate.latitude,
                                                 coordinates.coordinate.longitude
                                                );
    marker.title = markerName;
    marker.map = mapView_;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
