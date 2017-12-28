#import <UIKit/UIKit.h>
#import "Utils.h"
@import GoogleMobileAds;

@interface CompetitionsTableViewController : UITableViewController
{
    NSString *sportSelectedTag;
    NSArray *arrayCompetitions;
}
@property NSString *sportSelectedTag;
@property(nonatomic, strong) GADInterstitial *interstitial;
@end
