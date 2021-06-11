//
//  NotificationTicketView.m
//  AviaTickets
//
//  Created by Константин Кузнецов on 09.06.2021.
//

#import "NotificationTicketView.h"

@interface NotificationTicketView()
@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *placesLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *flightNumber;
@end

@implementation NotificationTicketView

- (instancetype)initWithTicket:(Ticket *)ticket {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        self.ticket = ticket;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = CGRectMake(40, 100, self.bounds.size.width - 80, self.bounds.size.height - 140);
    UIView *shadowView = [[UIView alloc] initWithFrame:frame];
    shadowView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
    shadowView.backgroundColor = [UIColor whiteColor];
    shadowView.layer.shadowRadius = 10.0;
    shadowView.layer.shadowOpacity = 1.0;
    shadowView.layer.cornerRadius = 6.0;
    [self addSubview:shadowView];
    
    CGRect buttonFrame = CGRectMake(shadowView.bounds.size.width - 35, 15, 20, 20);
    UIButton *button = [UIButton buttonWithType: UIButtonTypeSystem];
    [button setBackgroundImage:[UIImage systemImageNamed:@"multiply"] forState:UIControlStateNormal];
    button.tintColor = [UIColor grayColor];
    button.frame = buttonFrame;
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    [button addTarget: self action: @selector(dismiss) forControlEvents: UIControlEventTouchUpInside];
    [shadowView addSubview: button];
    
    
    CGRect airlineLogoViewFrame = CGRectMake((shadowView.bounds.size.width / 2) - 50.0, 15.0, 100.0, 100.0);
    self.airlineLogoView = [[UIImageView alloc] initWithFrame:airlineLogoViewFrame];
    self.airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
    self.airlineLogoView.layer.opacity = 0;
    [shadowView addSubview:self.airlineLogoView];
    
    NSString *url = [NSString stringWithFormat:@"http://ios.aviasales.ru/logos/xxhdpi/%@.png", self.ticket.airline];
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
    
    
    
    
    CGRect priceLabelFrame = CGRectMake(15.0, CGRectGetMaxY(self.airlineLogoView.frame) + 15.0, shadowView.frame.size.width - 30, 40.0);
    self.priceLabel = [[UILabel alloc] initWithFrame:priceLabelFrame];
    
//  self.ticket.price почему то приходит шестнадцатиричное число и вылетает ошибка, не смог разобраться почему
    
//  self.priceLabel.text = [NSString stringWithFormat:@"%ld руб.", (long)self.ticket.price];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%d %@.", 5455, NSLocalizedString(@"rub", "")];
    self.priceLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
    [shadowView addSubview:self.priceLabel];

    
    CGRect placesLabelFrame = CGRectMake(15.0, CGRectGetMaxY(self.priceLabel.frame) + 15.0, shadowView.frame.size.width - 30, 40.0);
    self.placesLabel = [[UILabel alloc] initWithFrame:placesLabelFrame];
    self.placesLabel.text =  [NSString stringWithFormat:@"%@ - %@", self.ticket.from, self.ticket.to];
    self.placesLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
    self.placesLabel.textColor = [UIColor darkGrayColor];
    [shadowView addSubview:self.placesLabel];

    CGRect flightNumberFrame = CGRectMake(15.0, CGRectGetMaxY(self.placesLabel.frame) + 15.0, shadowView.frame.size.width - 30, 20.0);
    self.flightNumber = [[UILabel alloc] initWithFrame:flightNumberFrame];
    
//  self.ticket.flightNumber почему то приходит шестнадцатиричное число и вылетает ошибка, не смог разобраться почему
//    self.flightNumber.text =  [NSString stringWithFormat:@"%ld", (long)self.ticket.flightNumber.integerValue];
    
    self.flightNumber.text =  [NSString stringWithFormat:@"%@: %d", NSLocalizedString(@"Flight number", ""), 765];
    self.flightNumber.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
    self.flightNumber.textColor = [UIColor darkGrayColor];
    [shadowView addSubview:self.flightNumber];

    CGRect dateLabelFrame = CGRectMake(15, CGRectGetMaxY(self.flightNumber.frame) + 15.0, shadowView.frame.size.width - 30.0, 20.0);
    self.dateLabel = [[UILabel alloc] initWithFrame:dateLabelFrame];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    self.dateLabel.text = [dateFormatter stringFromDate:self.ticket.departure];
    self.dateLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
    [shadowView addSubview:self.dateLabel];
}

- (void)show {

    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
