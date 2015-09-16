//
//  WeatherController.m
//  ThinkWeather
//
//  Created by Andriy Lukashchuk on 9/16/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import "WeatherController.h"

@interface WeatherController () {
    CLLocationManager *locationManager;
    CLLocation        *coordinates;
}

- (IBAction)mapButtonClicked:(id)sender;

@end

@implementation WeatherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: check internet connection
    
    // Set date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"EEEE, MMMM dd"];
    
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    [self.date setTitle:currentDate forState:UIControlStateNormal];
    
    if (!coordinates) {
        coordinates = [[CLLocation alloc] initWithLatitude: [@48.6193818 doubleValue]
                                                 longitude: [@22.2796376 doubleValue]]; // Uzhhorod

    }
    
    // Get current location
    locationManager                 = [[CLLocationManager alloc] init];
    locationManager.delegate        = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter  = 5;
    
    [locationManager startUpdatingLocation];
    
    if ([locationManager respondsToSelector: @selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    // Update location from other controllers
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateDataWithNotification:)
                                                 name: @"UpdateWeatherWithLocation"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
}

- (void) orientationChanged {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // No size classes for iOS 7 in compact mode :(
    // So...
    if (orientation != UIInterfaceOrientationPortrait) {
        self.forecastContainer.hidden = TRUE;
    } else {
        self.forecastContainer.hidden = FALSE;
    }
}

- (void) updateData {
    [self updateDataWithLocation: coordinates];
}

- (void) updateDataWithNotification:(NSNotification *) notification {
    
    [locationManager stopUpdatingLocation];
    coordinates = [[CLLocation alloc] initWithLatitude:[notification.object[@"coord"][@"lat"] floatValue]
                                             longitude:[notification.object[@"coord"][@"lon"] floatValue]];
    
    [self setWeatherData: notification.object];
    [self updateForecast];

}

- (void) updateDataWithLocation: (CLLocation*) location {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    
    [WeatherModel getWeatherByLocation:location completion:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
        [self setWeatherData: responseObject];
        [self updateForecast];
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void) setWeatherData: (NSDictionary*) data {
    
    if(data[@"error"] && [data[@"error"][@"cod"]  isEqual: @"404"]) return;
    
    // Title
    self.title = data[@"name"];
    
    // Image
    NSString *imageName = [NSString stringWithFormat: @"%@", data[@"weather"][0][@"icon"]];
    UIImage *image = [UIImage imageNamed: imageName];
    if (image) {
        [self.date setImage: image
                   forState: UIControlStateNormal];
    }
    
    // Temperatur
    int temperature = [data[@"main"][@"temp"] intValue];
    self.temperature.text   = [NSString stringWithFormat:@"%i", temperature];
    
    // Wind speed
    [self.windSpeed setTitle: [NSString stringWithFormat:@"%@ m/s", data[@"wind"][@"speed"] ]
                    forState: UIControlStateNormal];
    
    // Wind direction
    int windDegree = [data[@"wind"][@"deg"] intValue];
    
    if (windDegree > 315 || windDegree < 45) {
        [self.windDirection setTitle:@"North" forState: UIControlStateNormal];
    } else if (windDegree > 45  && windDegree < 135) {
        [self.windDirection setTitle:@"East" forState: UIControlStateNormal];
    } else if (windDegree > 135 && windDegree < 225) {
        [self.windDirection setTitle:@"South" forState: UIControlStateNormal];
    } else if (windDegree > 225 && windDegree < 315) {
        [self.windDirection setTitle:@"West" forState: UIControlStateNormal];
    }
    
    // Humidity
    [self.rainChance setTitle: [NSString stringWithFormat: @"%@%%", data[@"main"][@"humidity"]]
                     forState: UIControlStateNormal];
}

- (void) updateForecast {
    [WeatherModel getWeatherForecastByLocation:coordinates completion:^(id responseObject) {
        
        NSArray *forecast = responseObject[@"list"];
        
        for(int i=1; i < 6; i++) {
            
            // Set date
            NSDate *date   = [NSDate dateWithTimeIntervalSince1970: [forecast[i][@"dt"] integerValue]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EE"];
            NSString *dateString = [dateFormatter stringFromDate: date];
            
            UILabel *dayLabel = (UILabel*) [self.view viewWithTag:(i+100)];
            dayLabel.text = [NSString stringWithFormat: @"%@", dateString];
            
            // Set image
            NSString *imageName = [NSString stringWithFormat: @"%@",forecast[i][@"weather"][0][@"icon"]];
            UIImage  *image     = [UIImage imageNamed: imageName];
            
            UIImageView *imageView = (UIImageView*) [self.view viewWithTag:(i+200)];
            if(image) [imageView setImage: image];
            
            // Temperature
            UILabel  *tempLabel   = (UILabel*) [self.view viewWithTag:(i+300)];
            NSString *temperature = [NSString stringWithFormat: @"%li°", (long)[forecast[i][@"temp"][@"day"] integerValue]];
            tempLabel.text = temperature;
        }

    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (IBAction) mapButtonClicked:(id)sender {
    MapController *controller = [[MapController alloc] initWithCoordinates: coordinates
                                                                   andName: @""];
    [self.navigationController pushViewController: controller animated: true];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Failed to get location: %@", error);
    [self updateData];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation != nil) coordinates = newLocation;
    [self updateData];
}


@end
