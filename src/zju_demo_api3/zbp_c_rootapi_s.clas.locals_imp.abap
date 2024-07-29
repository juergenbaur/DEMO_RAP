CLASS LHC_ZI_ROOTAPI_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      AUGMENT_ROOTAPI FOR MODIFY
        IMPORTING
          ENTITIES_CREATE FOR CREATE RootApiAll\_RootApi
          ENTITIES_UPDATE FOR UPDATE RootApi.
ENDCLASS.

CLASS LHC_ZI_ROOTAPI_S IMPLEMENTATION.
  METHOD AUGMENT_ROOTAPI.
    DATA: text_for_new_entity      TYPE TABLE FOR CREATE ZI_RootApi\_RootApiText,
          text_for_existing_entity TYPE TABLE FOR CREATE ZI_RootApi\_RootApiText,
          text_update              TYPE TABLE FOR UPDATE ZI_RootApiText.
    DATA: relates_create TYPE abp_behv_relating_tab,
          relates_update TYPE abp_behv_relating_tab,
          relates_cba    TYPE abp_behv_relating_tab.
    DATA: text_tky_link  TYPE STRUCTURE FOR READ LINK ZI_RootApi\_RootApiText,
          text_tky       LIKE text_tky_link-target.

    LOOP AT entities_create INTO DATA(entity).
      DATA(tabix) = sy-tabix.
      LOOP AT entity-%TARGET ASSIGNING FIELD-SYMBOL(<target>).
        APPEND tabix TO relates_create.
        INSERT VALUE #( %CID_REF = <target>-%CID
                        %IS_DRAFT = <target>-%IS_DRAFT
                          %KEY-Id = <target>-%KEY-Id
                        %TARGET = VALUE #( (
                          %CID = |CREATETEXTCID{ tabix }_{ sy-tabix }|
                          %IS_DRAFT = <target>-%IS_DRAFT
                          Spras = sy-langu
                          Text_000 = <target>-Text_000
                          %CONTROL-Spras = if_abap_behv=>mk-on
                          %CONTROL-Text_000 = <target>-%CONTROL-Text_000 ) ) )
                     INTO TABLE text_for_new_entity.
      ENDLOOP.
    ENDLOOP.
    MODIFY AUGMENTING ENTITIES OF ZI_RootApi_S
      ENTITY RootApi
        CREATE BY \_RootApiText
        FROM text_for_new_entity
        RELATING TO entities_create BY relates_create.

    IF entities_update IS NOT INITIAL.
      READ ENTITIES OF ZI_RootApi_S
        ENTITY RootApi BY \_RootApiText
          FROM CORRESPONDING #( entities_update )
          LINK DATA(link).
      LOOP AT entities_update INTO DATA(update) WHERE %CONTROL-Text_000 = if_abap_behv=>mk-on.
        tabix = sy-tabix.
        text_tky = CORRESPONDING #( update-%TKY MAPPING
                                                        Id = Id
                                    ).
        text_tky-Spras = sy-langu.
        IF line_exists( link[ KEY draft source-%TKY  = CORRESPONDING #( update-%TKY )
                                        target-%TKY  = CORRESPONDING #( text_tky ) ] ).
          APPEND tabix TO relates_update.
          APPEND VALUE #( %TKY = CORRESPONDING #( text_tky )
                          %CID_REF = update-%CID_REF
                          Text_000 = update-Text_000
                          %CONTROL = VALUE #( Text_000 = update-%CONTROL-Text_000 )
          ) TO text_update.
        ELSEIF line_exists(  text_for_new_entity[ KEY cid %IS_DRAFT = update-%IS_DRAFT
                                                          %CID_REF  = update-%CID_REF ] ).
          APPEND tabix TO relates_update.
          APPEND VALUE #( %TKY = CORRESPONDING #( text_tky )
                          %CID_REF = text_for_new_entity[ %IS_DRAFT = update-%IS_DRAFT
                          %CID_REF = update-%CID_REF ]-%TARGET[ 1 ]-%CID
                          Text_000 = update-Text_000
                          %CONTROL = VALUE #( Text_000 = update-%CONTROL-Text_000 )
          ) TO text_update.
        ELSE.
          APPEND tabix TO relates_cba.
          APPEND VALUE #( %TKY = CORRESPONDING #( update-%TKY )
                          %CID_REF = update-%CID_REF
                          %TARGET  = VALUE #( (
                            %CID = |UPDATETEXTCID{ tabix }|
                            Spras = sy-langu
                            %IS_DRAFT = text_tky-%IS_DRAFT
                            Text_000 = update-Text_000
                            %CONTROL-Spras = if_abap_behv=>mk-on
                            %CONTROL-Text_000 = update-%CONTROL-Text_000
                          ) )
          ) TO text_for_existing_entity.
        ENDIF.
      ENDLOOP.
      IF text_update IS NOT INITIAL.
        MODIFY AUGMENTING ENTITIES OF ZI_RootApi_S
          ENTITY RootApiText
            UPDATE FROM text_update
            RELATING TO entities_update BY relates_update.
      ENDIF.
      IF text_for_existing_entity IS NOT INITIAL.
        MODIFY AUGMENTING ENTITIES OF ZI_RootApi_S
          ENTITY RootApi
            CREATE BY \_RootApiText
            FROM text_for_existing_entity
            RELATING TO entities_update BY relates_cba.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
