// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract donateCampaign{
struct CampaignDetail {
    uint256 campaignId;
    uint256  targetAmount;
    uint256  amountDonated;
    uint256  durationTimeInDays;
   address payable owner;
    bool isCompleted;}
  


struct Donor{   address donorId;
    uint256 amountDonated;
}

uint256 public campaignCount;
mapping(uint256 => CampaignDetail)public campaigns;
 mapping(uint256 => Donor[]) public donors;
mapping(uint256 =>mapping(address => uint256) )public donations;

event campaignCreated(uint256 campaignId,address Owner,uint256 targetAmount);
event donatedToCampaign (uint256 campaignId,address donor,uint256 amountDonated);
event amountWithdrawn (uint256 campaignId, uint256 amountWithdrawn);
event refundIssued(uint256 campaignId, address donor,uint256 amount);

function createCampaign (uint256 _targetAmount, uint256 campaignDuration) public{
require (_targetAmount >0, "the target should be more than 0" );
  
  campaignCount++;
  uint256 _campaignDuration = campaignDuration * 86400;
   uint256 durationTimeInDays = block.timestamp + (_campaignDuration * 86400);
  campaigns[campaignCount]=
  CampaignDetail({
    campaignId: campaignCount,
    owner:payable(msg.sender),
    targetAmount:_targetAmount,
    amountDonated: 0,
   durationTimeInDays: durationTimeInDays,
 
    isCompleted:false});
  
  emit campaignCreated(campaignCount,msg.sender,_targetAmount);
  }

  function donateToCampaign(uint256 _campaignId)public payable{
   CampaignDetail storage campaign = campaigns[_campaignId];
    require(!campaign.isCompleted,"campaign is already completed");
    require (msg.value>0,"amount donated must be greater than 0");
    campaign.amountDonated +=msg.value;
  donors[_campaignId].push(
    Donor({
      donorId:  (msg.sender), amountDonated: msg.value}));

  
    emit donatedToCampaign(_campaignId, msg.sender, msg.value);
  }

  function withdrawFunds(uint256 _campaignId)public{

   

      CampaignDetail storage campaign = campaigns[_campaignId];
    
    
     require(block.timestamp > campaign.durationTimeInDays, "Campaign is still active");
     require(campaign.owner==msg.sender,"only the campaign owner can withdraw");
    require (campaign.isCompleted==false,"the campaign is active");
     require(campaign.amountDonated > 0, "No funds to withdraw");
    uint256 amount = campaign.amountDonated;
        campaign.amountDonated = 0;
        campaign.isCompleted = true;

        (bool success, ) = campaign.owner.call{value: amount}("");
  require(success,"Withdraw failed.");
  
  
     emit amountWithdrawn(_campaignId,amount);
    

        }

  

  function refund(uint256 campaignId)public{
    CampaignDetail storage campaign = campaigns[campaignId];
    uint256 donorAmount = donations[campaignId][msg.sender];
     require(donorAmount > 0, "No donations to refund.");

     require(campaign.amountDonated < campaign.targetAmount, "Campaign target was met.");
            require(!campaign.isCompleted, "Campaign is already completed.");
  require(block.timestamp > campaign.durationTimeInDays, "Campaign is still active");
  
  donations[campaignId][msg.sender] = 0;
        (bool success, ) =payable(msg.sender).call{value:donorAmount}("");
        require (success, "Refund failed.");

        emit refundIssued(campaignId, msg.sender, donorAmount);
    }

  }