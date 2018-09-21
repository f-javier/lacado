MEMVAR cCNormal, cCMenus, cCpanta, cCMensa, lAyuda

FUNCTION Main()
   LOCAL nMenu := 1
   LOCAL cCInicio := SETCOLOR()
   LOCAL nCol, nFil := 0
   PUBLIC cCNormal := "B/BG,N/W"
   PUBLIC cCMenus := "N/W+,W+/N+"
   PUBLIC cCPanta := "W+/B"
   PUBLIC cCMensa := "B+/W+"
   PUBLIC lAyuda := .T.

   SETCOLOR ( cCNormal )
   CLS
   SETBLINK ( .F. )
   SETCURSOR(  0  )
   SET( _SET_WRAP,    .T. )
   SET( _SET_MESSAGE, 24  )
   SET( _SET_MCENTER, .T. )
   SET( _SET_CONFIRM, .T. )
   SET( _SET_DELETED, .T. )
   SET( _SET_SOFTSEEK, .T. )
   SET( _SET_CONFIRM, .T. )
   SET( _SET_SCOREBOARD, .F. )
   SET DATE ITALIAN
   SET DELIMITERS TO "[]"
   CLS
   DISPBEGIN()
   FOR nCol := 0 TO 24
       FOR nFil := 0 TO 79
           @ nCol,nFil SAY "±"
       ENDFOR
   ENDFOR
   DISPEND()

   @ 0,0 TO 2,79 DOUBLE COLOR ( "B/W" )
   @ 1,1 SAY "      Gestion para Talleres de Lacado         " COLOR( "B/W" )
   @ 1,47 SAY "LACA v1.00        " COLOR( "B/W" )
   @ 1,63 SAY "Fecha: " COLOR( "B/W" )
   @ 1,70 SAY DATE() COLOR( "B/W" )
   @ 1,78 SAY " " COLOR( "B/W" )
   @ 2,23 SAY "(c) Fco. Javier Perez Vidal - 1997"

   SETCOLOR( cCMenus )
   DO WHILE .T.
      CajaTitulo( 4,15,20,65,2," MENU PRINCIPAL ", "" )
      @ 5,17 PROMPT " 1) Mantenimiento de Maestros                  "
      @ 6,17 PROMPT " 2) Procesos Especiales                        "

      MENU TO nMenu

      DO CASE
         CASE nMenu == 1
              M_Maestros()
         CASE nMenu == 2
              M_ProcEspe()
         OTHERWISE
              Salir()
      ENDCASE
   ENDDO

 RETURN NIL

//
STATIC FUNCTION M_Maestros()
       LOCAL nMenu := 1
       LOCAL cPantalla := SAVESCREEN( 5,14,21,66 )
       DO WHILE .T.
          CajaTitulo( 5,14,21,66,2," MANTENIMIENTO DE MAESTROS ", "" )
          @  6,16 PROMPT " 1) Mantenimiento de Familias                  "
          @  7,16 PROMPT " 2) Mantenimiento de Proveedores               "
          @  8,16 PROMPT " 3) Mantenimiento de Clientes                  "
          @  9,16 PROMPT " 4) Mantenimiento de Articulos                 "

          MENU TO nMenu
          DO CASE
             CASE nMenu == 1
                  M_Familias()
             CASE nMenu == 2
                  M_Proveedo()
             CASE nMenu == 3
                  M_Clientes()
             CASE nMenu == 4
                  M_Articu()
             OTHERWISE
                  RESTSCREEN( 5,14,21,66,cPantalla )
                  RETURN NIL
           ENDCASE
        ENDDO
 RETURN NIL

//
STATIC FUNCTION M_Familias()
       LOCAL nMenu := 1
       LOCAL cPantalla := SAVESCREEN( 6,13,22,67 )
       DO WHILE .T.
          CajaTitulo( 6,13,22,67,2," MANTENIMIENTO DE MAESTROS - FAMILIAS ", "" )
          @  7,15 PROMPT " 1) Altas de Familias                          "
          @  8,15 PROMPT " 2) Bajas de Familias                          "
          @  9,15 PROMPT " 3) Consultas de Familias                      "
          @ 10,15 PROMPT " 4) Modificaciones de Familias                 "
          @ 11,15 PROMPT " A) Listado de Familias por Codigo             "
          @ 12,15 PROMPT " B) Listado de Familias por Nombre             "

          MENU TO nMenu
          DO CASE
             CASE nMenu == 1
                  AltasFam()
             CASE nMenu == 2
                  BajasFam()
             CASE nMenu == 3
                  ConsulFam()
             CASE nMenu == 4
                  ModifFam()
             CASE nMenu == 5
                  LFam_Cod()
             CASE nMenu == 6
                  LFam_Nom()
             OTHERWISE
                  RESTSCREEN( 6,13,22,67,cPantalla )
                  RETURN NIL
           ENDCASE
        ENDDO
 RETURN NIL

//
STATIC FUNCTION M_Proveedo()
       LOCAL nMenu := 1
       LOCAL cPantalla := SAVESCREEN( 6,13,22,67 )
       DO WHILE .T.
          CajaTitulo( 6,13,22,67,2," MANTENIMIENTO DE MAESTROS - PROVEEDORES ", "" )
          @  7,15 PROMPT " 1) Altas de Proveedores                       "
          @  8,15 PROMPT " 2) Bajas de Proveedores                       "
          @  9,15 PROMPT " 3) Consultas de Proveedores                   "
          @ 10,15 PROMPT " 4) Modificaciones de Proveedores              "
          @ 11,15 PROMPT " A) Listado de Proveedores por Codigo          "
          @ 12,15 PROMPT " B) Listado de Proveedores por Nombre          "

          MENU TO nMenu
          DO CASE
             CASE nMenu == 1
                  AltasPro()
             CASE nMenu == 2
                  BajasPro()
             CASE nMenu == 3
                  ConsulPro()
             CASE nMenu == 4
                  ModifPro()
             CASE nMenu == 5
                  LPro_Cod()
             CASE nMenu == 6
                  LPro_Nom()
             OTHERWISE
                  RESTSCREEN( 6,13,22,67,cPantalla )
                  RETURN NIL
           ENDCASE
        ENDDO
 RETURN NIL

//
STATIC FUNCTION M_Clientes()
       LOCAL nMenu := 1
       LOCAL cPantalla := SAVESCREEN( 6,13,22,67 )
       DO WHILE .T.
          CajaTitulo( 6,13,22,67,2," MANTENIMIENTO DE MAESTROS - CLIENTES ", "" )
          @  7,15 PROMPT " 1) Altas de Clientes                          "
          @  8,15 PROMPT " 2) Bajas de Clientes                          "
          @  9,15 PROMPT " 3) Consultas de Clientes                      "
          @ 10,15 PROMPT " 4) Modificaciones de Clientes                 "
          @ 11,15 PROMPT " A) Listado de Clientes por Codigo             "
          @ 12,15 PROMPT " B) Listado de Clientes por Nombre             "

          MENU TO nMenu
          DO CASE
             CASE nMenu == 1
                  AltasCli()
             CASE nMenu == 2
                  BajasCli()
             CASE nMenu == 3
                  ConsulCli()
             CASE nMenu == 4
                  ModifCli()
             CASE nMenu == 5
                  LCli_Cod()
             CASE nMenu == 6
                  LCli_Nom()
             OTHERWISE
                  RESTSCREEN( 6,13,22,67,cPantalla )
                  RETURN NIL
           ENDCASE
        ENDDO
 RETURN NIL

//
STATIC FUNCTION M_Articu()
       LOCAL nMenu := 1
       LOCAL cPantalla := SAVESCREEN( 6,13,22,67 )
       DO WHILE .T.
          CajaTitulo( 6,13,22,67,2," MANTENIMIENTO DE MAESTROS - ARTICULOS ", "" )
          @  7,15 PROMPT " 1) Altas de Articulos                         "
          @  8,15 PROMPT " 2) Bajas de Articulos                         "
          @  9,15 PROMPT " 3) Consultas de Articulos                     "
          @ 10,15 PROMPT " 4) Modificaciones de Articulos                "
          @ 11,15 PROMPT " A) Listado de Articulos por Codigo            "
          @ 12,15 PROMPT " B) Listado de Articulos por Nombre            "

          MENU TO nMenu
          DO CASE
             CASE nMenu == 1
                  AltasArt()
             CASE nMenu == 2
                  BajasArt()
             CASE nMenu == 3
                  ConsulArt()
             CASE nMenu == 4
                  ModifArt()
             CASE nMenu == 5
                  LArt_Cod()
             CASE nMenu == 6
                  LArt_Nom()
             OTHERWISE
                  RESTSCREEN( 6,13,22,67,cPantalla )
                  RETURN NIL
           ENDCASE
        ENDDO
 RETURN NIL

//
STATIC FUNCTION M_ProcEspe()
       LOCAL nMenu := 1
       LOCAL cPantalla := SAVESCREEN( 5,14,21,66 )
       DO WHILE .T.
          CajaTitulo( 5,14,21,66,2," PROCESOS ESPECIALES ", "" )
          @  6,16 PROMPT " 1) Creacion de Ficheros de Datos              "
          @  7,16 PROMPT " 2) Creacion de Ficheros de Indices            "
          @  8,16 PROMPT " 3) Compactacion de Ficheros                   "

          MENU TO nMenu
          DO CASE
             CASE nMenu == 1
                  CrearDatos()
             CASE nMenu == 2
                  CrearIndic()
             CASE nMenu == 3
                  Compactar()
             OTHERWISE
                  RESTSCREEN( 5,14,21,66,cPantalla )
                  RETURN NIL
           ENDCASE
        ENDDO
 RETURN NIL

//
STATIC FUNCTION Salir( nMenu )
   LOCAL aOpciones := { "  S¡  ","  No  " }
   LOCAL nSelec    := ALERT( " ¿ Desea Realmente Salir ? ", aOpciones )

   DO CASE
      CASE nSelec == 1
           SET COLOR TO
           CLS
           @ 6,20 TO 12,60 DOUBLE
           @ 8,29  SAY "Gracias por usar esta"
           @ 9,25  SAY "Gestion para Talleres de Lacado"
           @ 10,35 SAY "LACA v1.00"
           @ 15,22 SAY "(c) Fco. Javier Perez Vidal - 1997"
           @ 16,25 SAY "Apartado de Correos nº 1556"
           @ 17,26 SAY "03205 - Elche (Alicante)"
           @ 22,0 SAY " "
           QUIT
   ENDCASE
 RETURN .T.

//
FUNCTION NoDisp( nMenu )
   ALERT( "Funci¢n no disponible" )
 RETURN .T.
