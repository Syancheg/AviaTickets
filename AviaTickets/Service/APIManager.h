//
//  APIManager.h
//  AviaTickets
//
//  Created by Константин Кузнецов on 07.06.2021.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

#define API_TOKEN @"0fa373e04e1c63743565bf8e13cc1486"
#define API_URL_IP_ADDRESS @"https://api.ipify.org/?format=json"
#define API_URL_CHEAP @"https://api.travelpayouts.com/v1/prices/cheap"
#define API_URL_CITY_FROM_IP @"https://www.travelpayouts.com/whereami?ip="

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

+(instancetype) sharedInstance;
-(void)cityForCurrentIP:(void (^)(City *city))completion;

@end

NS_ASSUME_NONNULL_END
