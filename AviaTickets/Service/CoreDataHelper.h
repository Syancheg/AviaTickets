//
//  CoreDataHelper.h
//  AviaTickets
//
//  Created by Константин Кузнецов on 07.06.2021.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FavoriteTicket+CoreDataClass.h"
#import "DataManager.h"
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray *)favorites:(NSInteger)type;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;

@end

NS_ASSUME_NONNULL_END
