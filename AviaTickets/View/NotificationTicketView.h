//
//  NotificationTicketView.h
//  AviaTickets
//
//  Created by Константин Кузнецов on 09.06.2021.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotificationTicketView : UIView
@property (nonatomic, strong) Ticket *ticket;
- (instancetype)initWithTicket:(Ticket *)ticket;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
