CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TDAT_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZROOTAPI'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'RootApi' table = 'ZJU_ROOT_CUST' )
                                         ( entity = 'RootApiText' table = 'ZJU_CHILD_CUST' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_ROOTAPI_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR RootApiAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION RootApiAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR RootApiAll
        RESULT result,
      EDIT FOR MODIFY
        IMPORTING
          KEYS FOR ACTION RootApiAll~edit.
ENDCLASS.

CLASS LHC_ZI_ROOTAPI_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF ZI_RootApi_S IN LOCAL MODE
    ENTITY RootApiAll
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%IS_DRAFT = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %TKY = all[ 1 ]-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_RootApi = edit_flag
               %ACTION-SelectCustomizingTransptReq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_RootApi_S IN LOCAL MODE
      ENTITY RootApiAll
        UPDATE FIELDS ( TransportRequestID HideTransport )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                          HideTransport      = abap_false ) ).

    READ ENTITIES OF ZI_RootApi_S IN LOCAL MODE
      ENTITY RootApiAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_ROOTAPI' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
  METHOD EDIT.
    CHECK lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ).
    DATA(transport_request) = lhc_rap_tdat_cts=>get( )->get_transport_request( ).
    IF transport_request IS NOT INITIAL.
      MODIFY ENTITY IN LOCAL MODE ZI_RootApi_S
        EXECUTE SelectCustomizingTransptReq FROM VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
                                                            SingletonID = 1
                                                            %PARAM-transportrequestid = transport_request ) ).
      reported-RootApiAll = VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
                                     SingletonID = 1
                                     %MSG = mbc_cp_api=>message( )->get_transport_selected( transport_request ) ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_ROOTAPI_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION,
      CLEANUP_FINALIZE REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_ROOTAPI_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    READ TABLE update-RootApiAll INDEX 1 INTO DATA(all).
    IF all-TransportRequestID IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-TransportRequestID
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) )->update_last_changed_date_time( view_entity_name   = 'ZI_ROOTAPI'
                                                                                                        maintenance_object = 'ZROOTAPI' ).
    ENDIF.
  ENDMETHOD.
  METHOD CLEANUP_FINALIZE ##NEEDED.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_ROOTAPITEXT DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR RootApiText~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR RootApiText
        RESULT result.
ENDCLASS.

CLASS LHC_ZI_ROOTAPITEXT IMPLEMENTATION.
  METHOD VALIDATEDATACONSISTENCY.
    READ ENTITIES OF ZI_RootApi_S IN LOCAL MODE
      ENTITY RootApiText
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(RootApiText).
    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( 'ZJU_CHILD_CUST' ).
    LOOP AT RootApiText ASSIGNING FIELD-SYMBOL(<RootApiText>).
    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_ROOTAPI DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR RootApi
        RESULT result,
      COPYROOTAPI FOR MODIFY
        IMPORTING
          KEYS FOR ACTION RootApi~CopyRootApi,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR RootApi
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR RootApi
        RESULT result,
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS_ROOTAPI FOR RootApi~ValidateTransportRequest
          KEYS_ROOTAPITEXT FOR RootApiText~ValidateTransportRequest.
ENDCLASS.

CLASS LHC_ZI_ROOTAPI IMPLEMENTATION.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
    result-%ASSOC-_RootApiText = edit_flag.
  ENDMETHOD.
  METHOD COPYROOTAPI.
    DATA new_RootApi TYPE TABLE FOR CREATE ZI_RootApi_S\_RootApi.
    DATA new_RootApiText TYPE TABLE FOR CREATE ZI_RootApi_S\\RootApi\_RootApiText.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-RootApi = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZI_RootApi_S IN LOCAL MODE
      ENTITY RootApi
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(ref_RootApi)
        FAILED DATA(read_failed).
    READ ENTITIES OF ZI_RootApi_S IN LOCAL MODE
      ENTITY RootApi BY \_RootApiText
        ALL FIELDS WITH CORRESPONDING #( ref_RootApi )
        RESULT DATA(ref_RootApiText).

    IF ref_RootApi IS NOT INITIAL.
      ASSIGN ref_RootApi[ 1 ] TO FIELD-SYMBOL(<ref_RootApi>).
      DATA(key) = keys[ KEY draft %TKY = <ref_RootApi>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_RootApi>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_RootApi>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_RootApi> EXCEPT
          SingletonID
          CreatedBy
          CreatedAt
          LastChangedBy
          LastChangedAt
        ) ) )
      ) TO new_RootApi ASSIGNING FIELD-SYMBOL(<new_RootApi>).
      <new_RootApi>-%TARGET[ 1 ]-Id = key-%PARAM-Id.
      FIELD-SYMBOLS <new_RootApiText> LIKE LINE OF new_RootApiText.
      UNASSIGN <new_RootApiText>.
      LOOP AT ref_RootApiText ASSIGNING FIELD-SYMBOL(<ref_RootApiText>).
        DATA(cid_ref_RootApiText) = key_cid.
        IF <new_RootApiText> IS NOT ASSIGNED.
          INSERT VALUE #( %CID_REF  = cid_ref_RootApiText
                          %IS_DRAFT = key-%IS_DRAFT ) INTO TABLE new_RootApiText ASSIGNING <new_RootApiText>.
        ENDIF.
        INSERT VALUE #( %IS_DRAFT = key-%IS_DRAFT
                        %DATA = CORRESPONDING #( <ref_RootApiText> EXCEPT
                                                 SingletonID
                                                 CreatedBy
                                                 CreatedAt
                                                 LastChangedBy
                                                 LastChangedAt
        ) ) INTO TABLE <new_RootApiText>-%target ASSIGNING FIELD-SYMBOL(<target_RootApiText>).
        <target_RootApiText>-%KEY-Id = key-%PARAM-Id.
        <target_RootApiText>-%cid = 'RootApiText'
          && |#{ <ref_RootApiText>-%KEY-Spras }|
          && |#{ <ref_RootApiText>-%KEY-Id }|.
      ENDLOOP.

      MODIFY ENTITIES OF ZI_RootApi_S IN LOCAL MODE
        ENTITY RootApiAll CREATE BY \_RootApi
        FIELDS (
                 Id
               ) WITH new_RootApi
        ENTITY RootApi CREATE BY \_RootApiText
        FIELDS (
                 Spras
                 Id
                 Text_000
               ) WITH new_RootApiText
        MAPPED DATA(mapped_create)
        FAILED failed
        REPORTED reported.

      mapped-RootApi = mapped_create-RootApi.
    ENDIF.

    INSERT LINES OF read_failed-RootApi INTO TABLE failed-RootApi.

    IF failed-RootApi IS INITIAL.
      reported-RootApi = VALUE #( FOR created IN mapped-RootApi (
                                                 %CID = created-%CID
                                                 %ACTION-CopyRootApi = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-RootApiAll-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-RootApiAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_ROOTAPI' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-CopyRootApi = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    result = VALUE #( FOR row IN keys ( %TKY = row-%TKY
                                        %ACTION-CopyRootApi = COND #( WHEN row-%IS_DRAFT = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
    ) ).
  ENDMETHOD.
  METHOD VALIDATETRANSPORTREQUEST.
    DATA change TYPE REQUEST FOR CHANGE ZI_RootApi_S.
    IF keys_RootApi IS NOT INITIAL.
      DATA(is_draft) = keys_RootApi[ 1 ]-%IS_DRAFT.
    ELSEIF keys_RootApiText IS NOT INITIAL.
      is_draft = keys_RootApiText[ 1 ]-%IS_DRAFT.
    ELSE.
      RETURN.
    ENDIF.
    READ ENTITY IN LOCAL MODE ZI_RootApi_S
    FROM VALUE #( ( %IS_DRAFT = is_draft
                    SingletonID = 1
                    %CONTROL-TransportRequestID = if_abap_behv=>mk-on ) )
    RESULT FINAL(transport_from_singleton).
    IF lines( transport_from_singleton ) = 1.
      DATA(transport_request) = transport_from_singleton[ 1 ]-TransportRequestID.
    ENDIF.
    lhc_rap_tdat_cts=>get( )->validate_all_changes(
                                transport_request     = transport_request
                                table_validation_keys = VALUE #(
                                                          ( table = 'ZJU_ROOT_CUST' keys = REF #( keys_RootApi ) )
                                                          ( table = 'ZJU_CHILD_CUST' keys = REF #( keys_RootApiText ) )
                                                               )
                                reported              = REF #( reported )
                                failed                = REF #( failed )
                                change                = REF #( change ) ).
  ENDMETHOD.
ENDCLASS.
