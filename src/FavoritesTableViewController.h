#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface FavoritesTableViewController : UITableViewController
{
    NSArray *arrayCompetitions;
    NSArray *arrayTeams;
}
@property(nonatomic, strong) GADInterstitial *interstitial;

@end
