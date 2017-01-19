//
//  TrailsMap.m
//  MapViewLineDraw
//
//  Created by iSquare2 on 7/9/16.
//  Copyright © 2016 MitsSoft. All rights reserved.
//

#import "TrailsMap.h"

@implementation TrailsMap
@synthesize coordinate,title,image,subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord{
    
    self = [super init];
    if (self) {
        coordinate = coord;
        
    }
    return self;
}
@end