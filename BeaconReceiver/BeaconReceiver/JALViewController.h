//
//  JALViewController.h
//  BeaconReceiver
//
//  Created by Josh Lieberman on 4/4/14.
//  Copyright (c) 2014 Josh Lieberman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface JALViewController : UIViewController

// Keep track of the beacon region we’re trying to detect
@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;

// Hold the location manager which will give us updates on beacons found
@property (strong, nonatomic) CLLocationManager *locationManager;

// Text label showing if we're in range of the beacon
@property (weak, nonatomic) IBOutlet UILabel *statusLabel; // beacon found or lost
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; // name of valet
@property (weak, nonatomic) IBOutlet UILabel *priceLabel; // price of valet
@property (weak, nonatomic) IBOutlet UIButton *checkInButton; // vehicle check in


@end
