//
//  Ticket.m
//  AviaTickets
//
//  Created by Константин Кузнецов on 07.06.2021.
//

#import "Ticket.h"

@implementation Ticket

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.airline = [dictionary valueForKey:@"airline"];
        self.expires = dateFromString([dictionary valueForKey:@"expires_at"]);
        self.departure = dateFromString([dictionary valueForKey:@"departure_at"]);
        self.flightNumber = [dictionary valueForKey:@"flight_number"];
        self.price = [dictionary valueForKey:@"price"];
        self.returnDate = dateFromString([dictionary valueForKey:@"return_at"]);
    }
    return self;
}

NSDate *dateFromString(NSString *dateString) {
    if (!dateString) { return  nil; }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *correctSrtingDate = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    correctSrtingDate = [correctSrtingDate stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter dateFromString: correctSrtingDate];
}


@end
