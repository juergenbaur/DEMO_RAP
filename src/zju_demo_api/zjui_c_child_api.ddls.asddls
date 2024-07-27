@EndUserText.label: 'Projection Child View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZJUI_C_CHILD_API as projection on ZJUI_I_CHILD_API
{
    key Spras,
    key Id,
    Text,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    /* Associations */
    _Root: redirected to parent ZJU_C_ROOT_API
}
