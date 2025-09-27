module challenge::arena;

use challenge::hero::Hero;
use sui::event;

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
    // TODO: Create a Arena struct
    // Hints:
    // - Use object::new(ctx) for unique ID
    // - Set warrior field to the hero parameter
    // - Set owner to ctx.sender()
    // - Emit ArenaCreated event with arena ID and timestamp (Don't forget to use ctx.epoch_timestamp_ms(), object::id(&arena))
    // - Use transfer::share_object() to make it publicly accessible
}

#[allow(lint(self_transfer))]
public fun battle(hero: Hero, arena: Arena, ctx: &mut TxContext) {
    // TODO: Implement battle logic
    // Hints:
    // - Destructure arena to get id, warrior, and owner
    // - Compare hero.hero_power() with warrior.hero_power()
    // - If hero wins: both heroes go to ctx.sender()
    // - If warrior wins: both heroes go to battle place owner
    // - Emit BattlePlaceCompleted event with winner/loser IDs (Don't forget to use object::id(&warrior) or object::id(&hero) ). 
    //    - Note:  You have to emit this inside of the if else statements
    // - Don't forget to delete the battle place ID at the end
}

