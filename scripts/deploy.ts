import { ethers } from "hardhat";
import { DegenToken } from "../typechain-types";

async function main() {
  console.log("Deploying DegenToken...");

  // Deploy the contract
  const DegenToken = await ethers.getContractFactory("DegenToken");
  const degenToken = await DegenToken.deploy("DegenToken", "DGN");
  await degenToken.deployed();

  console.log("DegenToken deployed to:", degenToken.address);

  // Get signers
  const [owner, addr1] = await ethers.getSigners();

  // Add some store items
  console.log("\nAdding store items...");
  
  const items = [
    { name: "Golden Boot", price: 200 },
    { name: "Silver Boot", price: 150 },
    { name: "Bronze Boot", price: 100 }
  ];

  for (const item of items) {
    const tx = await degenToken.addStoreItem(item.name, item.price);
    await tx.wait();
    console.log(`Added ${item.name} for ${item.price} tokens`);
  }

  // Mint some tokens to addr1
  console.log("\nMinting tokens to", addr1.address);
  const mintAmount = 200;
  await degenToken.mint(addr1.address, mintAmount);
  console.log(`Minted ${mintAmount} tokens to ${addr1.address}`);

  // Check balance
  const balance = await degenToken.balanceOf(addr1.address);
  console.log(`Balance of ${addr1.address}: ${balance.toString()} tokens`);

  // Redeem an item
  console.log("\nRedeeming an item...");
  const itemId = 0; // Legendary Sword
  await degenToken.connect(addr1).redeemTokenForItem(itemId);
  
  // Check updated balance
  const newBalance = await degenToken.balanceOf(addr1.address);
  console.log(`New balance after redemption: ${newBalance.toString()} tokens`);

  // Get store item details
  console.log("\nStore items status:");
  for (let i = 0; i < items.length; i++) {
    const item = await degenToken.getStoreItem(i);
    console.log(`Item ${i}: ${item.name}`);
    console.log(`Price: ${item.price}`);
    console.log(`Exists: ${item.exists}`);
    console.log(`Redeemed: ${item.isRedeemed}\n`);
  }
}

// Execute the deployment and interaction script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });