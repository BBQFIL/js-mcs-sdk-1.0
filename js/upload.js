require('dotenv').config('')
const fs = require('fs').promises
const { mcsClient } = require('mcs-client')
const client = new mcsClient({
  privateKey: process.env.PRIVATE_KEY,
  rpcUrl: process.env.RPC_URL,
})

async function main() {
  const fileArray = [
    { fileName: 'AAA01AAA', file: await fs.readFile('./file/AAA01AAA') },
    { fileName: 'AAA02AAA', file: await fs.readFile('./file/AAA02AAA') },
    { fileName: 'AAA03AAA', file: await fs.readFile('./file/AAA03AAA') },
    { fileName: 'AAA04AAA', file: await fs.readFile('./file/AAA04AAA') },
  ]

//optional, showing default options
  const options = {
    delay: 1, // delay between upload API calls for each file. May need to be raised for larger files
    duration: 525, // the number of days to store the file on the Filecoin network.
    fileType: 0, // set to 1 for nft metadata files. type 1 files will not show on the UI.
  }

  const uploadResponses = await client.upload(fileArray, options)
  console.log(uploadResponses)
}

main()

