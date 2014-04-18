//
//  JALViewController.m
//  BeaconReceiver
//
//  Created by Josh Lieberman on 4/4/14.
//  Copyright (c) 2014 Josh Lieberman. All rights reserved.
//

#import "JALViewController.h"
#import <KinveyKit/KinveyKit.h>
#import "JALValet.h"
#import "JALVehicle.h"

#define StringFromBOOL(b) ((b) ? @"YES" : @"NO")

// Need to add the CLLocationManagerDelegate to the interface declaration.
@interface JALViewController () <CLLocationManagerDelegate>
@end

@implementation JALViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // hide the check in button when a valet is not available
    self.checkInButton.hidden = YES;
    // hide valet info text labels
    self.nameLabel.hidden = YES;
    self.priceLabel.hidden = YES;

    // Initialize location manager and set ourselves as the delegate.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"UUID String"];
    // E2C56DB5-DFFB-48D2-B060-D0F5A71096E0 radius
    // A77A1B68-49A7-4DBF-914C-760D07FBB87B appcoda

    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                              identifier:@""];

    // Tell location manager to start monitoring for the beacon region
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];

    // button
    [self.checkInButton addTarget:self action:@selector(checkInButtonPressed:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];

//    NSNumber *major = region.major;
//    NSNumber *minor = region.minor;
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    // we left the beacon region or lost signal somehow
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
    NSLog(@"lost beacon\n");
    self.statusLabel.text = @"Searching for Beacon...";
    // hide UI elements
    dispatch_async(dispatch_get_main_queue(), ^{
        self.nameLabel.hidden = YES;
        self.priceLabel.hidden = YES;
        self.checkInButton.hidden = YES;
    });

    NSLog(@"%@\n", StringFromBOOL(self.nameLabel.hidden));
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    self.statusLabel.text = @"Beacon found!";

    // stop ranging
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];

    CLBeacon *foundBeacon = [beacons firstObject];

    // You can retrieve the beacon data from its properties
//    NSString *uuid = foundBeacon.proximityUUID.UUIDString;
//    NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
//    NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];

    // Kinvey

    // query
    KCSQuery* query = [KCSQuery queryOnField:@"uuid" withExactMatchForValue:@"UUID String"];

    // valet data store
    KCSAppdataStore* _store = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"valets",
                                                      KCSStoreKeyCollectionTemplateClass : [JALValet class]}];

    [_store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            //got query back from server
            NSString* name = [objectsOrNil[0] objectForKey:(@"valname")];
            NSString* price = [objectsOrNil[0] objectForKey:(@"price")];

            // unhide UI elements
            self.checkInButton.hidden = NO;
            self.nameLabel.hidden = NO;
            self.priceLabel.hidden = NO;

            NSString* valN = @"Valet name: ";
            NSString* priceDol = @"Price: $";

            self.nameLabel.text = [NSString stringWithFormat:@"%@%@", valN, name]; // set valet name label
            self.priceLabel.text = [NSString stringWithFormat:@"%@%@", priceDol, price]; // set price label


        }
    } withProgressBlock:nil];

}

- (void)checkInButtonPressed:(id)sender {
    // on check in button tap, send info to kinvey
    JALVehicle* vehicle = [[JALVehicle alloc] init];
    vehicle.year = @"1993";
    vehicle.make = @"Geo";
    vehicle.model = @"Tracker";
    vehicle.color = @"Purple";

    // vehicle data store
    KCSAppdataStore* vehicleStore = [KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"vehicles",
                                                                         KCSStoreKeyCollectionTemplateClass : [JALVehicle class]}];

    [vehicleStore saveObject:vehicle withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Save failed", @"Save Failed")
                                                                message:[errorOrNil localizedFailureReason] //not actually localized
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                      otherButtonTitles:nil];
            [alertView show];
        } else {
            //save was successful
            NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
        }
    } withProgressBlock:nil];

}

@end
