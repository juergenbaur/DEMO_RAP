@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forRoot'
define root view entity ZJUR_RootTP
  as select from ZJUI_Root as Root
  composition [0..*] of ZJUR_ChildTP as _Child
{
  key HeaderUUID,
  ID,
  @Semantics.user.createdBy: true
  CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  CreatedAt,
  @Semantics.user.lastChangedBy: true
  LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  LastChangedAt,
  _Child
  
}
