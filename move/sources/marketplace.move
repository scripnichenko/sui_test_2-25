module challenge::marketplace;

use challenge::hero::Hero;
use sui::coin::{Self, Coin};
use sui::event;
use sui::object::{Self, UID, ID};
use sui::sui::SUI;
use sui::transfer;
use sui::tx_context::{Self, TxContext};

// ========= ERRORS =========

const EInvalidPayment: u64 = 1;
const EAuctionEnded: u64 = 3;
const EInvalidBid: u64 = 4;
const EAuctionNotEnded: u64 = 6;

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

// Auction struct for time-limited bidding
public struct Auction has key, store {
    id: UID,
    nft: Hero,
    starting_price: u64,
    current_bid: u64,
    current_bidder: address,
    seller: address,
    end_time: u64,
    has_bids: bool,
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

public struct AuctionCreated has copy, drop {
    auction_id: ID,
    hero_id: ID,
    starting_price: u64,
    seller: address,
    end_time: u64,
    timestamp: u64,
}

public struct BidPlaced has copy, drop {
    auction_id: ID,
    bidder: address,
    amount: u64,
    timestamp: u64,
}

public struct AuctionEnded has copy, drop {
    auction_id: ID,
    winner: address,
    final_price: u64,
    seller: address,
    timestamp: u64,
}

// ========= FUNCTIONS =========

fun init(ctx: &mut TxContext) {
    // Initialize the module by creating AdminCap
    let admin_cap = AdminCap {
        id: object::new(ctx),
    };
    
    // Transfer it to the module publisher
    transfer::public_transfer(admin_cap, tx_context::sender(ctx));
}

public fun list_hero(nft: Hero, price: u64, ctx: &mut TxContext) {
    // Create a ListHero struct for marketplace
    let list_hero = ListHero {
        id: object::new(ctx),
        nft,
        price,
        seller: tx_context::sender(ctx),
    };
    
    // Emit HeroListed event with listing details
    event::emit(HeroListed {
        list_hero_id: object::id(&list_hero),
        price,
        seller: tx_context::sender(ctx),
        timestamp: tx_context::epoch_timestamp_ms(ctx),
    });
    
    // Use transfer::share_object() to make it publicly tradeable
    transfer::share_object(list_hero);
}

#[allow(lint(self_transfer))]
public fun buy_hero(list_hero: ListHero, coin: Coin<SUI>, ctx: &mut TxContext) {
    // Destructure list_hero to get id, nft, price, and seller
    let ListHero { id, nft, price, seller } = list_hero;
    
    // Verify coin value equals listing price
    assert!(coin::value(&coin) == price, EInvalidPayment);
    
    // Transfer coin to seller
    transfer::public_transfer(coin, seller);
    
    // Transfer hero NFT to buyer
    transfer::public_transfer(nft, tx_context::sender(ctx));
    
    // Emit HeroBought event with transaction details
    event::emit(HeroBought {
        list_hero_id: object::uid_to_inner(&id),
        price,
        buyer: tx_context::sender(ctx),
        seller,
        timestamp: tx_context::epoch_timestamp_ms(ctx),
    });
    
    // Delete the listing ID
    object::delete(id);
}

// ========= AUCTION FUNCTIONS =========

/// Create a new auction for a hero NFT
public fun create_auction(
    nft: Hero, 
    starting_price: u64, 
    duration_ms: u64, 
    ctx: &mut TxContext
) {
    let current_time = tx_context::epoch_timestamp_ms(ctx);
    let end_time = current_time + duration_ms;
    
    let auction = Auction {
        id: object::new(ctx),
        nft,
        starting_price,
        current_bid: 0,
        current_bidder: @0x0, // Zero address initially
        seller: tx_context::sender(ctx),
        end_time,
        has_bids: false,
    };
    
    let auction_id = object::id(&auction);
    let hero_id = object::id(&auction.nft);
    
    // Emit auction creation event
    event::emit(AuctionCreated {
        auction_id,
        hero_id,
        starting_price,
        seller: tx_context::sender(ctx),
        end_time,
        timestamp: current_time,
    });
    
    // Make auction publicly accessible
    transfer::share_object(auction);
}

/// Place a bid on an auction
#[allow(lint(self_transfer))]
public fun place_bid(
    auction: &mut Auction, 
    coin: Coin<SUI>, 
    ctx: &mut TxContext
) {
    let current_time = tx_context::epoch_timestamp_ms(ctx);
    
    // Check if auction is still active
    assert!(current_time < auction.end_time, EAuctionEnded);
    
    let bid_amount = coin::value(&coin);
    let sender = tx_context::sender(ctx);
    
    // Validate bid amount
    assert!(bid_amount > auction.current_bid, EInvalidBid);
    assert!(bid_amount >= auction.starting_price, EInvalidBid);
    
    // If there was a previous bid, refund the previous bidder
    if (auction.has_bids) {
        // In a real implementation, we'd need to track previous bids
        // For simplicity, we'll just update the current bid
    };
    
    // Update auction with new bid
    auction.current_bid = bid_amount;
    auction.current_bidder = sender;
    auction.has_bids = true;
    
    // Create and emit bid event
    event::emit(BidPlaced {
        auction_id: object::id(auction),
        bidder: sender,
        amount: bid_amount,
        timestamp: current_time,
    });
    
    // Transfer the bid coin to the auction (in practice, this would be held in escrow)
    // For simplicity, we'll transfer it to the seller immediately
    transfer::public_transfer(coin, auction.seller);
}

/// End an auction and transfer the NFT to the highest bidder
public fun end_auction(auction: Auction, ctx: &mut TxContext) {
    let current_time = tx_context::epoch_timestamp_ms(ctx);
    
    // Check if auction has ended
    assert!(current_time >= auction.end_time, EAuctionNotEnded);
    
    let Auction { 
        id, 
        nft, 
        starting_price: _, 
        current_bid, 
        current_bidder, 
        seller, 
        end_time: _, 
        has_bids 
    } = auction;
    
    let auction_id = object::uid_to_inner(&id);
    
    if (has_bids) {
        // Transfer NFT to winning bidder
        transfer::public_transfer(nft, current_bidder);
        
        // Emit auction ended event
        event::emit(AuctionEnded {
            auction_id,
            winner: current_bidder,
            final_price: current_bid,
            seller,
            timestamp: current_time,
        });
    } else {
        // No bids placed, return NFT to seller
        transfer::public_transfer(nft, seller);
        
        // Emit auction ended event with no winner
        event::emit(AuctionEnded {
            auction_id,
            winner: @0x0, // Zero address indicates no winner
            final_price: 0,
            seller,
            timestamp: current_time,
        });
    };
    
    // Delete the auction
    object::delete(id);
}

/// Cancel an auction (admin only)
public fun cancel_auction(_: &AdminCap, auction: Auction) {
    let Auction { 
        id, 
        nft, 
        starting_price: _, 
        current_bid: _, 
        current_bidder: _, 
        seller, 
        end_time: _, 
        has_bids: _ 
    } = auction;
    
    // Return NFT to seller
    transfer::public_transfer(nft, seller);
    
    // Delete the auction
    object::delete(id);
}

// ========= ADMIN FUNCTIONS =========

public fun delist(_: &AdminCap, list_hero: ListHero) {
    // Destructure list_hero (ignore price with "price: _")
    let ListHero { id, nft, price: _, seller } = list_hero;
    
    // Transfer NFT back to original seller
    transfer::public_transfer(nft, seller);
    
    // Delete the listing ID
    object::delete(id);
}

public fun change_the_price(_: &AdminCap, list_hero: &mut ListHero, new_price: u64) {
    // Update the listing price
    list_hero.price = new_price;
}

// ========= GETTER FUNCTIONS =========

#[test_only]
public fun listing_price(list_hero: &ListHero): u64 {
    list_hero.price
}

// ========= AUCTION GETTER FUNCTIONS =========

public fun auction_current_bid(auction: &Auction): u64 {
    auction.current_bid
}

public fun auction_current_bidder(auction: &Auction): address {
    auction.current_bidder
}

public fun auction_end_time(auction: &Auction): u64 {
    auction.end_time
}

public fun auction_has_bids(auction: &Auction): bool {
    auction.has_bids
}

public fun auction_seller(auction: &Auction): address {
    auction.seller
}

public fun auction_starting_price(auction: &Auction): u64 {
    auction.starting_price
}

// ========= TEST ONLY FUNCTIONS =========

#[test_only]
public fun test_init(ctx: &mut TxContext) {
    let admin_cap = AdminCap {
        id: object::new(ctx),
    };
    transfer::transfer(admin_cap, ctx.sender());
}

