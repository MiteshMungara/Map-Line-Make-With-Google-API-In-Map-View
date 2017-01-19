//
//  TrailsMap.h
//  MapViewLineDraw
//
//  Created by iSquare2 on 7/9/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>
@interface TrailsMap : NSObject
{
    CLLocationCoordinate2D coordinate;
    
    NSString *title;
    NSString *image;
    NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@end
