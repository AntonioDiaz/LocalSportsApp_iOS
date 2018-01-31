#import <Foundation/Foundation.h>
#import "CompetitionEntity+CoreDataProperties.h"
#import "ClassificationEntity+CoreDataProperties.h"
#import "MatchEntity+CoreDataProperties.h"
#import "SportCourtEntity+CoreDataProperties.h"
#import "FavoriteTeamEntity+CoreDataProperties.h"

@interface UtilsDataBase : NSObject

/** general */
+(void) deleteAllEntities:(NSString *)nameEntity;

/** matches */
+(NSArray *) queryMatches:(CompetitionEntity *) competitionEntity;
+(void) insertMatch:(NSDictionary *) dictionaryMatch withEntity:(CompetitionEntity *) competition withWeeksNames:(NSArray *)weeksNames;
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
+(CompetitionEntity *) queryCompetitionsByIdServer:(long) competitionId;
+(NSMutableSet *) queryCompetitionIdsFavorites;
+(CompetitionEntity *) insertCompetition:(NSDictionary *) dictionaryCompetition;
+(void) markOrUnmarkCompetitionAsFavorite:(long)competitionId isFavorite:(BOOL)favorite;
+(NSArray *) queryCompetitionsFavorites;

/** teams */
+(NSArray *) queryAllTeamsFavorites;
+(NSArray *) queryTeamsFavorites:(long)idCompetitionServer;
+(FavoriteTeamEntity*) queryTeamFavorite:(NSString *) teamName withCompetition:(long)idCompetitionServer;
+(void) deleteTeamsFavorites:(long)idCompetitionServer;
+(BOOL) isTeamFavorite:(NSString *) teamName withCompetition:(long)idCompetitionServer;
+(void) markOrUnmarkTeamAsFavorite:(NSString*)teamName withCompetition:(long)idCompetitionServer isFavorite:(BOOL)favorite;

@end
