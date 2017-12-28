#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Utils : NSObject

#define URL_TOWNS @"https://localsports-web.appspot.com/server/towns"
#define URL_COMPETITIONS @"https://localsports-web.appspot.com/server/search_competitions/?idTown=%@"
#define URL_COMPETITION_DETAILS @"https://localsports-web.appspot.com/server/competitiondetails/%@"
#define URL_SEND_ISSUE @"https://localsports-web.appspot.com/server/issues/"
#define PREF_TOWN_NAME @"PREF_TOWN_NAME"
#define PREF_TOWN_ID @"PREF_TOWN_ID"
#define PREF_TOWN_SPORTS @"PREF_TOWN_SPORTS"
#define PREF_PRIMARY_COLOR @"PREF_PRIMARY_COLOR"
#define PREF_ACCENT_COLOR @"PREF_ACCENT_COLOR"

#define COUNT_PRINTSCREEN_RESULTS @"COUNT_PRINTSCREEN_RESULTS"

#define COMPETITION_ENTITY @"CompetitionEntity"
#define MATCH_ENTITY @"MatchEntity"
#define CLASSIFICATION_ENTITY @"ClassificationEntity"
#define COURT_ENTITY @"SportCourtEntity"
#define FAVORITE_TEAM_ENTITY @"FavoriteTeamEntity"

#define SECONDS_IN_TWO_HOURS 2*60*60

#define SEGUE_EVENT @"segue_event"
#define SEGUE_MAP @"segue_map"
#define SEGUE_POST @"segue_post"

#define AD_UNIT_ID_INTERSTITIAL @"ca-app-pub-3940256099942544/4411468910"
#define AD_UNIT_ID_BANNER @"ca-app-pub-3940256099942544/2934735716"


#define COLOR_ACCENT 0xff4081
#define COLOR_PRIMARY 0x0061a8
#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
    blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
    alpha:1.0]

typedef NS_ENUM (NSInteger, EnumStates) {
    PENDING = 0,
    PLAYED = 1,
    CANCELED = 2
};

+(void)showComingSoon;
+(void)showAlert:(NSString *) description;
+(NSString *) formatDate:(NSDate *) date;
+(NSString *) formatDateDoubleToStr:(double) dateDouble;
+(NSDate *) formatDateDoubleToDate:(double) dateDouble;
+(NSString *) dictionaryToString:(NSDictionary *) dictionary;
+(BOOL) noTengoInterne;
+(UIImage *) imageWithSize:(UIImage *)image scaledToSize:(CGSize)newSize;
+(void) actionShareMatch:(NSString *) textToShare inViewController:(UIViewController *) viewController;
+(UIColor *) primaryColor;
+(UIColor *) primaryColorDarker;
+(UIColor *) primaryColorLighter;
+(UIColor *) accentColor;
+(NSInteger)intFromHexString:(NSString *) hexStr;
+(UIColor *)lighterColorForColor:(UIColor *)c;
+(UIColor *)darkerColorForColor:(UIColor *)c;
+(void)showInterstitial:(GADInterstitial *)intestitial inViewController:(UIViewController *)viewController;
@end
