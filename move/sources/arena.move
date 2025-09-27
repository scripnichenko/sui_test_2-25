module challenge::arena;

use challenge::hero::Hero;
use sui::event;
use sui::object;
use sui::transfer;
use sui::tx_context;

// ========= STRUCTS =========

public struct Arena has key, store {
    id: UID,
    warrior: Hero,
    owner: address,
}

// ========= EVENTS =========

public struct ArenaCreated has copy, drop {
    arena_id: ID,
    timestamp: u64,
}

public struct ArenaCompleted has copy, drop {
    winner_hero_id: ID,
    loser_hero_id: ID,
    timestamp: u64,
}

// ========= FUNCTIONS =========

public fun create_arena(hero: Hero, ctx: &mut TxContext) {
    // Create a new Arena struct with the given parameters
    let arena = Arena {
        id: object::new(ctx),
        warrior: hero,
        owner: tx_context::sender(ctx),
    };
    
    // Emit ArenaCreated event with arena ID and timestamp
    event::emit(ArenaCreated {
        arena_id: object::id(&arena),
        timestamp: tx_context::epoch_timestamp_ms(ctx),
    });
    
    // Use transfer::share_object() to make it publicly accessible
    transfer::share_object(arena);
}

#[allow(lint(self_transfer))]
public fun battle(hero: Hero, arena: Arena, ctx: &mut TxContext) {
    // Destructure arena to get id, warrior, and owner
    let Arena { id, warrior, owner } = arena;
    
    // Get hero and warrior IDs before moving them
    let hero_id = object::id(&hero);
    let warrior_id = object::id(&warrior);
    
    // Compare hero power with warrior power
    let hero_power = challenge::hero::hero_power(&hero);
    let warrior_power = challenge::hero::hero_power(&warrior);
    
    if (hero_power > warrior_power) {
        // Hero wins: both heroes go to ctx.sender()
        transfer::public_transfer(hero, tx_context::sender(ctx));
        transfer::public_transfer(warrior, tx_context::sender(ctx));
        
        // Emit ArenaCompleted event with winner/loser IDs
        event::emit(ArenaCompleted {
            winner_hero_id: hero_id,
            loser_hero_id: warrior_id,
            timestamp: tx_context::epoch_timestamp_ms(ctx),
        });
    } else {
        // Warrior wins: both heroes go to arena owner
        transfer::public_transfer(hero, owner);
        transfer::public_transfer(warrior, owner);
        
        // Emit ArenaCompleted event with winner/loser IDs
        event::emit(ArenaCompleted {
            winner_hero_id: warrior_id,
            loser_hero_id: hero_id,
            timestamp: tx_context::epoch_timestamp_ms(ctx),
        });
    };
    
    // Delete the arena object
    object::delete(id);
}

