#import "UtilsDataBase.h"
#import "AppDelegate.h"
#import "Utils.h"

@implementation UtilsDataBase

#pragma mark - general
+(void) deleteAllEntities:(NSString *)nameEntity {
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects) {
        [context deleteObject:object];
    }
    error = nil;
    [context save:&error];
    if(error){
        NSLog(@"deleteAllEntities error -->%@", error.localizedDescription);
    }
}

#pragma mark - matches
+(NSArray *) queryMatches:(CompetitionEntity *) competitionEntity {
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:MATCH_ENTITY inManagedObjectContext:context];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"competition == %@", competitionEntity];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *matchesArray = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"queryMatches error -->%@", error.localizedDescription);
    }
    return matchesArray;
}

/** insert match entry in DB. */
+(void) insertMatch:(NSDictionary *) dictionaryMatch withEntity:(CompetitionEntity *) competition withWeeksNames:(NSArray *)weeksNames {
    NSManagedObjectContext *context = [self getContext];
    MatchEntity *matchEntity =  [NSEntityDescription
                                 insertNewObjectForEntityForName:MATCH_ENTITY
                                 inManagedObjectContext:context];
    NSDictionary* dictionaryTeamLocal = [dictionaryMatch objectForKey:@"teamLocalEntity"];
    NSDictionary* dictionaryTeamVisitor = [dictionaryMatch objectForKey:@"teamVisitorEntity"];
    NSDictionary* dictionarySportCenterCourt = [dictionaryMatch objectForKey:@"sportCenterCourt"];

    matchEntity.lastUpdate = (int)[[dictionaryMatch objectForKey:@"lastUpdate"] integerValue];
    matchEntity.scoreLocal = (int)[[dictionaryMatch objectForKey:@"scoreLocal"] integerValue];
    matchEntity.scoreVisitor = (int)[[dictionaryMatch objectForKey:@"scoreVisitor"] integerValue];
    matchEntity.state = (int)[[dictionaryMatch objectForKey:@"state"] integerValue];
    matchEntity.teamLocal = [dictionaryTeamLocal objectForKey:@"name"];
    if (dictionaryTeamVisitor != (id)[NSNull null]) {
        matchEntity.teamVisitor = [dictionaryTeamVisitor objectForKey:@"name"];
    }
    matchEntity.week = (int)[[dictionaryMatch objectForKey:@"week"] integerValue];
    matchEntity.weekName = [weeksNames objectAtIndex:matchEntity.week - 1];
    if ([dictionaryMatch objectForKey:@"date"] != (id)[NSNull null]) {
        matchEntity.date = [[dictionaryMatch objectForKey:@"date"] doubleValue];
    }
    matchEntity.idServer = [[dictionaryMatch objectForKey:@"id"] doubleValue];
    matchEntity.competition = competition;
    if (dictionarySportCenterCourt != (id)[NSNull null]) {
        SportCourtEntity *courtEntity = [self insertOrUpdateCourtEntity:dictionarySportCenterCourt];
        matchEntity.court = courtEntity;
    }
    NSError *error = nil;
    if(![context save:&error]){
        NSLog(@"Error on insert -->%@", error.localizedDescription);
    }
}

+(void) deleteMatches:(CompetitionEntity *)competitionEntity {
    NSManagedObjectContext *context = [self getContext];
    NSError *error;
    NSArray *fetchedObjects = [UtilsDataBase queryMatches:competitionEntity];
    for (NSManagedObject *object in fetchedObjects) {
        [context deleteObject:object];
    }
    error = nil;
    [context save:&error];
    if(error){
        NSLog(@"deleteMatches error -->%@", error.localizedDescription);
    }
}
#pragma mark - classification
+(NSArray *) queryClassification:(CompetitionEntity *)competitionEntity {
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:CLASSIFICATION_ENTITY inManagedObjectContext:context];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"competition == %@", competitionEntity];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *matchesClassification = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"queryClassification error -->%@", error.localizedDescription);
    }
    return matchesClassification;
}

/** insert classification entry in DB. */
+(void) insertClassification:(NSDictionary *) dictionaryClassification withEntity:(CompetitionEntity *) competition {
    NSManagedObjectContext *context = [self getContext];
    ClassificationEntity *classificationEntry =  [NSEntityDescription
                                                  insertNewObjectForEntityForName:CLASSIFICATION_ENTITY
                                                  inManagedObjectContext:context];
    classificationEntry.competition = competition;
    classificationEntry.matchesDrawn = (int)[[dictionaryClassification objectForKey:@"matchesDrawn"] integerValue];
    classificationEntry.matchesLost = (int)[[dictionaryClassification objectForKey:@"matchesLost"] integerValue];
    classificationEntry.matchesPlayed = (int)[[dictionaryClassification objectForKey:@"matchesPlayed"] integerValue];
    classificationEntry.matchesWon = (int)[[dictionaryClassification objectForKey:@"matchesWon"] integerValue];
    classificationEntry.points = (int)[[dictionaryClassification objectForKey:@"points"] integerValue];
    classificationEntry.position = (int)[[dictionaryClassification objectForKey:@"position"] integerValue];
    classificationEntry.team = [dictionaryClassification objectForKey:@"team"];
    NSError *error = nil;
    if(![context save:&error]){
        NSLog(@"Error on insert -->%@", error.localizedDescription);
    }
}

+(void) deleteClassification:(CompetitionEntity *)competitionEntity {
    NSManagedObjectContext *context = [self getContext];
    NSError *error;
    NSArray *fetchedObjects = [UtilsDataBase queryClassification:competitionEntity];
    for (NSManagedObject *object in fetchedObjects) {
        [context deleteObject:object];
    }
    error = nil;
    [context save:&error];
    if(error){
        NSLog(@"deleteClassification error -->%@", error.localizedDescription);
    }
}

#pragma mark - sportCourt
+(SportCourtEntity *) querySportCourtById:(long) idServer {
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:COURT_ENTITY inManagedObjectContext:context];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idServer == %ld", idServer];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *courts = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"querySportCourtById error -->%@", error.localizedDescription);
    }
    return courts.count==0 ? nil: [courts objectAtIndex:0];
}

+(SportCourtEntity *) insertOrUpdateCourtEntity:(NSDictionary *) dictionary {
    NSManagedObjectContext *context = [self getContext];
    //check if exist this sportCenter.
    long idServer = [[dictionary objectForKey:@"id"] longValue];
    SportCourtEntity *sportCenterEntity = [self querySportCourtById:idServer];
    if (!sportCenterEntity) {
        sportCenterEntity =  [NSEntityDescription
                              insertNewObjectForEntityForName:COURT_ENTITY
                              inManagedObjectContext:context];
    }
    NSDictionary* sportCenterDictionary = [dictionary objectForKey:@"sportCenter"];
    sportCenterEntity.courtName = [dictionary objectForKey:@"nameWithCenter"];
    sportCenterEntity.centerName = [sportCenterDictionary objectForKey:@"name"];
    sportCenterEntity.centerAddress = [sportCenterDictionary objectForKey:@"address"];
    sportCenterEntity.idServer = idServer;
    NSError *error = nil;
    if(![context save:&error]){
        NSLog(@"Error on insertOrUpdateCourtEntity -->%@", error.localizedDescription);
    }
    return sportCenterEntity;
}

#pragma mark - competition
+(NSArray *) queryCompetitionsBySport:(NSString *) sportStr {
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:COMPETITION_ENTITY inManagedObjectContext:context];
    [fetchRequest setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sport == %@", sportStr];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"categoryOrder" ascending:YES]; //the key is the attribute you want to sort by
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSError *error;
    NSArray *arrayCompetitions = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"queryCompetitionsBySport error -->%@", error.localizedDescription);
    }
    return arrayCompetitions;
}

+(CompetitionEntity *) queryCompetitionsByIdServer:(long) competitionId {
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:COMPETITION_ENTITY inManagedObjectContext:context];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCompetitionServer == %ld", competitionId];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *competitions = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"querySportCourtById error -->%@", error.localizedDescription);
    }
    return competitions.count==0 ? nil: [competitions objectAtIndex:0];
}

+(NSMutableSet *) queryCompetitionIdsFavorites {
    NSMutableSet * favoritesId = [[NSMutableSet alloc] init];
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:COMPETITION_ENTITY inManagedObjectContext:context];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite == true"];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *competitions = [context executeFetchRequest:request error:&error];
    for (CompetitionEntity *competition in competitions) {
        NSNumber* idCompetition = [NSNumber numberWithDouble:competition.idCompetitionServer];
        [favoritesId addObject:idCompetition];
    }
    if(error){
        NSLog(@"queryCompetitionIdsFavorites error -->%@", error.localizedDescription);
    }
    return favoritesId;
}

+(CompetitionEntity *) insertCompetition:(NSDictionary *) dictionaryCompetition {
    NSManagedObjectContext *context = [self getContext];
    CompetitionEntity *competitionEntity =  [NSEntityDescription
                                             insertNewObjectForEntityForName:COMPETITION_ENTITY
                                             inManagedObjectContext:context];
    NSDictionary *dictionaryCategory = [dictionaryCompetition objectForKey:@"categoryEntity"];
    NSDictionary *dictionarySport = [dictionaryCompetition objectForKey:@"sportEntity"];
    competitionEntity.category = [dictionaryCategory objectForKey:@"name"];
    competitionEntity.categoryOrder = (int)[[dictionaryCategory objectForKey:@"order"] integerValue];
    competitionEntity.idCompetitionServer = [[dictionaryCompetition objectForKey:@"id"] doubleValue];
    //competitionEntity.lastUpdateApp = [dictionaryCompetition objectForKey:@"lastPublished"];
    //competitionEntity.lastUpdateServer = [dictionaryCompetition objectForKey:@"lastPublished"];
    competitionEntity.name = [dictionaryCompetition objectForKey:@"name"];
    competitionEntity.sport = [dictionarySport objectForKey:@"tag"];
    competitionEntity.isFavorite = false;
    NSError *error = nil;
    if(![context save:&error]){
        NSLog(@"Error on insert -->%@", error.localizedDescription);
    }
    return competitionEntity;
}

+(void) markOrUnmarkCompetitionAsFavorite:(long)competitionId isFavorite:(BOOL)favorite {
    NSManagedObjectContext *context = [self getContext];
    CompetitionEntity *competition = [self queryCompetitionsByIdServer:competitionId];
    if (competition!=nil) {
        competition.isFavorite = favorite;
        NSError *error = nil;
        if(![context save:&error]){
            NSLog(@"Error on insertOrUpdateCourtEntity -->%@", error.localizedDescription);
        }
    }
}

+(NSArray *) queryCompetitionsFavorites {
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:COMPETITION_ENTITY inManagedObjectContext:context];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite == YES"];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *competitions = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"queryCompetitionsFavorites error -->%@", error.localizedDescription);
    }
    return competitions;
}

#pragma mark - favorite teams
+(NSArray *) queryAllTeamsFavorites {
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:FAVORITE_TEAM_ENTITY inManagedObjectContext:context];
    [request setEntity:description];
    NSError *error;
    NSArray *teams = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"queryAllTeamsFavorites error -->%@", error.localizedDescription);
    }
    return teams;
}

+(NSArray *) queryTeamsFavorites:(long)idCompetitionServer {
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:FAVORITE_TEAM_ENTITY inManagedObjectContext:context];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCompetitionServer == %ld", idCompetitionServer];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *teams = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"queryClassification error -->%@", error.localizedDescription);
    }
    return teams;
}

+(void) deleteTeamsFavorites:(long)idCompetitionServer {
    NSManagedObjectContext *context = [self getContext];
    NSError *error;
    NSArray *fetchedObjects = [UtilsDataBase queryTeamsFavorites:idCompetitionServer];
    for (NSManagedObject *object in fetchedObjects) {
        [context deleteObject:object];
    }
    error = nil;
    [context save:&error];
    if (error) {
        NSLog(@"deleteTeam error -->%@", error.localizedDescription);
    }
}

+(FavoriteTeamEntity*) queryTeamFavorite:(NSString *) teamName withCompetition:(long)idCompetitionServer {
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:FAVORITE_TEAM_ENTITY inManagedObjectContext:context];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCompetitionServer == %ld AND teamName == %@", idCompetitionServer, teamName];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *teams = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"queryClassification error -->%@", error.localizedDescription);
    }
    return teams.count==1 ? [teams objectAtIndex:0] : nil;
}

+(BOOL) isTeamFavorite:(NSString *) teamName withCompetition:(long) idCompetitionServer {
    return [self queryTeamFavorite:teamName withCompetition:idCompetitionServer]!=nil;
}

+(void) markOrUnmarkTeamAsFavorite:(NSString*)teamName withCompetition:(long)idCompetitionServer isFavorite:(BOOL)favorite {
    NSManagedObjectContext *context = [self getContext];
    if (favorite) {
        /** insert into teams table */
        FavoriteTeamEntity *favorite =  [NSEntityDescription
                                                 insertNewObjectForEntityForName:FAVORITE_TEAM_ENTITY
                                                 inManagedObjectContext:context];
        favorite.teamName = teamName;
        favorite.idCompetitionServer = idCompetitionServer;
        NSError *error = nil;
        if(![context save:&error]){
            NSLog(@"Error on insert -->%@", error.localizedDescription);
        }
    } else {
        /** remove from teams table */
        FavoriteTeamEntity *favoriteTeam = [self queryTeamFavorite:teamName withCompetition:idCompetitionServer];
        [context deleteObject:favoriteTeam];
        NSError *error;
        [context save:&error];
        if(error){
            NSLog(@"markOrUnmarkTeamAsFavorite error -->%@", error.localizedDescription);
        }
    }
}


#pragma mark - private
+(NSManagedObjectContext *) getContext {
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    return app.persistentContainer.viewContext;
}
@end
