//
//  WeatherModel.m
//  ThinkWeather
//
//  Created by Andriy Lukashchuk on 9/16/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import <AFNetworking.h>
#import <AFURLRequestSerialization.h>
#import "WeatherModel.h"


@interface WeatherModel () {
   
}

@end

@implementation WeatherModel

NSString *const apiUrl = @"http://api.openweathermap.org/data/2.5/";

+ (void) getWeatherByLocation: (CLLocation*) location
             completion:(void (^)(id id))completion
                failure:(void (^)(NSError * error))failure {
    
    NSString     *string   = [NSString stringWithFormat:@"%@weather?lat=%f&lon=%f&units=metric",
                                apiUrl, location.coordinate.latitude, location.coordinate.longitude];
    NSURL        *url     = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [operation start];

}


+ (void) getWeatherByName: (NSString*) name
              completion: (void (^)(id id))           completion
                 failure: (void (^)(NSError * error)) failure {
    
    NSString     *string  = [NSString stringWithFormat:@"%@find?q=%@&type=like&units=metric", apiUrl, name];
    NSURL        *url     = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer      = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseObject);
        failure(error);
    }];
    
    [operation start];
    
}

+ (void) getWeatherForecastByLocation: (CLLocation*) coordinates
                           completion: (void (^)(id id))completion
                              failure: (void (^)(NSError * error))failure {
    NSString     *string  = [NSString stringWithFormat:@"%@forecast/daily?lat=%f&lon=%f&units=metric",
                              apiUrl, coordinates.coordinate.latitude, coordinates.coordinate.longitude];
    NSURL        *url     = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer      = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseObject);
        failure(error);
    }];
    
    [operation start];
}



@end
