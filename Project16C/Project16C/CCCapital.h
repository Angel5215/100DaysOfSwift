//
//  CCCapital.h
//  Project16C
//
//  Created by Angel Vázquez on 4/1/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCCapital : NSObject <MKAnnotation>

@property (nonatomic, copy, nullable) NSString* title;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property NSString* info;

- (instancetype)initWithTitle:(NSString*)title andCoordinate:(CLLocationCoordinate2D)coordinate andInfo:(NSString*)info;

@end

NS_ASSUME_NONNULL_END
