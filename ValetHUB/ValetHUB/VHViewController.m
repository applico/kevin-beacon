//
//  VHViewController.m
//  ValetHUB
//
//  Created by Applico on 4/14/14.
//  Copyright (c) 2014 Applico. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "VHViewController.h"

@interface VHViewController () <CBPeripheralManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) NSDictionary *myBeaconData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (nonatomic, weak) IBOutlet UIButton *broadcastButton;
@property (nonatomic, assign) BOOL isBroadcasting;

@end

@implementation VHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _isBroadcasting = NO;

    // Create a NSUUID object
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"UUID String"];

    // Initialize the Beacon Region
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                  major:1
                                                                  minor:1
                                                             identifier:@"unique identifier"];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.myBeaconData = [self.myBeaconRegion peripheralDataWithMeasuredPower:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    //[self.peripheralManager stopAdvertising];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Local Methods

- (IBAction)updateBroadCastStatus:(id)sender {


    if(!self.isBroadcasting) {
    // Start the peripheral manager
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
    else {
        self.peripheralManager = nil;
        [self.broadcastButton setTitle:@"Start Broadcast" forState:UIControlStateNormal];
        self.isBroadcasting = NO;
    }
}


#pragma mark - CBPeripheralManagerDelegate callbacks

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        // Start broadcasting
        [self.peripheralManager startAdvertising:self.myBeaconData];
        [self.broadcastButton setTitle:@"Stop Broadcast" forState:UIControlStateNormal];
        self.isBroadcasting = YES;

    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        // Stop broadcasting

        [self.broadcastButton setTitle:@"Start Broadcast" forState:UIControlStateNormal];
        self.isBroadcasting = NO;
    }

}

@end
