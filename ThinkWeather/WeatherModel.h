//
//  WeatherModel.h
//  ThinkWeather
//
//  Created by Andriy Lukashchuk on 9/16/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

+ (void) getWeatherByLocation: (CLLocation*) location
                   completion:(void (^)(id id))completion
                      failure:(void (^)(NSError * error))failure;

+ (void) getWeatherByName: (NSString*) name
               completion: (void (^)(id id))completion
                  failure: (void (^)(NSError * error))failure;

+ (void) getWeatherForecastByLocation: (CLLocation*) coordinates
                           completion: (void (^)(id id))completion
                              failure: (void (^)(NSError * error))failure;

@end
