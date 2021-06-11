//
//  MapViewController.m
//  AviaTickets
//
//  Created by Константин Кузнецов on 07.06.2021.
//

#import "MapViewController.h"
#import "LocationService.h"
#import "APIManager.h"
#import <MapKit/MapKit.h>
#import "DataManager.h"
#import "MapPrice.h"
#import <CoreLocation/CoreLocation.h>
#import "Ticket.h"
#import "CoreDataHelper.h"

@interface MapViewController ()

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Price Map", "");
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.mapView setDelegate:self];
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    [[DataManager sharedInstance] loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataLoadedSuccessfully {
    self.locationService = [[LocationService alloc] init];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion: region animated: YES];
    
    if (currentLocation) {
        _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
        if (_origin) {
            [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }
}


- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations: _mapView.annotations];
 
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld %@.", (long)price.value, NSLocalizedString(@"rub", "")];
            annotation.coordinate = price.destination.coordinate;
            [self->_mapView addAnnotation: annotation];
        });
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MarkerIdentifier";
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-5.0, 5.0);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        button.accessibilityValue = annotationView.annotation.title;
        [button addTarget:self action:@selector(addFavorites:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = button;
    }
    annotationView.annotation = annotation;
    return annotationView;
}

- (void) addFavorites: (UIButton *)sender {
    
    for (MapPrice *price in self.prices) {
        NSString *str = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
        if([sender.accessibilityValue isEqual:str]){
            Ticket *ticket = [[Ticket alloc] init];
            ticket.departure = price.departure;
            ticket.airline = price.airline;
            ticket.from = self.origin.code;
            ticket.to = price.destination.code;
            ticket.price = [NSNumber numberWithLong:price.value];
            ticket.type = [NSNumber numberWithInt:1];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Actions with the ticket", "") message:NSLocalizedString(@"What should I do with the selected ticket?", "") preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *favoriteAction;
            
            if ([[CoreDataHelper sharedInstance] isFavorite: ticket]) {
                favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete from Favorites", "") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [[CoreDataHelper sharedInstance] removeFromFavorite:ticket];
                }];
            } else {
                favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add to Favorites", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[CoreDataHelper sharedInstance] addToFavorite:ticket];
                }];
            }
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", "") style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:favoriteAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }
    
}


@end
