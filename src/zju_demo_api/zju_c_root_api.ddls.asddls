@EndUserText.label: 'Projection Root View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZJU_C_ROOT_API provider contract transactional_query
as projection on zju_i_root_api

{
    key Id,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    /* Associations */
    _Child : redirected to composition child ZJUI_C_CHILD_API
}
