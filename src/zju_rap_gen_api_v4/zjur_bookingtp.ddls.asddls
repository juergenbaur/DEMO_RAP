@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forBooking'
define view entity ZJUR_BookingTP
  as select from ZJU_BOOKING_UUID as Booking
  association to parent ZJUR_Travel01TP as _Travel on $projection.ParentUUID = _Travel.TravelID
{
  key BOOKING_ID as BookingID,
  PARENT_UUID as ParentUUID,
  BOOKING_DATE as BookingDate,
  CUSTOMER_ID as CustomerID,
  CARRIER_ID as CarrierID,
  CONNECTION_ID as ConnectionID,
  FLIGHT_DATE as FlightDate,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  FLIGHT_PRICE as FlightPrice,
  CURRENCY_CODE as CurrencyCode,
  BOOKING_STATUS as BookingStatus,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  _Travel
  
}
