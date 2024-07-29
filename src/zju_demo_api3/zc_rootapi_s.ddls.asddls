@EndUserText.label: 'Maintain Root API Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_RootApi_S
  provider contract TRANSACTIONAL_QUERY
  as projection on ZI_RootApi_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _RootApi : redirected to composition child ZC_RootApi
  
}
