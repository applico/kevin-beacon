//
//  JALValet.m
//  BeaconReceiver
//
//  Created by Josh Lieberman on 4/4/14.
//  Copyright (c) 2014 Josh Lieberman. All rights reserved.
//

#import "JALValet.h"

@implementation JALValet

// Mapping object values to Kinvey backend
- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"entityId" : KCSEntityKeyId, //the required _id field
             @"uuid" : @"uuid",
             @"valName" : @"valname",
             @"price" : @"price"
//             @"metadata" : KCSEntityKeyMetadata //optional _metadata field
             };
}

@end
