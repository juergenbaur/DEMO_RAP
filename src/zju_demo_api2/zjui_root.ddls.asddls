@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Basic Interface View forRoot'
define view entity ZJUI_Root
  as select from ZJU_UUID_ROOT as Root
{
  key HEADER_UUID as HeaderUUID,
  ID as ID,
  @Semantics.user.createdBy: true
  CREATED_BY as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  CREATED_AT as CreatedAt,
  @Semantics.user.lastChangedBy: true
  LAST_CHANGED_BY as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt
  
}
