//
//  TicketTableViewCell.h
//  AviaTickets
//
//  Created by Константин Кузнецов on 07.06.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
#import "Ticket.h"
#import "FavoriteTicket+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketTableViewCell : UITableViewCell
@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) FavoriteTicket *favoriteTicket;
-(void)startAnimating;
@end

NS_ASSUME_NONNULL_END
