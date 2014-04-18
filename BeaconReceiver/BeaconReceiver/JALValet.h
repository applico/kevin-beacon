//
//  JALValet.h
//  BeaconReceiver
//
//  Created by Josh Lieberman on 4/4/14.
//  Copyright (c) 2014 Josh Lieberman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>

// My Valet object

@interface JALValet : NSMutableDictionary <KCSPersistable>

@property (nonatomic, copy) NSString* entityId; //Kinvey entity _id

@property (nonatomic, copy) NSString* uuid; // UUID
//@property(nonatomic, copy) NSString *major; // major value
//@property(nonatomic, copy) NSString *minor; // minor value
@property (nonatomic, copy) NSString* valName; // valet name
@property (nonatomic, copy) NSString* price; // valet price
//@property (nonatomic, retain) KCSMetadata* metdata; //Kinvey metadata, optional

@end
