@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Basic Interface View forChild'
define view entity ZJUI_Child
  as select from ZJU_UUID_CHILD as Child
{
  key ITEM_UUID as ItemUUID,
  PARENT_UUID as ParentUUID,
  SPRAS as Language,
  ID as ID,
  TEXT as Text,
  CREATED_BY as CreatedBy,
  CREATED_AT as CreatedAt,
  LAST_CHANGED_BY as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt
  
}
