//
//  ViewController.m
//  Project16C
//
//  Created by Angel Vázquez on 4/1/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "CCCapital.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CCCapital* london = [[CCCapital alloc] initWithTitle:@"London" andCoordinate:CLLocationCoordinate2DMake(51.507222, -0.1275) andInfo:@"Home to the 2012 Summer Olympics."];
    CCCapital* oslo = [[CCCapital alloc] initWithTitle:@"Oslo" andCoordinate:CLLocationCoordinate2DMake(59.95, 10.75) andInfo:@"Founded over a thousand years ago."];
    CCCapital* paris = [[CCCapital alloc] initWithTitle:@"Paris" andCoordinate:CLLocationCoordinate2DMake(48.8567, 2.3508) andInfo:@"Often called the City of Light."];
    CCCapital* rome = [[CCCapital alloc] initWithTitle:@"Rome" andCoordinate:CLLocationCoordinate2DMake(41.9, 12.5) andInfo:@"Has a whole country inside it"];
    CCCapital* washington = [[CCCapital alloc] initWithTitle:@"Washington" andCoordinate:CLLocationCoordinate2DMake(38.895111, -77.036667) andInfo:@"Named after George himself"];
        
    [self.mapView addAnnotations:@[london, oslo, paris, rome, washington]];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (![annotation isKindOfClass:[CCCapital class]]) return nil;
    
    NSString* identifier = @"Capital";
    MKAnnotationView* _Nullable annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = btn;
    } else {
        annotationView.annotation = (id<MKAnnotation>)annotationView;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if (![view.annotation isKindOfClass:CCCapital.class]) return;
    
    CCCapital* capital = (CCCapital*)view.annotation;
    
    NSString* placeName = capital.title;
    NSString* placeInfo = capital.info;
    
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:placeName message:placeInfo preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction: [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:ac animated:true completion:nil];
}

@end
