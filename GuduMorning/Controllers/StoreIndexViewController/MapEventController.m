//
//  MapEventController.m
//  Mega
//
//  Created by Sergey on 2/4/15.
//  Copyright (c) 2015 Sergey. All rights reserved.
//

#import "MapEventController.h"
#import "MegaTheme.h"
@interface MapEventController ()

@end

@implementation MapEventController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    placeLabel.font = [UIFont fontWithName:MegaTheme.fontName size: 18];
    placeLabel.textColor = [UIColor blackColor];
    
    addressLabel.font = [UIFont fontWithName:MegaTheme.fontName size: 13];
    addressLabel.textColor = [UIColor colorWithWhite:0.43 alpha: 1.0];
    
    locationIconImageView.tintColor = [UIColor colorWithWhite:0.43 alpha: 1.0];
    locationIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    placeImageView.image = [UIImage imageNamed:@"club"];

    distanceLabel.text = @"1.4Km";
    distanceLabel.font = [UIFont fontWithName:MegaTheme.semiBoldFontName size:14];
    distanceLabel.textColor = [UIColor whiteColor];
    distanceLabelContainer.backgroundColor = [UIColor colorWithRed:0.34 green: 0.80 blue: 0.80 alpha: 1.0];
    distanceLabelContainer.layer.cornerRadius = 4;
    
    eventsTableView.dataSource = self;
    eventsTableView.delegate = self;
    eventsTableView.estimatedRowHeight = 100.0;
    eventsTableView.rowHeight = UITableViewAutomaticDimension;
    eventsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
   [[[RACObserve(self, store) skip:1] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
       
       // 店铺名
       placeLabel.text = self.store.name;

       // logo
       [placeImageView sd_setImageWithURL:kUrlFromString(self.store.logo_filename)];
       
       // 设置地址label
       addressLabel.text = self.store.address;
       
       //设置地图坐标
       CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[self.store.location.coordinates objectAtIndex:1] floatValue], [[self.store.location.coordinates objectAtIndex:0] floatValue]);
       MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
       MKCoordinateRegion region =  MKCoordinateRegionMake(coordinate, span);
       [self.mapView setRegion:region animated:YES];
       ADVMapAnnotation* annotation = [[ADVMapAnnotation alloc] initWithTitle:self.store.name subtitle: self.store.address coordinate: coordinate];
       [self.mapView removeAnnotations:self.mapView.annotations];
       [self.mapView addAnnotation:annotation];
   }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return events.count;
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   
//}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if([annotation isKindOfClass:[ADVMapAnnotation class]]) {
        
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Annotation"];
        
        if (annotationView == nil)
        {
            
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"map-annotation"];
        }
        
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    return nil;
}

@end

@implementation ADVMapAnnotation
-(instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    
    if (self) {
        
        self.ADVTitle = title;
        
        self.ADVSubTitle = subtitle;
        
        self.ADVCoordinate = coordinate;
        
    }
    return self;
}

-(NSString *)title
{
    return self.ADVTitle;
}

-(NSString *)subtitle
{
    
    return self.ADVSubTitle;
    
}
-(CLLocationCoordinate2D)coordinate
{
    return self.ADVCoordinate;
}

@end



