import "@nomiclabs/hardhat-ethers";
import "hardhat-spdx-license-identifier";
export default {
  spdxLicenseIdentifier: {
    overwrite: true,
    runOnCompile: true,
  },
  solidity: {
    compilers :[
      {
        version: "0.8.0",
      }
    ]
  },
  networks: {
    hardhat: {
      gas: 10000000,
      accounts: {
        accountsBalance: "1000000000000000000000000",
      },
      allowUnlimitedContractSize: true,
      timeout: 1000000,
    },
    coverage: {
      url: "http://localhost:8555",
    },
  },
};
