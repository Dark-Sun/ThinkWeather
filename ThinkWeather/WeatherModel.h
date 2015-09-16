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

+ (void) findByLocation: (CLLocation*) location completion:(void (^)(id id))completion failure:(void (^)(NSError * error))failure;
+ (void) findByName: (NSString*) name     completion:(void (^)(id id))completion failure:(void (^)(NSError * error))failure;
@end
