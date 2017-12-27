#import <UIKit/UIKit.h>
#import "CompetitionEntity+CoreDataProperties.h"
#import "FavoriteTeamEntity+CoreDataProperties.h"
#import "MatchEntity+CoreDataProperties.h"

@interface TeamMatchesTableViewController : UITableViewController
{
    NSMutableArray *matches;
    CompetitionEntity *competitionEntity;
    UIBarButtonItem *buttonFavorite;
    BOOL isFavoriteTeam;
    MatchEntity *matchEntity;
    NSString *teamName;
}
@property CompetitionEntity *competitionEntity;
@property NSString *teamName;
@end
