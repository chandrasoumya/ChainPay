const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("ChainPayModule", (m) => {
  const ChainPay = m.contract("ChainPay");

  return { ChainPay };
});
//  ChainPayModule#ChainPay - 0x2cD2D6011C8a682996D083DF2748B71d52140CdC
