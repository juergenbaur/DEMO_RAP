@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View forRoot'
define root view entity ZJUI_RootTP
  provider contract TRANSACTIONAL_INTERFACE
  as projection on ZJUR_RootTP as Root
{
  key HeaderUUID,
  ID,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  _Child : redirected to composition child ZJUI_ChildTP
  
}
