@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic Root View'
define root view entity zju_i_root_api as select from ZJU_ROOT_API
composition [0..*] of  ZJUI_I_CHILD_API as _Child
{
    key id as Id,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
     @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
        //local ETag field --> OData ETag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
    last_changed_at as LastChangedAt,
    _Child // Make association public
}
