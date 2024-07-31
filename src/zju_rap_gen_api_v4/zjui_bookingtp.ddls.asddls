@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View forBooking'
define view entity ZJUI_BookingTP
  as projection on ZJUR_BookingTP as Booking
{
  key BookingID,
  ParentUUID,
  BookingDate,
  CustomerID,
  CarrierID,
  ConnectionID,
  FlightDate,
  FlightPrice,
  CurrencyCode,
  BookingStatus,
  LastChangedAt,
  _Travel : redirected to parent ZJUI_Travel01TP
  
}
