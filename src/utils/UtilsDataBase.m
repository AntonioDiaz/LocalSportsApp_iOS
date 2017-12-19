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
+(void) insertMatch:(NSDictionary *) dictionaryMatch withEntity:(CompetitionEntity *) competition {
    NSManagedObjectContext *context = [self getContext];
    MatchEntity *matchEntity =  [NSEntityDescription
                                 insertNewObjectForEntityForName:MATCH_ENTITY
                                 inManagedObjectContext:context];
    NSDictionary* dictionaryTeamLocal = [dictionaryMatch objectForKey:@"teamLocalEntity"];
    NSDictionary* dictionaryTeamVisitor = [dictionaryMatch objectForKey:@"teamVisitorEntity"];
    NSDictionary* dictionarySportCenterCourt = [dictionaryMatch objectForKey:@"sportCenterCourt"];
    SportCourtEntity *courtEntity = [self insertOrUpdateCourtEntity:dictionarySportCenterCourt];
    matchEntity.lastUpdate = (int)[[dictionaryMatch objectForKey:@"lastUpdate"] integerValue];
    matchEntity.scoreLocal = (int)[[dictionaryMatch objectForKey:@"scoreLocal"] integerValue];
    matchEntity.scoreVisitor = (int)[[dictionaryMatch objectForKey:@"scoreVisitor"] integerValue];
    matchEntity.state = (int)[[dictionaryMatch objectForKey:@"state"] integerValue];
    matchEntity.teamLocal = [dictionaryTeamLocal objectForKey:@"name"];
    matchEntity.teamVisitor = [dictionaryTeamVisitor objectForKey:@"name"];
    matchEntity.week = (int)[[dictionaryMatch objectForKey:@"week"] integerValue];
    matchEntity.date = [[dictionaryMatch objectForKey:@"date"] doubleValue];
    matchEntity.idServer = [[dictionaryMatch objectForKey:@"id"] doubleValue];
    matchEntity.competition = competition;
    matchEntity.court = courtEntity;
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
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:COMPETITION_ENTITY inManagedObjectContext:context];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sport == %@", sportStr];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *arrayCompetitions = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"queryCompetitionsBySport error -->%@", error.localizedDescription);
    }
    return arrayCompetitions;
}

+(CompetitionEntity *) queryCompetitionsById:(long) competitionId {
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
    CompetitionEntity *competition = [self queryCompetitionsById:competitionId];
    if (competition!=nil) {
        competition.isFavorite = favorite;
        NSError *error = nil;
        if(![context save:&error]){
            NSLog(@"Error on insertOrUpdateCourtEntity -->%@", error.localizedDescription);
        }
    }
}

#pragma mark - teams
+(NSArray *) queryTeams:(CompetitionEntity *)competitionEntity {
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:TEAM_ENTITY inManagedObjectContext:context];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"competition == %@", competitionEntity];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *teams = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"queryClassification error -->%@", error.localizedDescription);
    }
    return teams;
}

+(void) deleteTeams:(CompetitionEntity *)competitionEntity {
    NSManagedObjectContext *context = [self getContext];
    NSError *error;
    NSArray *fetchedObjects = [UtilsDataBase queryTeams:competitionEntity];
    for (NSManagedObject *object in fetchedObjects) {
        [context deleteObject:object];
    }
    error = nil;
    [context save:&error];
    if (error) {
        NSLog(@"deleteTeam error -->%@", error.localizedDescription);
    }
}

+(TeamEntity*) findTeamFavorite:(NSString *) teamName withCompetition:(CompetitionEntity *) competitionEntity {
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:TEAM_ENTITY inManagedObjectContext:context];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"competition == %@ AND teamName == %@", competitionEntity, teamName];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *teams = [context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"queryClassification error -->%@", error.localizedDescription);
    }
    return teams.count==1?[teams objectAtIndex:0]:nil;
}

+(BOOL) isTeamFavorite:(NSString *) teamName withCompetition:(CompetitionEntity *) competitionEntity {
    return [self findTeamFavorite:teamName withCompetition:competitionEntity]!=nil;
}

+(void) markOrUnmarkTeamAsFavorite:(NSString*)teamName withCompetition:(CompetitionEntity*)competitionEntity isFavorite:(BOOL)favorite {
    NSManagedObjectContext *context = [self getContext];
    if (favorite) {
        /** insert into teams table */
        TeamEntity *teamEntity =  [NSEntityDescription
                                                 insertNewObjectForEntityForName:TEAM_ENTITY
                                                 inManagedObjectContext:context];
        teamEntity.teamName = teamName;
        teamEntity.competition = competitionEntity;
        NSError *error = nil;
        if(![context save:&error]){
            NSLog(@"Error on insert -->%@", error.localizedDescription);
        }
    } else {
        /** remove from teams table */
        TeamEntity *teamEntityToDelete = [self findTeamFavorite:teamName withCompetition:competitionEntity];
        [context deleteObject:teamEntityToDelete];
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
