const hre = require("hardhat");

async function main() {
  const eventName = "My Web3 Concert";
  const eventSymbol = "MWC";

  const ticketPriceInWei = hre.ethers.parseEther("0.01");
  const maxTickets = 1000;

  console.log("Deploying EventTicket contract with details:");
  console.log(`  Name: ${eventName}`);
  console.log(`  Symbol: ${eventSymbol}`);
  console.log(`  Price: 0.01 ETH (${ticketPriceInWei} Wei)`);
  console.log(`  Max Supply: ${maxTickets} tickets`);
  console.log("---------------------------------");

  const EventTicket = await hre.ethers.getContractFactory("EventTicket");
  
  const eventTicket = await EventTicket.deploy(
    eventName,
    eventSymbol,
    ticketPriceInWei,
    maxTickets
  );

  await eventTicket.waitForDeployment();

  const contractAddress = await eventTicket.getAddress();
  console.log(`Contract deployed successfully to: ${contractAddress}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});