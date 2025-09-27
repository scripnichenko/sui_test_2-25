module challenge::marketplace;

use challenge::hero::Hero;
use sui::coin::{Self, Coin};
use sui::event;
use sui::sui::SUI;

// ========= ERRORS =========

const EInvalidPayment: u64 = 1;

// ========= STRUCTS =========

public struct ListHero has key, store {
    id: UID,
    nft: Hero,
    price: u64,
    seller: address,
}

// ========= CAPABILITIES =========

public struct AdminCap has key, store {
    id: UID,
}

// ========= EVENTS =========

public struct HeroListed has copy, drop {
    list_hero_id: ID,
    price: u64,
    seller: address,
    timestamp: u64,
}

public struct HeroBought has copy, drop {
    list_hero_id: ID,
    price: u64,
    buyer: address,
    seller: address,
    timestamp: u64,
}

// ========= FUNCTIONS =========

fun init(ctx: &mut TxContext) {
    // TODO: Initialize the module by creating AdminCap
    // Hints:
    // - Create AdminCap id with object::new(ctx)
    // - Transfer it to the module publisher (ctx.sender()) using transfer::public_transfer() function
    // - This runs once when the module is published
}

public fun list_hero(nft: Hero, price: u64, ctx: &mut TxContext) {
    // TODO: Create a ListHero struct for marketplace
    // Hints:
    // - Use object::new(ctx) for unique ID
    // - Set nft, price, and seller (ctx.sender()) fields
    // - Emit HeroListed event with listing details (Don't forget to use object::id(&list_hero) )
    // - Use transfer::share_object() to make it publicly tradeable
}

#[allow(lint(self_transfer))]
public fun buy_hero(list_hero: ListHero, coin: Coin<SUI>, ctx: &mut TxContext) {
    // TODO: Implement hero purchase logic
    // Hints:
    //
    // Example:
    // let ListHero { id, nft, price, seller } = list_hero;
    //
    // - Destructure list_hero to get id, nft, price, and seller
    // - Use assert! to verify coin value equals listing price (coin::value(&coin) == price) else abort with `EInvalidPayment`
    // - Transfer coin to seller (use transfer::public_transfer() function)
    // - Transfer hero NFT to buyer (ctx.sender())
    // - Emit HeroBought event with transaction details (Don't forget to use object::uid_to_inner(&id) )
    // - Delete the listing ID (object::delete(id))
}

// ========= ADMIN FUNCTIONS =========

public fun delist(_: &AdminCap, list_hero: ListHero) {
    // TODO: Implement admin delist functionality
    // Hints:
    // - Destructure list_hero (ignore price with "price: _")
    // - Transfer NFT back to original seller
    // - Delete the listing ID (object::delete(id))
    // - The AdminCap parameter ensures only admin can call this
}

public fun change_the_price(_: &AdminCap, list_hero: &mut ListHero, new_price: u64) {
    // TODO: Update the listing price
    // Hints:
    // - Access the price field of list_hero and update it
    // - Use mutable reference (&mut) to modify the object
    // - The AdminCap parameter ensures only admin can call this
}

// ========= GETTER FUNCTIONS =========

#[test_only]
public fun listing_price(list_hero: &ListHero): u64 {
    list_hero.price
}

// ========= TEST ONLY FUNCTIONS =========

#[test_only]
public fun test_init(ctx: &mut TxContext) {
    let admin_cap = AdminCap {
        id: object::new(ctx),
    };
    transfer::transfer(admin_cap, ctx.sender());
}

