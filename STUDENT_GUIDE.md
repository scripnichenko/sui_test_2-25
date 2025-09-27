# 🎯 Student Implementation Guide

Below are the TODOs and hints you need to complete.

## 📋 What You Need to Complete

### Move Smart Contract Functions

#### 1. **create_hero** (`move/sources/hero.move`)

```move
public fun create_hero(name: String, image_url: String, power: u64, ctx: &mut TxContext) {
    // TODO: Create a new Hero struct with the given parameters
    // Hints:
    // - Use object::new(ctx) to create a unique ID
    // - Set name, image_url, and power fields
    // - Transfer the hero to the transaction sender
    //
    // Also create HeroMetadata and freeze it for tracking
    // - Use ctx.epoch_timestamp_ms() for timestamp
    // - Use transfer::freeze_object() to make metadata immutable
}
```

#### 3. **create_arena** (`move/sources/arena.move`)

```move
public fun create_arena(hero: Hero, ctx: &mut TxContext) {
    // TODO: Create a Arena struct
    // Hints:
    // - Use object::new(ctx) for unique ID
    // - Set warrior field to the hero parameter
    // - Set owner to ctx.sender()
    // - Emit ArenaCreated event with arena ID and timestamp (Don't forget to use ctx.epoch_timestamp_ms(), object::id(&arena))
    // - Use transfer::share_object() to make it publicly accessible
}
```

#### 4. **battle** (`move/sources/arena.move`)

```move
public fun battle(hero: Hero, arena: Arena, ctx: &mut TxContext) {
    // TODO: Implement battle logic
    // Hints:
    // - Destructure arena to get id, warrior, and owner
    // - Compare hero.hero_power() with warrior.hero_power()
    // - If hero wins: both heroes go to ctx.sender()
    // - If warrior wins: both heroes go to battle place owner
    // - Emit BattlePlaceCompleted event with winner/loser IDs (Don't forget to use object::id(&warrior) or object::id(&hero)). 
    //    - Note:  You have to emit this inside of the if else statements
    // - Don't forget to delete the battle place ID at the end
}
```

#### 2. **init** (`move/sources/marketplace.move`)

```move
fun init(ctx: &mut TxContext) {
    // TODO: Initialize the module by creating AdminCap
    // Hints:
    // - Create AdminCap id with object::new(ctx)
    // - Transfer it to the module publisher (ctx.sender()) using transfer::public_transfer() function
    // - This runs once when the module is published
}
```

#### 5. **list_hero** (`move/sources/marketplace.move`)

```move
public fun list_hero(nft: Hero, price: u64, ctx: &mut TxContext) {
    // TODO: Create a ListHero struct for marketplace
    // Hints:
    // - Use object::new(ctx) for unique ID
    // - Set nft, price, and seller (ctx.sender()) fields
    // - Emit HeroListed event with listing details (Don't forget to use object::id(&list_hero) )
    // - Use transfer::share_object() to make it publicly tradeable
}
```

#### 6. **buy_hero** (`move/sources/marketplace.move`)

```move
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
```

#### 7. **delist** (Admin Only) (`move/sources/marketplace.move`)

```move
public fun delist(_: &AdminCap, list_hero: ListHero) {
    // TODO: Implement admin delist functionality
    // Hints:
    // - Destructure list_hero (ignore price with "price: _")
    // - Transfer NFT back to original seller
    // - Delete the listing ID
    // - The AdminCap parameter ensures only admin can call this
}
```

#### 8. **change_the_price** (Admin Only) (`move/sources/marketplace.move`)

```move
public fun change_the_price(_: &AdminCap, list_hero: &mut ListHero, new_price: u64) {
    // TODO: Update the listing price
    // Hints:
    // - Access the price field of list_hero and update it
    // - Use mutable reference (&mut) to modify the object
    // - The AdminCap parameter ensures only admin can call this
}
```

# ⚠️ Warning! All tests needs to pass!

### After completing build and test your files. 

**Building & Testing the Move Contracts**

   ```bash
   cd move
   sui move build
   sui move test
   ```

### Frontend Utility Scripts

#### 1. **Create Hero** (`ui/src/utility/heroes/create_hero.ts`)

```typescript
export const createHero = (
  packageId: string,
  name: string,
  imageUrl: string,
  power: string
) => {
  const tx = new Transaction()

  // TODO: Add moveCall to create a hero
  // Function: `${packageId}::hero::create_hero`
  // Arguments: name (string), imageUrl (string), power (u64)
  // Hints:
  // - Use tx.pure.string() for string arguments
  // - Use tx.pure.u64() for number arguments (convert power to BigInt)
  // - The target module is 'arena', not 'hero'

  return tx
}
```

#### 2. **Buy Hero** (`ui/src/utility/marketplace/buy_hero.ts`)

```typescript
export const buyHero = (
  packageId: string,
  listHeroId: string,
  priceInSui: string
) => {
  const tx = new Transaction()

  // TODO: Convert SUI to MIST (1 SUI = 1,000,000,000 MIST)
  // const priceInMist = ?

  // TODO: Split coin for exact payment
  // Use tx.splitCoins(tx.gas, [priceInMist]) to create a payment coin
  // const [paymentCoin] = ?

  // TODO: Add moveCall to buy a hero
  // Function: `${packageId}::marketplace::buy_hero`
  // Arguments: listHeroId (object), paymentCoin (coin)
  // Hints:
  // - Use tx.object() for the ListHero object
  // - Use the paymentCoin from splitCoins for payment

  return tx
}
```

#### 3. **List Hero** (`ui/src/utility/marketplace/list_hero.ts`)

```typescript
export const listHero = (
  packageId: string,
  heroId: string,
  priceInSui: string
) => {
  const tx = new Transaction()

  // TODO: Convert SUI to MIST (1 SUI = 1,000,000,000 MIST)
  // const priceInMist = ?

  // TODO: Add moveCall to list a hero for sale
  // Function: `${packageId}::marketplace::list_hero`
  // Arguments: heroId (object), priceInMist (u64)
  // Hints:
  // - Use tx.object() for the hero object
  // - Use tx.pure.u64() for the price in MIST
  // - Remember: 1 SUI = 1_000_000_000 MIST

  return tx
}
```

#### 4. **Transfer Hero** (`ui/src/utility/helpers/transfer_hero.ts`)

```typescript
export const transferHero = (heroId: string, to: string) => {
  const tx = new Transaction()

  // TODO: Transfer hero to another address
  // Use tx.transferObjects() method
  // Arguments: heroId (object), to (address)
  // Hints:
  // - Use tx.object() for object IDs
  // - Use "to" for the address
  // - This is a simple object transfer, not a moveCall

  return tx
}
```

#### 5. **Create Arena** (`ui/src/utility/battle/create_arena.ts`)

```typescript
export const createArena = (packageId: string, heroId: string) => {
  const tx = new Transaction()

  // TODO: Add moveCall to create a battle place
  // Function: `${packageId}::arena::create_arena`
  // Arguments: heroId (object)
  // Hints:
  // - Use tx.object() for the hero object
  // - This creates a shared object that others can battle against

  return tx
}
```

#### 6. **Battle** (`ui/src/utility/battle/battle.ts`)

```typescript
export const battle = (packageId: string, heroId: string, arenaId: string) => {
  const tx = new Transaction()

  // TODO: Add moveCall to start a battle
  // Function: `${packageId}::arena::battle`
  // Arguments: heroId (object), arenaId (object)
  // Hints:
  // - Use tx.object() for both hero and battle place objects
  // - The battle winner is determined by hero power comparison
  // - Winner takes both heroes

  return tx
}
```

#### 7. **Delist (Admin)** (`ui/src/utility/admin/delist.ts`)

```typescript
export const delist = (
  packageId: string,
  listHeroId: string,
  adminCapId: string
) => {
  const tx = new Transaction()

  // TODO: Add moveCall to delist a hero (Admin only)
  // Function: `${packageId}::marketplace::delist`
  // Arguments: adminCapId (object), listHeroId (object)
  // Hints:
  // - Use tx.object() for both objects
  // - This requires admin capability verification
  // - Returns the hero to the original seller

  return tx
}
```

#### 8. **Change Price (Admin)** (`ui/src/utility/admin/change_price.ts`)

```typescript
export const changePrice = (
  packageId: string,
  listHeroId: string,
  newPriceInSui: string,
  adminCapId: string
) => {
  const tx = new Transaction()

  // TODO: Convert SUI to MIST (1 SUI = 1,000,000,000 MIST)
  // const newPriceInMist = ?

  // TODO: Add moveCall to change hero price (Admin only)
  // Function: `${packageId}::marketplace::change_the_price`
  // Arguments: adminCapId (object), listHeroId (object), newPriceInMist (u64)
  // Hints:
  // - Use tx.object() for objects
  // - Use tx.pure.u64() for the new price
  // - Convert price from SUI to MIST before sending

  return tx
}
```

#### 9. **Transfer Admin Cap** (`ui/src/utility/helpers/transfer_admin_cap.ts`)

```typescript
export const transferAdminCap = (adminCapId: string, to: string) => {
  const tx = new Transaction()

  // TODO: Transfer admin capability to another address
  // Use tx.transferObjects() method
  // Arguments: [objects array], recipient address
  // Hints:
  // - Use tx.object() to reference the admin cap
  // - This is a simple object transfer, not a moveCall
  // - The recipient becomes the new admin

  return tx
}
```

## 🚀 Development Environment

1. **Building the Move Contracts**

   ```bash
   cd move
   sui move build
   ```

2. **Deploying the Contracts**

   ```bash
   sui client publish
   ```

3. **Configure the User Interface**

   ```typescript
   // Set this value to the Package ID in the transaction summary of step 2
   // File `ui/src/networkConfig.ts`
   const PACKAGE_ID = ''
   ```

4. **Installing User Interface Dependencies**

   ```bash
   cd ui
   npm install
   ```

5. **Run the User Interface**

   ```bash
   npm run dev
   ```
