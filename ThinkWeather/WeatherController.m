//
//  WeatherController.m
//  ThinkWeather
//
//  Created by Andriy Lukashchuk on 9/16/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import "WeatherController.h"
#import "MapController.h"
#import "WeatherModel.h"

@interface WeatherController () {
    CLLocationManager *locationManager;
    CLLocation        *coordinates;
}

- (IBAction)mapButtonClicked:(id)sender;

@end

@implementation WeatherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set date
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM dd"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    [self.date setTitle:currentDate forState:UIControlStateNormal];
    
    // Get current location
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter = 5;
    
    [locationManager startUpdatingLocation];
    [locationManager requestWhenInUseAuthorization];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDataWithNotification:)
                                                 name:@"UpdateWeatherWithLocation"
                                               object:nil];

}

- (void) updateDataWithNotification:(NSNotification *) notification {
    NSDictionary* forecast  = notification.object;
    NSLog(@"Recieved coordinates! %@", forecast);
    
    self.title = forecast[@"name"];
    
    int temperature =  [forecast[@"main"][@"temp"] intValue];
    self.temperature.text   = [NSString stringWithFormat:@"%i", temperature];
    
    [self.windSpeed setTitle:[NSString stringWithFormat:@"%@ m/s", forecast[@"wind"][@"speed"] ]
                    forState:UIControlStateNormal];
    
    int windDegree = [forecast[@"wind"][@"deg"] intValue];
    if (windDegree > 315 || windDegree < 45) {
        [self.windDirection setTitle:@"North" forState: UIControlStateNormal];
    } else if (windDegree > 45  && windDegree < 135) {
        [self.windDirection setTitle:@"East" forState: UIControlStateNormal];
    } else if (windDegree > 135 && windDegree < 225) {
        [self.windDirection setTitle:@"South" forState: UIControlStateNormal];
    } else if (windDegree > 225 && windDegree < 315) {
        [self.windDirection setTitle:@"West" forState: UIControlStateNormal];
    }
    
    [locationManager stopUpdatingLocation];
    coordinates = [[CLLocation alloc] initWithLatitude:[forecast[@"coord"][@"lat"] floatValue] longitude:[forecast[@"coord"][@"lon"] floatValue]];
}

- (void) updateData {
    [self updateData:coordinates];
}
- (void) updateData: (CLLocation*) location {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [WeatherModel findByLocation:location completion:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if(responseObject[@"error"] && [responseObject[@"error"][@"cod"]  isEqual: @"404"]) return;
        self.title = responseObject[@"name"];
        
        int temperature =  [responseObject[@"main"][@"temp"] intValue];
        self.temperature.text   = [NSString stringWithFormat:@"%i", temperature];
        
        [self.windSpeed setTitle:[NSString stringWithFormat:@"%@ m/s", responseObject[@"wind"][@"speed"] ]
                        forState:UIControlStateNormal];
        
        int windDegree = [responseObject[@"wind"][@"deg"] intValue];
        if (windDegree > 315 || windDegree < 45) {
            [self.windDirection setTitle:@"North" forState: UIControlStateNormal];
        } else if (windDegree > 45  && windDegree < 135) {
            [self.windDirection setTitle:@"East" forState: UIControlStateNormal];
        } else if (windDegree > 135 && windDegree < 225) {
            [self.windDirection setTitle:@"South" forState: UIControlStateNormal];
        } else if (windDegree > 225 && windDegree < 315) {
            [self.windDirection setTitle:@"West" forState: UIControlStateNormal];
        }
        
        [self.rainChance setTitle:[NSString stringWithFormat: @"%@%%", responseObject[@"main"][@"humidity"]]
                         forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"%@", error.localizedDescription);
    }
     ];
}

- (IBAction)mapButtonClicked:(id)sender {
    NSLog(@"%@", locationManager.location);
    MapController *controller = [[MapController alloc] initWithCoordinates: coordinates andName: @"Mukachevo"];
    [self.navigationController pushViewController:controller animated:true];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed to get location: %@", error);
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation != nil) coordinates = newLocation;
    [self updateData];
}


@end
