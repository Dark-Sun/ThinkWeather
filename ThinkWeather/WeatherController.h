//
//  WeatherController.h
//  ThinkWeather
//
//  Created by Andriy Lukashchuk on 9/16/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface WeatherController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *date;
@property (weak, nonatomic) IBOutlet UILabel  *temperature;
@property (weak, nonatomic) IBOutlet UIButton *windSpeed;
@property (weak, nonatomic) IBOutlet UIButton *windDirection;
@property (weak, nonatomic) IBOutlet UIButton *rainChance;

- (void) updateData;
- (void) updateData: (CLLocation*) location ;

@end
