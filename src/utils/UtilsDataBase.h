#import <Foundation/Foundation.h>
#import "CompetitionEntity+CoreDataProperties.h"
#import "ClassificationEntity+CoreDataProperties.h"
#import "MatchEntity+CoreDataProperties.h"
#import "SportCourtEntity+CoreDataProperties.h"
#import "TeamEntity+CoreDataProperties.h"

@interface UtilsDataBase : NSObject

/** general */
+(void) deleteAllEntities:(NSString *)nameEntity;

/** matches */
+(NSArray *) queryMatches:(CompetitionEntity *) competitionEntity;
+(void) insertMatch:(NSDictionary *) dictionaryMatch withEntity:(CompetitionEntity *) competition;
+(void) deleteMatches:(CompetitionEntity *)competitionEntity;

/** classification */
+(NSArray *) queryClassification:(CompetitionEntity *) competitionEntity;
+(void) insertClassification:(NSDictionary *) dictionaryMatch withEntity:(CompetitionEntity *) competition;
+(void) deleteClassification:(CompetitionEntity *)competitionEntity;

/** sportCourt */
+(SportCourtEntity *) querySportCourtById:(long) idServer;
+(SportCourtEntity *) insertOrUpdateCourtEntity:(NSDictionary *) dictionary;

/** competition */
+(NSArray *) queryCompetitionsBySport:(NSString *) sportStr;
+(CompetitionEntity *) queryCompetitionsById:(long) competitionId;
+(NSMutableSet *) queryCompetitionIdsFavorites;
+(CompetitionEntity *) insertCompetition:(NSDictionary *) dictionaryCompetition;
+(void) markOrUnmarkCompetitionAsFavorite:(long)competitionId isFavorite:(BOOL)favorite;

/** teams */
+(NSArray *) queryTeams:(CompetitionEntity *)competitionEntity;
+(void) deleteTeams:(CompetitionEntity *)competitionEntity;
+(BOOL) isTeamFavorite:(NSString *) teamName withCompetition:(CompetitionEntity *) competitionEntity;
+(void) markOrUnmarkTeamAsFavorite:(NSString*)teamName withCompetition:(CompetitionEntity*)competitionEntity isFavorite:(BOOL)favorite;

@end
