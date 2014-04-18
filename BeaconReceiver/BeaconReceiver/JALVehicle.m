//
//  JALVehicle.m
//  BeaconReceiver
//
//  Created by Josh Lieberman on 4/11/14.
//  Copyright (c) 2014 Josh Lieberman. All rights reserved.
//

#import "JALVehicle.h"

@implementation JALVehicle

// Mapping object values to Kinvey backend
- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"entityId" : KCSEntityKeyId, //the required _id field
             @"year" : @"year",
             @"make" : @"make",
             @"model" : @"model",
             @"color" : @"color"
             };
}

@end
