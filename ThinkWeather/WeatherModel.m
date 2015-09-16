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

+ (void) findByLocation: (CLLocation*) location completion:(void (^)(id id))completion failure:(void (^)(NSError * error))failure {
    
    NSString *string = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=metric", location.coordinate.latitude, location.coordinate.longitude];
    NSLog(@"url %@", string);
    NSURL *url = [NSURL URLWithString:string];
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


+ (void) findByName: (NSString*) name completion:(void (^)(id id))completion failure:(void (^)(NSError * error))failure {
    
    NSString *string = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/find?q=%@&type=like&units=metric", name];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseObject);
        failure(error);
    }];
    [operation start];
    
}



@end
