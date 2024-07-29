CLASS zju_api_eml_projection_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zju_api_eml_projection_class IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*https://help.sap.com/docs/abap-cloud/abap-rap/modify?locale=en-US&version=s4_hana
*Declare internal table using derived type
    DATA create TYPE TABLE FOR CREATE zju_c_root_api.
    DATA create_child TYPE TABLE FOR CREATE zju_c_root_api\_child.
data gv_id type zju_id value '007'.

*Populate internal table for travel instance
    create = VALUE #( ( %cid                 = 'create_id'
                        Id                   = gv_id
 ) ).

    create_child = VALUE #( ( %cid_ref     = 'create_id'
                        %target = VALUE #( ( %cid         = 'create_child_1'
                                             Spras        = 'DE'
                                             Id           = gv_id
                                             Text         = |Text für { gv_id }|
                                              )
                                            ( %cid         = 'create_child_2'
                                             Spras        = 'EN'
                                             Id           = gv_id
                                             Text         = |Text for { gv_id }|
                                              ) )
     ) ).




*Create a travel instance and two associated booking instances
    MODIFY ENTITIES OF zju_c_root_api
        ENTITY Root
          CREATE FIELDS ( Id ) WITH create
          CREATE BY \_Child
          FIELDS ( Spras Id Text ) WITH create_child


    MAPPED DATA(mapped)
    REPORTED DATA(reported)
    FAILED DATA(failed).



    READ ENTITIES OF zju_c_root_api
    ENTITY Root
    ALL FIELDS WITH VALUE #( ( Id = gv_id ) )
    RESULT  DATA(read_mapped)
    REPORTED DATA(read_reported)
    FAILED DATA(read_failed).


*    MODIFY ENTITIES OF zju_i_root_api
*        ENTITY Root
*          CREATE FIELDS ( Id ) WITH create
*          CREATE BY \_Child
*          FIELDS ( Spras Id Text ) WITH
*
*          VALUE #( ( %cid_ref = 'create_id'
*
*                     %target = VALUE #( ( %cid         = 'create_child_1'
*                                          Spras        = 'DE'
*                                          Id           = '002'
*                                          Text         = 'Erste ID'
*                                           )
*
*                                        ( %cid         = 'create_child_2'
*                                          Spras        = 'EN'
*                                          Id           = '002'
*                                          Text         = 'First ID'
*                                          )
*                                         ) ) )
*
*    MAPPED DATA(mapped)
*    REPORTED DATA(reported)
*    FAILED DATA(failed).

*Persist transactional buffer
    COMMIT ENTITIES.
  ENDMETHOD.
ENDCLASS.
