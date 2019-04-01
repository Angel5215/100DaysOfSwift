//
//  CCCapital.m
//  Project16C
//
//  Created by Angel Vázquez on 4/1/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

#import "CCCapital.h"

@implementation CCCapital

- (instancetype)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coordinate andInfo:(NSString*)info {
    if (self = [super init]) {
        _title = title;
        _coordinate = coordinate;
        _info = info;
    }
    
    return self;
}

@end
