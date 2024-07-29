@EndUserText.label: 'Root API Text'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #TEXT
define view entity ZI_RootApiText
  as select from ZJU_CHILD_CUST
  association [1..1] to ZI_RootApi_S as _RootApiAll on $projection.SingletonID = _RootApiAll.SingletonID
  association to parent ZI_RootApi as _RootApi on $projection.Id = _RootApi.Id
  association [0..*] to I_LanguageText as _LanguageText on $projection.Spras = _LanguageText.LanguageCode
{
  @Semantics.language: true
  key SPRAS as Spras,
  key ID as Id,
  @Semantics.text: true
  TEXT as Text_000,
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
  _RootApi,
  _LanguageText
  
}
