@EndUserText.label: 'Maintain Root API'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_RootApi
  as projection on ZI_RootApi
{
  key Id,
  CreatedBy,
  CreatedAt,
  @Consumption.hidden: true
  LastChangedBy,
  @Consumption.hidden: true
  LastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _RootApiAll : redirected to parent ZC_RootApi_S,
  _RootApiText : redirected to composition child ZC_RootApiText,
  _RootApiText.Text_000 : localized
  
}
