CLASS LHC_CHILD DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      CALCULATELANGUAGE FOR DETERMINE ON SAVE
        IMPORTING
          KEYS FOR  Child~CalculateLanguage .
ENDCLASS.

CLASS LHC_CHILD IMPLEMENTATION.
  METHOD CALCULATELANGUAGE.
  ENDMETHOD.
ENDCLASS.
