@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forChild'
@ObjectModel.semanticKey: [ 'Language' ]
@Search.searchable: true
define view entity ZJUC_ChildTP
  as projection on ZJUR_ChildTP as Child
{
  key ItemUUID,
  ParentUUID,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  Language,
  ID,
  Text,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  _Root : redirected to parent ZJUC_RootTP
  
}
