require('dotenv').config('./.env')
const fs = require('fs').promises
const { mcsClient } = require('mcs-client')
const client = new mcsClient({
  privateKey: process.env.PRIVATE_KEY,
  rpcUrl: process.env.RPC_URL,
})

async function main() {
  PAYLOAD_CID = 'bafykbzaceasney6ikofcbeguu52cz6xbauojpylpaxlunr2txvulq72plvimc'
  const tx = await client.makePayment(PAYLOAD_CID, '0.002')
  console.log(tx.transactionHash)
}
main()
