//
//  JALVehicle.h
//  BeaconReceiver
//
//  Created by Josh Lieberman on 4/11/14.
//  Copyright (c) 2014 Josh Lieberman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>
// Vehicle object

@interface JALVehicle : NSObject <KCSPersistable>

@property (nonatomic, copy) NSString* entityId; //Kinvey entity _id

@property (nonatomic, copy) NSString* year;
@property (nonatomic, copy) NSString* make;
@property (nonatomic, copy) NSString* model;
@property (nonatomic, copy) NSString* color;


@end
