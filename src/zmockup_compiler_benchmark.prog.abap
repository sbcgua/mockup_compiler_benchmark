report zmockup_compiler_benchmark.

include ztest_benchmark.
include zmockup_compiler_w3mi_contrib.
include zmockup_compiler_xlrd_contrib.
include zmockup_compiler_error.
include zmockup_compiler_workbook_prs.

start-of-selection.

class lcl_app definition final.
  public section.

    methods prepare
      importing
        iv_path type string.
    methods run
      importing
        iv_method type string.

    methods abap2xlsx.
    methods xlreader.

    class-methods main
      importing
        iv_path type string.

    data mv_num_rounds type i.
    data mv_xdata type xstring.

endclass.

class lcl_app implementation.

  method prepare.

    mv_xdata = zcl_w3mime_fs=>read_file_x( iv_path ).

  endmethod.

  method abap2xlsx.

    data lt_mocks type lcl_workbook_parser=>tt_mocks.
    data li_excel type ref to lif_excel.
    li_excel = lcl_excel_abap2xlsx=>load( mv_xdata ).
    lt_mocks = lcl_workbook_parser=>parse( li_excel ).

  endmethod.

  method xlreader.

    data lt_mocks type lcl_workbook_parser=>tt_mocks.
    data li_excel type ref to lif_excel.
    li_excel = lcl_excel_xlreader=>load( mv_xdata ).
    lt_mocks = lcl_workbook_parser=>parse( li_excel ).

  endmethod.

  method run.

    data lo_benchmark type ref to lcl_benchmark.

    create object lo_benchmark
      exporting
        io_object = me
        iv_method = iv_method
        iv_times  = mv_num_rounds.

    lo_benchmark->run( ).
    lo_benchmark->print( ).

  endmethod.

  method main.

    data lo_app type ref to lcl_app.
    create object lo_app.

    lo_app->prepare( iv_path ).
    lo_app->mv_num_rounds = 10.

    lo_app->run( 'abap2xlsx' ).
    lo_app->run( 'xlreader' ).

  endmethod.

endclass.

selection-screen begin of block b1.
parameters: p_path type char255.
selection-screen end of block b1.

start-of-selection.

  lcl_app=>main( |{ p_path }| ).
