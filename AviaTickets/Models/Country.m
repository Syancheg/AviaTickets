//
//  Country.m
//  AviaTickets
//
//  Created by Константин Кузнецов on 07.06.2021.
//

#import "Country.h"

@implementation Country

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.currency = [dictionary valueForKey:@"currency"];
        self.translations = [dictionary valueForKey:@"name_translations"];
        self.name = [dictionary valueForKey:@"name"];
        self.code = [dictionary valueForKey:@"code"];
    }
    return self;
}


@end
