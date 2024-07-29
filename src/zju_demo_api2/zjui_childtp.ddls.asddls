@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View forChild'
define view entity ZJUI_ChildTP
  as projection on ZJUR_ChildTP as Child
{
  key ItemUUID,
  ParentUUID,
  Language,
  ID,
  Text,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  _Root : redirected to parent ZJUI_RootTP
  
}
