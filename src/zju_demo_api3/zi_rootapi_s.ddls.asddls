@EndUserText.label: 'Root API Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_RootApi_S
  as select from I_Language
    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_ROOTAPI'
  composition [0..*] of ZI_RootApi as _RootApi
{
  key 1 as SingletonID,
  _RootApi,
  I_CstmBizConfignLastChgd.LastChangedDateTime as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
