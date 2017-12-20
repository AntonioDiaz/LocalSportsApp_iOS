#import <UIKit/UIKit.h>
#import "CompetitionEntity+CoreDataProperties.h"
#import "FavoriteTeamEntity+CoreDataProperties.h"

@interface TeamsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    CompetitionEntity *competitionEntity;
    NSMutableArray *arrayTeams;
    //array of arrays with the team matches.
    NSMutableArray *arrayTeamMatches;
    NSMutableIndexSet *sectionsExpanded;
}

@property (weak, nonatomic) IBOutlet UITableView *tableViewTeams;
-(void) reloadDataTable:(CompetitionEntity *) competition;

@end
