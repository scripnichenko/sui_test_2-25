module challenge::hero;

use std::string::String;
use sui::object::{Self, UID, ID};
use sui::transfer;
use sui::tx_context::{Self, TxContext};

// ========= STRUCTS =========
public struct Hero has key, store {
    id: UID,
    name: String,
    image_url: String,
    power: u64,
}

public struct HeroMetadata has key, store {
    id: UID,
    timestamp: u64,
}

// ========= FUNCTIONS =========

#[allow(lint(self_transfer))]
public fun create_hero(name: String, image_url: String, power: u64, ctx: &mut TxContext) {
    // Create a new Hero struct with the given parameters
    let hero = Hero {
        id: object::new(ctx),
        name,
        image_url,
        power,
    };
    
    // Create HeroMetadata for tracking and freeze it to make it immutable
    let metadata = HeroMetadata {
        id: object::new(ctx),
        timestamp: tx_context::epoch_timestamp_ms(ctx),
    };
    
    // Freeze the metadata object to make it immutable
    transfer::freeze_object(metadata);
    
    // Transfer the hero to the transaction sender
    transfer::transfer(hero, tx_context::sender(ctx));
}

// ========= GETTER FUNCTIONS =========

public fun hero_power(hero: &Hero): u64 {
    hero.power
}

#[test_only]
public fun hero_name(hero: &Hero): String {
    hero.name
}

#[test_only]
public fun hero_image_url(hero: &Hero): String {
    hero.image_url
}

#[test_only]
public fun hero_id(hero: &Hero): ID {
    object::id(hero)
}

