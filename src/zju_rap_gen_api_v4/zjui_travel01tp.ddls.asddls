@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View forTravel'
define root view entity ZJUI_Travel01TP
  provider contract TRANSACTIONAL_INTERFACE
  as projection on ZJUR_Travel01TP as Travel
{
  key TravelID,
  AgencyID,
  CustomerID,
  BeginDate,
  EndDate,
  BookingFee,
  TotalPrice,
  CurrencyCode,
  Description,
  OverallStatus,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  _Booking : redirected to composition child ZJUI_BookingTP
  
}
