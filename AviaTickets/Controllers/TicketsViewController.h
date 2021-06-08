//
//  TicketsViewController.h
//  AviaTickets
//
//  Created by Константин Кузнецов on 07.06.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TicketsViewController : UITableViewController

- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initFavoriteTicketsController;

@end

NS_ASSUME_NONNULL_END
