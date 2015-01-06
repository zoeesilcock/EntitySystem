//
//  EntityManager.m
//  EntitySystem
//
//  Created by Zoee Silcock on 04/09/14.
//

#import "EntityManager.h"

@implementation EntityManager {
    NSMutableArray *_entities;
    NSMutableDictionary *_componentsByClass;
    uint32_t _lowestUnassignedEid;
}

- (id)init {
    if ((self = [super init])) {        
        _entities = [NSMutableArray array];
        _componentsByClass = [NSMutableDictionary dictionary];
        _lowestUnassignedEid = 1;
    }
    return self;
}

- (uint32_t)generateNewEid {
    if (_lowestUnassignedEid < UINT32_MAX) {
        return _lowestUnassignedEid++;
    } else {
        for (uint32_t i = 1; i < UINT32_MAX; ++i) {
            if (![_entities containsObject:@(i)]) {
                return i;
            }
        }
        NSLog(@"ERROR: No available EIDs!");
        return 0;
    }
}

- (Entity *)createEntity {
    uint32_t eid = [self generateNewEid];
    [_entities addObject:@(eid)];
    return [[Entity alloc] initWithEid:eid entityManager:self];
}

- (Entity *)addEntity:(Entity*)entity {
    uint32_t eid = [self generateNewEid];
    [_entities addObject:@(eid)];
    entity.eid = eid;
    entity.entityManager = self;
    return entity;
}

- (void)addComponent:(Component *)component toEntity:(Entity *)entity {
    NSMutableDictionary *components = _componentsByClass[NSStringFromClass([component class])];
    if (!components) {
        components = [NSMutableDictionary dictionary];
        _componentsByClass[NSStringFromClass([component class])] = components;
    }    
    components[@(entity.eid)] = component;
}

- (Component *)getComponentOfClass:(Class)class forEntity:(Entity *)entity {
    return _componentsByClass[NSStringFromClass(class)][@(entity.eid)];
}

- (void)removeEntity:(Entity *)entity {
    for (NSMutableDictionary *components in _componentsByClass.allValues) {
        if (components[@(entity.eid)]) {
            [components removeObjectForKey:@(entity.eid)];
        }
    }
    [_entities removeObject:@(entity.eid)];
}

- (NSArray *)getAllEntitiesPosessingComponentOfClass:(Class)class {
    NSMutableDictionary *components = _componentsByClass[NSStringFromClass(class)];
    if (components) {
        NSMutableArray *retval = [NSMutableArray arrayWithCapacity:components.allKeys.count];
        for (NSNumber *eid in components.allKeys) {
            [retval addObject:[[Entity alloc] initWithEid:eid.integerValue entityManager:self]];
        }
        return retval;
    } else {
        return [NSArray array];
    }
}

- (NSArray *)getAllEntitiesPosessingTag:(NSString*)tag {
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:_entities.count];

    for (Entity *entity in [self getAllEntitiesPosessingComponentOfClass:[TagsComponent class]]) {
        TagsComponent *tagsComponent = entity.tags;

        if ([[tagsComponent tags] indexOfObject:tag] != NSNotFound) {
            [retval addObject:entity];
        }
    }
    return retval;
}

- (Entity *)getEntityById:(uint32_t)entityId {
    for (NSNumber *eid in _entities) {
        if (eid.integerValue == entityId) {
            return [[Entity alloc] initWithEid:eid.integerValue entityManager:self];
        }
    }

    return NULL;
}

@end
