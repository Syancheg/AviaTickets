//
//  TicketTableViewCell.m
//  AviaTickets
//
//  Created by Константин Кузнецов on 07.06.2021.
//

#import "TicketTableViewCell.h"

@interface TicketTableViewCell()
@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *placesLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation TicketTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.contentView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        self.contentView.layer.shadowRadius = 10.0;
        self.contentView.layer.shadowOpacity = 1.0;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        self.priceLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.priceLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
        [self.contentView addSubview:self.priceLabel];
        
        self.airlineLogoView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.airlineLogoView];
        
        self.placesLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.placesLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
        self.placesLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.placesLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.dateLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
        [self.contentView addSubview:self.dateLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 10.0, [UIScreen mainScreen].bounds.size.width - 20.0, self.frame.size.height - 20.0);
    
    self.priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - 110.0, 40.0);
    self.airlineLogoView.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + 10.0, 10.0, 80.0, 80.0);
    self.placesLabel.frame = CGRectMake(10.0, CGRectGetMaxY(self.priceLabel.frame) + 16.0, 100.0, 20.0);
    self.dateLabel.frame = CGRectMake(10.0, CGRectGetMaxY(self.placesLabel.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
    
    self.priceLabel.layer.opacity = 0;
    self.airlineLogoView.layer.opacity = 0;
    self.placesLabel.layer.opacity = 0;
    self.dateLabel.layer.opacity = 0;
    [self startAnimating];
}



- (void)setTicket:(Ticket *)ticket {
    _ticket = ticket;
    
    _priceLabel.text = [NSString stringWithFormat:@"%@ руб.", ticket.price];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:ticket.departure];
    [self loadImage:self.ticket.airline];
    
}

- (void)setFavoriteTicket:(FavoriteTicket *)favoriteTicket {
    _favoriteTicket = favoriteTicket;
    
    _priceLabel.text = [NSString stringWithFormat:@"%lld руб.", favoriteTicket.price];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", favoriteTicket.from, favoriteTicket.to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:favoriteTicket.departure];
    [self loadImage:self.favoriteTicket.airline];
}

- (void)loadImage: (NSString *)airline {
    NSString *url = [NSString stringWithFormat:@"http://ios.aviasales.ru/logos/xxhdpi/%@.png", airline];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSData *data=[NSData dataWithContentsOfURL:[NSURL  URLWithString:url]];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.airlineLogoView.image = image;
            [UIView animateWithDuration:0.5 animations:^{
                self.airlineLogoView.layer.opacity = 1;
            }];
        });
    });
}

-(void)startAnimating {
    [UIView animateWithDuration:2 animations:^{
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.05 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if(finished){
                self.contentView.frame = CGRectMake(10.0, 10.0, [UIScreen mainScreen].bounds.size.width - 20.0, self.frame.size.height - 20.0);
            }
        } completion:^(BOOL finished) {
            if (finished){
                [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.priceLabel.layer.opacity = 1;
                } completion:^(BOOL finished) {
                    if (finished){
                        [UIView animateWithDuration:0.3 animations:^{
                            self.placesLabel.layer.opacity = 1;
                            self.airlineLogoView.layer.opacity = 1;
                        } completion:^(BOOL finished) {
                            if(finished){
                                [UIView animateWithDuration:0.3 animations:^{
                                    self.dateLabel.layer.opacity = 1;
                                }];
                            }
                        }];
                    }
                }];
            }
        }];
    }];
}

@end
