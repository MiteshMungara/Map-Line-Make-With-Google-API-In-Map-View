//
//  ViewController.m
//  MapViewLineDraw
//
//  Created by iSquare2 on 7/9/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import "ViewController.h"
#import "TrailsMap.h"
 
@interface ViewController ()
{
    NSData *alldata;
    NSMutableDictionary *data1;
    
    NSMutableArray *RouteLocation;
    NSMutableArray *RouteName;
}
@end

@implementation ViewController
@synthesize MapView,routeLine,routeLineView;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MapView.showsUserLocation=YES;
    MapView.showsBuildings = YES;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    // [locationManager startUpdatingLocation];
   //[locationManager requestWhenInUseAuthorization];
   // [locationManager requestAlwaysAuthorization];
    
    RouteName = [[NSMutableArray alloc] initWithObjects:@"Shri Mahatma Gandhi School",@"Movadi Main Rd", nil];
    RouteLocation = [[NSMutableArray alloc] initWithObjects:@"22.265633,70.796292",@"13.706343,74.667591", nil];
    [self LoadMapRoute];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    [MapView setRegion:MKCoordinateRegionMake(mapView.userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01)) animated:NO];
}


//#pragma marl - Location
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(MKUserLocation *)userLocation
//{
//    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:userLocation.coordinate fromEyeCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) eyeAltitude:10000];
//    [MapView setCamera:camera animated:YES];
//}
//

//#pragma marl - Location
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    currentLocation = [locations objectAtIndex:0];
//    [locationManager stopUpdatingLocation];
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
//    [geocoder reverseGeocodeLocation: currentLocation completionHandler: ^(NSArray *placemarks, NSError *error)
//     {
//         CLPlacemark *placemark = [placemarks objectAtIndex:0];
//         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//         if (locatedAt.length==0)
//         {
//             [locationManager startUpdatingLocation];
//             // [locationManager startMonitoringSignificantLocationChanges];
//         }else{
//             
//         }
//     }];
//}
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    if (status == 2)
//    {
//       // ALERT_VIEW(@"Start Location",@"Settings -> Privacy -> Location Services -> DoctorApp")
//        [locationManager startUpdatingLocation];
//        // [locationManager startMonitoringSignificantLocationChanges];
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-------------------------------------
// ************* Map ******************
//-------------------------------------

-(void)LoadMapRoute
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.8, 0.8);
    MKCoordinateRegion region;
    region.span = span;
    region.center= CLLocationCoordinate2DMake(23.0300,72.5800);
    
    
    // Distance between two address
    NSArray *coor1=[[RouteLocation objectAtIndex:0] componentsSeparatedByString:@","];
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[coor1 objectAtIndex:0] doubleValue] longitude:[[coor1 objectAtIndex:1] doubleValue]];
    
    NSArray *coor2=[[RouteLocation objectAtIndex:1] componentsSeparatedByString:@","];
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:[[coor2 objectAtIndex:0] doubleValue] longitude:[[coor2 objectAtIndex:1] doubleValue]];
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    NSLog(@"Distance :%.0f Meters",distance);
    
    
    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=true", [RouteLocation objectAtIndex:0],[RouteLocation objectAtIndex:1] ];
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    alldata = [[NSData alloc] initWithContentsOfURL:url];
    
    NSError *err;
    data1 =[NSJSONSerialization JSONObjectWithData:alldata options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&err];
    
    if (err)
    {
        NSLog(@" %@",[err localizedDescription]);
    }
    
    NSArray *routes = [data1 objectForKey:@"routes"];
    NSDictionary *firstRoute = [routes objectAtIndex:0];
    NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
    NSArray *steps = [leg objectForKey:@"steps"];
    
    int stepIndex = 0;
    CLLocationCoordinate2D stepCoordinates[[steps count]+1 ];
    
    for (NSDictionary *step in steps)
    {
        
        NSDictionary *start_location = [step objectForKey:@"start_location"];
        double latitude = [[start_location objectForKey:@"lat"] doubleValue];
        double longitude = [[start_location objectForKey:@"lng"] doubleValue];
        stepCoordinates[stepIndex] = CLLocationCoordinate2DMake(latitude, longitude);
        
        if (stepIndex==0)
        {
            TrailsMap *point=[[TrailsMap alloc] initWithLocation:stepCoordinates[stepIndex]];
            point.title =[RouteName objectAtIndex:0];
            point.subtitle=[NSString stringWithFormat:@"Distance :%.0f Meters",distance];
            [self.MapView addAnnotation:point];
        }
        if (stepIndex==[steps count]-1)
        {
            stepIndex++;
            NSDictionary *end_location = [step objectForKey:@"end_location"];
            double latitude = [[end_location objectForKey:@"lat"] doubleValue];
            double longitude = [[end_location objectForKey:@"lng"] doubleValue];
            stepCoordinates[stepIndex] = CLLocationCoordinate2DMake(latitude, longitude);
            
            TrailsMap *point=[[TrailsMap alloc] initWithLocation:stepCoordinates[stepIndex]];
            point.title = [RouteName objectAtIndex:1];
            point.subtitle=[NSString stringWithFormat:@"Distance :%.0f Meters",distance];
            
            [self.MapView addAnnotation:point];
        }
        stepIndex++;
    }
    
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:stepCoordinates count: stepIndex];
    [MapView addOverlay:polyLine];
    [MapView setRegion:region animated:YES];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithRed:204/255. green:45/255. blue:70/255. alpha:1.0];
    polylineView.lineWidth = 5;
    
    return polylineView;
}
@end


