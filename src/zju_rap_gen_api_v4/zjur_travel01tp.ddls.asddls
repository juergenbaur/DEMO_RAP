@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forTravel'
define root view entity ZJUR_Travel01TP
  as select from ZJU_TRAVEL_UUID as Travel
  composition [0..*] of ZJUR_BookingTP as _Booking
{
  key TRAVEL_ID as TravelID,
  AGENCY_ID as AgencyID,
  CUSTOMER_ID as CustomerID,
  BEGIN_DATE as BeginDate,
  END_DATE as EndDate,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  BOOKING_FEE as BookingFee,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  TOTAL_PRICE as TotalPrice,
  CURRENCY_CODE as CurrencyCode,
  DESCRIPTION as Description,
  OVERALL_STATUS as OverallStatus,
  @Semantics.user.createdBy: true
  CREATED_BY as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  CREATED_AT as CreatedAt,
  LAST_CHANGED_BY as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  _Booking
  
}
