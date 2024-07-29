@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forRoot'
@ObjectModel.semanticKey: [ 'ID' ]
@Search.searchable: true
define root view entity ZJUC_RootTP
  provider contract TRANSACTIONAL_QUERY
  as projection on ZJUR_RootTP as Root
{
  key HeaderUUID,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  ID,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  _Child : redirected to composition child ZJUC_ChildTP
  
}
