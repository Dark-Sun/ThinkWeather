//
//  MapController.h
//  ThinkWeather
//
//  Created by Andriy Lukashchuk on 9/16/15.
//  Copyright (c) 2015 Codegemz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapController : UIViewController

- (id) initWithCoordinates: (CLLocation*) coords andName: (NSString*) name;
@end
