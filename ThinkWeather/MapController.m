//
//  MapController.m
//  ThinkWeather
//
//  Created by Andriy Lukashchuk on 9/16/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import "MapController.h"

@interface MapController () {
    GMSMapView *mapView_;
    CLLocation *coordinates;
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

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: coordinates.coordinate.latitude
                                                            longitude: coordinates.coordinate.longitude
                                                                 zoom: 6.0];
    mapView_ = [GMSMapView mapWithFrame: CGRectZero
                                 camera: camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(coordinates.coordinate.latitude,
                                                 coordinates.coordinate.longitude
                                                );
    marker.title = markerName;
    marker.map = mapView_;
}

@end
