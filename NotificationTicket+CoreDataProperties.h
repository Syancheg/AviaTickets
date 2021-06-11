//
//  NotificationTicket+CoreDataProperties.h
//  AviaTickets
//
//  Created by Константин Кузнецов on 09.06.2021.
//
//

#import "NotificationTicket+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NotificationTicket (CoreDataProperties)

+ (NSFetchRequest<NotificationTicket *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSDate *expires;
@property (nullable, nonatomic, copy) NSString *airline;
@property (nullable, nonatomic, copy) NSString *from;
@property (nullable, nonatomic, copy) NSString *to;
@property (nonatomic) int64_t price;
@property (nonatomic) int16_t flightNumber;

@end

NS_ASSUME_NONNULL_END
