//
//  MapEventController.h
//  Mega
//
//  Created by Sergey on 2/4/15.
//  Copyright (c) 2015 Sergey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapEventController : UIViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>
{
    
    IBOutlet UIImageView* placeImageView;
    IBOutlet UILabel* placeLabel;
    IBOutlet UILabel* addressLabel;
    IBOutlet UIImageView* locationIconImageView;
    
    IBOutlet UILabel* distanceLabel;
    IBOutlet UIView* distanceLabelContainer;
    
    IBOutlet UITableView* eventsTableView;
    
    NSArray* events;
}

/**
 *  从嵌套的上层StoreViewController获取的store
 */
@property (nonatomic, weak) StoreModel *store;

@property(nonatomic, strong) IBOutlet MKMapView* mapView;


@end

@interface ADVMapAnnotation : NSObject <MKAnnotation>

@property(nonatomic, strong) NSString* ADVTitle;
@property(nonatomic, strong) NSString* ADVSubTitle;
@property(nonatomic) CLLocationCoordinate2D ADVCoordinate;

-(instancetype)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle coordinate:(CLLocationCoordinate2D)coordinate;

@end
