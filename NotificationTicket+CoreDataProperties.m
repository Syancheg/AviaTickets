//
//  NotificationTicket+CoreDataProperties.m
//  AviaTickets
//
//  Created by Константин Кузнецов on 09.06.2021.
//
//

#import "NotificationTicket+CoreDataProperties.h"

@implementation NotificationTicket (CoreDataProperties)

+ (NSFetchRequest<NotificationTicket *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"NotificationTicket"];
}

@dynamic created;
@dynamic departure;
@dynamic expires;
@dynamic airline;
@dynamic from;
@dynamic to;
@dynamic price;
@dynamic flightNumber;

@end
