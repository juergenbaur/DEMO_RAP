CLASS LHC_ROOT DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Root
        RESULT result,
      CALCULATEID FOR DETERMINE ON SAVE
        IMPORTING
          KEYS FOR  Root~CalculateID .
ENDCLASS.

CLASS LHC_ROOT IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD CALCULATEID.
  READ ENTITIES OF ZJUR_RootTP IN LOCAL MODE
    ENTITY Root
      ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(entities).
  DELETE entities WHERE ID IS NOT INITIAL.
  Check entities is not initial.
  "Dummy logic to determine object_id
  SELECT MAX( ID ) FROM ZJU_UUID_ROOT INTO @DATA(max_object_id).
  "Add support for draft if used in modify
  "SELECT SINGLE FROM FROM  FIELDS MAX( ID ) INTO @DATA(max_orderid_draft). "draft table
  "if max_orderid_draft > max_object_id
  " max_object_id = max_orderid_draft.
  "ENDIF.
  MODIFY ENTITIES OF ZJUR_RootTP IN LOCAL MODE
    ENTITY Root
      UPDATE FIELDS ( ID )
        WITH VALUE #( FOR entity IN entities INDEX INTO i (
        %tky          = entity-%tky
        ID     = max_object_id + i
  ) ).
  ENDMETHOD.
ENDCLASS.
