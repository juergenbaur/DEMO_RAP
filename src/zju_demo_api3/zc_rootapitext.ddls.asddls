@EndUserText.label: 'Maintain Root API Text'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_RootApiText
  as projection on ZI_RootApiText
{
  @ObjectModel.text.element: [ 'LanguageName' ]
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Language', 
      element: 'Language'
    }
  } ]
  key Spras,
  key Id,
  Text_000,
  CreatedBy,
  CreatedAt,
  @Consumption.hidden: true
  LastChangedBy,
  @Consumption.hidden: true
  LastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _LanguageText.LanguageName : localized,
  _RootApi : redirected to parent ZC_RootApi,
  _RootApiAll : redirected to ZC_RootApi_S
  
}
