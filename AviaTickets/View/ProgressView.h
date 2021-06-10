//
//  ProgressView.h
//  AviaTickets
//
//  Created by Константин Кузнецов on 09.06.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressView : UIView

+ (instancetype)sharedInstance;

- (void)show:(void (^)(void))completion;
- (void)dismiss:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
