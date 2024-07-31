CLASS zcl_ju_http_handler DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
*https://www.youtube.com/watch?v=dnvYMhWOlQE
*https://www.youtube.com/watch?v=X4vJurLvCWU&list=PL6RpkC85SLQDyQt1LBVzDEUv4YADs0Q9K&index=11
*https://api.sap.com/api/CE_BANK_0003/tryout
*2JlXQtkZjMgBYAGn6sYflsfHJ8g2FjgS
*create_v4_local_proxy
    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_bank_details RETURNING VALUE(r_json) TYPE string.

ENDCLASS.



CLASS zcl_ju_http_handler IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.
    DATA(lt_params) = request->get_form_fields(  ).

    READ TABLE lt_params REFERENCE INTO DATA(lr_params) WITH KEY name = 'cmd'.
    IF sy-subrc NE 0.
      response->set_status(
        EXPORTING
          i_code   = 400
          i_reason = 'Bad request'
      ).
      RETURN.
    ENDIF.
*CATCH cx_web_message_error.
    CASE lr_params->value.
      WHEN 'timestamp'.
        response->set_text( |HTTP Servic Application executed by { cl_abap_context_info=>get_user_technical_name( ) } on { cl_abap_context_info=>get_system_date(  ) } at { cl_abap_context_info=>get_system_time(  ) }| ).
     when 'getbankdetails'.
     response->set_text( get_bank_details( )  ).
*     CATCH cx_web_message_error.
      WHEN OTHERS.
        response->set_status(
      EXPORTING
        i_code   = 400
        i_reason = 'Bad request'
    ).
    ENDCASE.


  ENDMETHOD.
  METHOD get_bank_details.
    DATA: lv_url TYPE string VALUE 'https://sandbox.api.sap.com/s4hanacloud/sap/opu/odata/sap/'.
    DATA: lo_http_client TYPE REF TO if_web_http_client.

    lo_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = cl_http_destination_provider=>create_by_url( i_url = lv_url ) ).
    DATA(lo_request) = lo_http_client->get_http_request( ).
    lo_request->set_header_fields( VALUE #(
     ( name = 'Content-Type' value = 'application/json' )
     ( name = 'Accept' value = 'application/json' )
     ( name = 'APIKey' value = '2JlXQtkZjMgBYAGn6sYflsfHJ8g2FjgS' )
     ) ).

    lo_request->set_uri_path( i_uri_path = lv_url && 'API_BANKDETAIL_SRV/A_BankDetail?top256$format=json' ).

    TRY.
        DATA(lv_response) = lo_http_client->execute( i_method = if_web_http_client=>get )->get_text(  ).
      CATCH cx_web_http_client_error.
    ENDTRY.
    r_json = lv_response.
  ENDMETHOD.

ENDCLASS.
