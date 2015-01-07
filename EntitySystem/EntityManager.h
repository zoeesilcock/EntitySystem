//
//  EntityManager.h
//  EntitySystem
//
//  Created by Zoee Silcock on 04/09/14.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "Component.h"
#import "TagsComponent.h"

@interface EntityManager : NSObject

- (uint32_t)generateNewEid;
- (Entity *)createEntity;
- (void)addComponent:(Component *)component toEntity:(Entity *)entity;
- (Component *)getComponentOfClass:(Class)class forEntity:(Entity *)entity;
- (void)removeEntity:(Entity *)entity;
- (NSArray *)getAllEntitiesPosessingComponentOfClass:(Class)class;
- (NSArray *)getAllEntitiesPosessingTag:(NSString*)tag;
- (Entity *)getEntityById:(uint32_t)entityId;

@end
