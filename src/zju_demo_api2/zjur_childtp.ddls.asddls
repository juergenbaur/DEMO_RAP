@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forChild'
define view entity ZJUR_ChildTP
  as select from ZJUI_Child as Child
  association to parent ZJUR_RootTP as _Root on $projection.ParentUUID = _Root.HeaderUUID
{
  key ItemUUID,
  ParentUUID,
  Language,
  ID,
  Text,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LastChangedAt,
  _Root
  
}
