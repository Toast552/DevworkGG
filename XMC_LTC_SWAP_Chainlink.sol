XMC_LTC_SWAP_Chainlink.sol

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract XMCToLTCSwap {

  AggregatorV3Interface internal priceFeed;
  
  IERC20 public wXMC; 
  IERC20 public wLTC;

  constructor(address _wXMC, address _wLTC, address _priceFeed) public {
    wXMC = IERC20(_wXMC);
    wLTC = IERC20(_wLTC);
    priceFeed = AggregatorV3Interface(_priceFeed); 
  }

  function swap(uint256 wXMCamount) public {
    require(wXMC.transferFrom(msg.sender, address(this), wXMCamount));
    
    uint256 wLTCAmount = calculateSwapAmount(wXMCamount);
    
    require(wLTC.transfer(msg.sender, wLTCAmount));
  }

  function calculateSwapAmount(uint256 wXMCamount) private view returns (uint256) {
    // Get latest XMC/USD price
    (uint80 roundID, int price, , , ) = priceFeed.latestRoundData();
    uint256 XMCPrice = uint256(price) * 10**10; // Price is scaled up
    
    // Calculate wLTC amount to swap to
    uint256 wLTCAmount = (wXMCamount * XMCPrice) / getLTCLatestPrice();
    
    return wLTCAmount;
  }
  
  function getLTCLatestPrice() private view returns (uint256) {
    // Add logic to get latest LTC/USD price
  }

}