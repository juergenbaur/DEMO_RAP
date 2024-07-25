@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Child View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZJUI_I_CHILD_API as select from ZJU_CHILD_API as Child
association        to parent zju_i_root_api    as _Root        on  $projection.Id = _Root.Id
{
    key spras as Spras,
    key id as Id,
    text as Text,
        @Semantics.user.createdBy: true
    created_by as CreatedBy,
         @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
        @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
          @Semantics.systemDateTime.localInstanceLastChangedAt: true
    last_changed_at as LastChangedAt,
    _Root
}
