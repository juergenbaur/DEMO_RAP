@EndUserText.label: 'Root API'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_RootApi
  as select from ZJU_ROOT_CUST
  association to parent ZI_RootApi_S as _RootApiAll on $projection.SingletonID = _RootApiAll.SingletonID
  composition [0..*] of ZI_RootApiText as _RootApiText
{
  key ID as Id,
  @Semantics.user.createdBy: true
  CREATED_BY as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  CREATED_AT as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  LAST_CHANGED_BY as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  1 as SingletonID,
  _RootApiAll,
  _RootApiText
  
}
