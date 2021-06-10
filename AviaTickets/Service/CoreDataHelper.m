//
//  CoreDataHelper.m
//  AviaTickets
//
//  Created by Константин Кузнецов on 07.06.2021.
//

#import "CoreDataHelper.h"

@interface CoreDataHelper ()
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

@implementation CoreDataHelper

+ (instancetype)sharedInstance
{
    static CoreDataHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataHelper alloc] init];
        [instance setup];
    });
    return instance;
}

- (void)setup {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FavoriteTicket" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [docsURL URLByAppendingPathComponent:@"base.sqlite"];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];

    NSPersistentStore* store = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    if (!store) {
        abort();
    }

    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
}

- (void)save {
    NSError *error;
    [self.managedObjectContext save: &error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
    return [[self.managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (BOOL)isFavorite:(Ticket *)ticket {
    return [self favoriteFromTicket:ticket] != nil;
}

- (void)addToFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:_managedObjectContext];
    favorite.price = ticket.price.intValue;
    favorite.airline = ticket.airline;
    favorite.departure = ticket.departure;
    favorite.expires = ticket.expires;
    favorite.flightNumber = ticket.flightNumber.intValue;
    favorite.returnDate = ticket.returnDate;
    favorite.from = ticket.from;
    favorite.to = ticket.to;
    favorite.created = [NSDate date];
    favorite.type = ticket.type.intValue;
    [self save];
}

- (void)removeFromFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [self favoriteFromTicket:ticket];
    if (favorite) {
        [_managedObjectContext deleteObject:favorite];
        [self save];
    }
}

- (NSArray *)favorites:(NSInteger)type {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    NSString *format = [NSString stringWithFormat:@"type == (%ld)", type];
    request.predicate = [NSPredicate predicateWithFormat: format];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

- (void)addNotificationTicket:(Ticket *)ticket forDate:(NSDate *)date {
    NotificationTicket *notificationTicket = [NSEntityDescription insertNewObjectForEntityForName:@"NotificationTicket" inManagedObjectContext:_managedObjectContext];
    notificationTicket.created = date;
    notificationTicket.departure = ticket.departure;
    notificationTicket.expires = ticket.expires;
    notificationTicket.airline = ticket.airline;
    notificationTicket.from = ticket.from;
    notificationTicket.to  = ticket.to;
    notificationTicket.price = ticket.price.intValue;
    notificationTicket.flightNumber = ticket.flightNumber.intValue;
    [self save];
}
- (void)removeNotificationTicket: (Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NotificationTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
    NotificationTicket *notificationTicket = [[self.managedObjectContext executeFetchRequest:request error:nil] firstObject];
    if (notificationTicket) {
        [_managedObjectContext deleteObject:notificationTicket];
        [self save];
    }
}
- (Ticket *)getNotificationTicket: (NSDate *)date {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NotificationTicket"];
    request.predicate = [NSPredicate predicateWithFormat: @"created = %@", date];
    Ticket *ticket = [_managedObjectContext executeFetchRequest:request error:nil].firstObject;
    if(ticket){
        return ticket;
    }
    return [Ticket new];;
}


@end
