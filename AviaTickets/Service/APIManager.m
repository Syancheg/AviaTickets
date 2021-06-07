//
//  APIManager.m
//  AviaTickets
//
//  Created by Константин Кузнецов on 07.06.2021.
//

#import "APIManager.h"
#import "MapPrice.h"

@implementation APIManager

+ (instancetype)sharedInstance {
    static APIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[APIManager alloc] init];
    });
    return instance;
}

- (void)cityForCurrentIP:(void (^)(City *city))completion {
    [self IPAddressWithCompletion:^(NSString *ipAddress) {
        [self load:[NSString stringWithFormat:@"%@%@", API_URL_CITY_FROM_IP, ipAddress] withCompletion:^(id  _Nullable result) {
            NSDictionary *json = result;
            NSString *iata = [json valueForKey:@"iata"];
            if (iata) {
                City *city = [[DataManager sharedInstance] cityForIATA:iata];
                if (city) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(city);
                    });
                }
            }
        }];
    }];
}

- (void)IPAddressWithCompletion:(void (^)(NSString *ipAddress))completion {
    [self load:API_URL_IP_ADDRESS withCompletion:^(id  _Nullable result) {
        NSDictionary *json = result;
        completion([json valueForKey:@"ip"]);
    }];
}

- (void)load:(NSString *)urlString withCompletion:(void (^)(id _Nullable result))completion {
//    dispatch_async(dispatch_get_main_queue(), ^{
//       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    });
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        });
        completion([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
    }] resume] ;
}

- (void)mapPricesFor:(City *)origin withCompletion:(void (^)(NSArray *prices))completion
{
    static BOOL isLoading;
    if (isLoading) { return; }
    isLoading = YES;
    [self load:[NSString stringWithFormat:@"%@%@", API_URL_MAP_PRICE, origin.code] withCompletion:^(id  _Nullable result) {
        NSArray *array = result;
        NSMutableArray *prices = [NSMutableArray new];
        if (array) {
            for (NSDictionary *mapPriceDictionary in array) {
                MapPrice *mapPrice = [[MapPrice alloc] initWithDictionary:mapPriceDictionary withOrigin:origin];
                [prices addObject:mapPrice];
            }
            isLoading = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(prices);
            });
        }
    }];
}


@end
