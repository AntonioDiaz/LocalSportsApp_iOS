#import "CompetitionTabBarController.h"
#import "MatchEntity+CoreDataProperties.h"
#import "ClassificationEntity+CoreDataProperties.h"
#import "SportCourtEntity+CoreDataProperties.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "UtilsDataBase.h"
#import "ClassificationTableViewController.h"
#import "CalendarViewController.h"


@implementation CompetitionTabBarController

@synthesize competitionEntity;

- (void)viewDidLoad {
    [super viewDidLoad];
    //show interstitial
    self.navigationItem.title = [NSString stringWithFormat:@"%@", self.competitionEntity.name];
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    managedObjectContext = app.persistentContainer.viewContext;
    //add calendar image to tabbar
    UITabBarItem *tabBarItemCalendar = [self.tabBar.items objectAtIndex:0];
    UIImage *imageCalendar = [UIImage imageNamed:@"calendar"];
    imageCalendar = [Utils imageWithImage:imageCalendar scaledToSize:CGSizeMake(30, 30)];
    [tabBarItemCalendar setImage:imageCalendar];
    //add classification image to tabbar
    UITabBarItem *tabBarItemClassification = [self.tabBar.items objectAtIndex:1];
    UIImage *imageClassification = [UIImage imageNamed:@"classification"];
    imageClassification = [Utils imageWithImage:imageClassification scaledToSize:CGSizeMake(30, 30)];
    [tabBarItemClassification setImage:imageClassification];
    //add classification image to tabbar
    UITabBarItem *tabBarItemTeam = [self.tabBar.items objectAtIndex:2];
    UIImage *imageTeam = [UIImage imageNamed:@"team"];
    imageTeam = [Utils imageWithImage:imageTeam scaledToSize:CGSizeMake(30, 30)];
    [tabBarItemTeam setImage:imageTeam];
    //load competitions details on DB.
    NSString *idCompetitionServer = [NSString stringWithFormat: @"%f", self.competitionEntity.idCompetitionServer];
    if ([Utils noTengoInterne]) {
        [self reloadTabsData];
    } else {
        [self loadCompetitionDetails:idCompetitionServer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString * strBack = NSLocalizedString(NSLocalizedString(@"BACK", nil), nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:strBack style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - private methods
/** Load details (matches and classification) from server and update tables in DB. */
-(void) loadCompetitionDetails:(NSString *) idCompetition {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config];
    NSString *strUrlCompetitions = [NSString stringWithFormat:URL_COMPETITION_DETAILS, idCompetition];
    NSURL *url = [NSURL URLWithString:strUrlCompetitions];
    NSURLSessionTask *task = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error on task: %@", error.description);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode == 200) {
                NSError *jsonError = nil;
                NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                NSArray *arrayMatches = [jsonResults objectForKey:@"matches"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UtilsDataBase deleteMatches:competitionEntity];
                    [UtilsDataBase deleteClassification:competitionEntity];
                    [UtilsDataBase deleteAllEntities:COURT_ENTITY];
                    for (NSDictionary *matchDictionary in arrayMatches) {
                        [UtilsDataBase insertMatch: matchDictionary withEntity:self.competitionEntity];
                    }
                    NSArray *arrayClassification = [jsonResults objectForKey:@"classification"];
                    for (NSDictionary *classification in arrayClassification) {
                        [UtilsDataBase insertClassification: classification withEntity:self.competitionEntity];
                    }
                    [self reloadTabsData];
                });
            } else {
                NSLog(@"status: %d", (int)httpResponse.statusCode);
            }
        }
    }];
    [task resume];
}

-(void) reloadTabsData {
    CalendarViewController *calendarViewController = self.viewControllers[0];
    [calendarViewController reloadDataTable:self.competitionEntity];
    ClassificationTableViewController *classificationTableViewController = self.viewControllers[1];
    [classificationTableViewController reloadDataTable:self.competitionEntity];
}
@end