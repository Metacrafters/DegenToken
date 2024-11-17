# DegenToken

The **DegenToken** contract is an ERC20-based token contract designed for Degen Gaming, a game studio looking to reward players with tokens on the **Avalanche** network. These tokens can be redeemed for items in an in-game store and transferred between players, enhancing the gaming experience with tradeable and redeemable rewards.

## Features

This contract provides the following functionalities:

**Minting Tokens:** The contract owner can mint new tokens for distribution to players.

**Token Transfer:** Players can transfer tokens to others, allowing for a peer-to-peer trading experience.

**In-Game Store:** Items can be added to an in-game store, where players can redeem tokens for rewards.

**Token Redemption:** Players can redeem tokens to claim items from the store, burning tokens in the process.

**Token Burning:** The contract includes a burnable token feature, allowing users to burn their tokens when redeeming items.

**Balance Checking:** Players can check their token balance at any time.

**Decimals Control:** The token has a single decimal place, allowing for in-game token precision.

## Contract Structure

mint: Allows the contract owner to mint tokens to specified addresses.

addStoreItem: Adds a new item to the in-game store. Only accessible to the owner.

redeemTokenForItem: Allows players to redeem tokens to purchase items from the store, transferring tokens to the contract.

removeItemFromStore: Internal function to remove items after redemption.

getStoreItem: Retrieves store item details.

transferTokens: Transfers tokens from one player to another.

checkBalance: Checks the token balance of a specific address.

decimals: Returns the token's decimals, set to 1.

## Error Handling
The contract includes custom error handling for better gas efficiency:

NotOwner: Reverts if the caller is not the contract owner.

ItemNotAvailable: Reverts if the item is not available in the store.

ItemAlreadyRedeemed: Reverts if the item has already been redeemed.

InsufficientBalance: Reverts if the player’s balance is lower than the item price.

ItemDoesNotExist: Reverts if the item ID doesn’t exist in the store.

## Events

TokenRedemption: Emitted when a player redeems tokens for an item.

StoreItemAdded: Emitted when a new item is added to the store.

ItemRemovedFromStore: Emitted when an item is removed after redemption.

## Usage

Deployment

Deploy the contract on the Avalanche network.

Set up the initial items in the in-game store via the addStoreItem function.

Minting Tokens

Only the contract owner can call mint to create new tokens and reward players.

## Development and Testing

To test this contract:

Use tools like Hardhat for deployment and interaction.

Implement tests to ensure each functionality (minting, transferring, redeeming, burning) works as expected.

## License

This project is licensed under the MIT License.