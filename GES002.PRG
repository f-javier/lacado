* * * * * * * * * * *
* Programa .........: Gesti¢n para Talleres de Lacado v1.00
* Subprograma ......: Mantenimiento de Familias.
* Programador ......: Fco. Javier P‚rez Vidal.
* * * * * *
* AltasGen()  : Funci¢n para las ALTAS DE FAMILIAS.
* BajasGen()  : Funci¢n para las BAJAS DE FAMILIAS.
* ConsulGen() : Funci¢n para las CONSULTAS DE FAMILIAS.
* ModifGen()  : Funci¢n para las MODIFICACIONES DE FAMILIAS.
* LGen_Cod()  : Funci¢n para LISTADO DE FAMILIAS POR CODIGO.
* LGen_Nom()  : Funci¢n para LISTADO DE FAMILIAS POR NOMBRE.
* AbrirBBDD() : Funci¢n para abrir los ficheros.
* CerrarBBDD(): Funci¢n para cerrar los ficheros.
* InitVars    : Procedimiento para inicializar las varibles del fichero.
* Literales   : Procedimiento para mostrar los literales de la patalla.
* PedirDatos  : Procedimiento para pedir los datos de la pantalla.
* MostrarDatos: Procedimiento para mostrar los datos en pantalla.
* Salvar      : Procedimiento para salvar los datos de memoria en el fichero.
* Recuperar   : Procedimiento para recuperar los datos del fichero a memoria.
* Buscar()    : Funci¢n para busquedas. Pregunta literal a buscar.
* Visualizar(): Funci¢n para visualizar todo el fichero.
* Control()   : Funci¢n de navegaci¢n por el fichero en modo consultas.
* * * * * *

#include "inkey.ch"

MEMVAR cCNormal, cCpanta, cCMensa

// Definici¢n de variables STATIC. S¢lo visibles desde este programa.
   STATIC nFamCodigo
   STATIC cFamNombre

//
FUNCTION AltasFam( )
   LOCAL cPantalla  := SAVESCREEN( 3,0,24,79 )
   LOCAL GetList    := {}
   LOCAL cColorAnt  := SETCOLOR( )
   LOCAL lSalir     := .T.
   LOCAL cCorrecto  := " "

   SETCOLOR( cCNormal )
   @ 3,0 CLEAR TO 24,79
   SETCOLOR( cCPanta )
   SET( _SET_INTENSITY, .F. )
   SETCURSOR( 1 )
   SET KEY K_F5 TO Buscar
   SET KEY K_F9 TO Visualizar
   IF AbrirBBDD( )
      CajaTitulo( 8,8,15,70,2," Altas de Familias "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 10,23 GET nFamCodigo PICTURE "99"
         READ
         IF !EMPTY( nFamCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nFamCodigo )
            IF FOUND( )
               SETCOLOR( cCMensa )
               SHOW_MSG( 0,"El registro ya existe")
               SETCOLOR( cCPanta )
            ELSE
                  DBAPPEND( )
                  IF NETERR( )
                     ALERT( "­­­ ACCESO DENEGADO !!!;;No se puede a¤adir el registro" )
                  ELSE
                     FAM002->Codigo := nFamCodigo
                     FAM002->( DBCOMMIT() )
                     DO PedirDatos
                     IF !EMPTY( nFamCodigo ) .AND. LASTKEY( ) != K_ESC
                        SET( _SET_CONFIRM, .F. )
                        @ 13,25 SAY "¨Confirma los datos (S/N)?" GET cCorrecto;
                                PICTURE "!" VALID( cCorrecto $ "SN" )
                        READ
                        @ 13,25 SAY "                               "
                        IF cCorrecto == "S"
                           DO Salvar
                           FAM002->( DBCOMMIT( ) )
                           UNLOCK
                           FAM002->( DBCOMMIT() )
                           SETCOLOR( cCMensa )
                           SHOW_MSG( 0,"Se ha salvado el registro" )
                           SETCOLOR( cCPanta )
                        ELSE
                           DBDELETE( )
                           FAM002->( DBCOMMIT( ) )
                        ENDIF
                        SET( _SET_CONFIRM, .T. )
                        cCorrecto := " "
                     ELSE
                        DBDELETE( )
                        FAM002->( DBCOMMIT( ) )
                     ENDIF
                  ENDIF
            ENDIF
         ELSE
            lSalir := .F.
         ENDIF
      ENDDO
   ENDIF
   CerrarBBDD( )
   RESTSCREEN( 3,0,24,79,cPantalla )
   SETCOLOR( cColorAnt )
   SET( _SET_INTENSITY, .T. )
   SETCURSOR( 0 )
   SET KEY K_F5 TO
   SET KEY K_F9 TO
 RETURN .T.

//
FUNCTION BajasFam()
   LOCAL cPantalla  := SAVESCREEN( 3,0,24,79 )
   LOCAL GetList    := {}
   LOCAL cColorAnt  := SETCOLOR( )
   LOCAL lSalir     := .T.
   LOCAL cCorrecto  := " "

   SETCOLOR( cCNormal )
   @ 3,0 CLEAR TO 24,79
   SETCOLOR( cCPanta )
   SET( _SET_INTENSITY, .F. )
   SETCURSOR( 1 )
   SET KEY K_F5 TO Buscar
   SET KEY K_F9 TO Visualizar
   IF AbrirBBDD( )
      CajaTitulo( 8,8,15,70,2," Bajas de Familias "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 10,23 GET nFamCodigo PICTURE "99"
         READ
         IF !EMPTY( nFamCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nFamCodigo )
            IF !FOUND( )
               SETCOLOR( cCMensa )
               SHOW_MSG( 0,"El registro no existe" )
               SETCOLOR( cCPanta )
            ELSE
               IF !RLOCK( )
                  ALERT( "Registro usado por otro usuario" )
               ELSE
                  DO Recuperar
                  DO MostrarDatos
                  SET( _SET_CONFIRM, .F. )
                  @ 13,25 SAY "¨Confirma la baja (S/N)?" GET cCorrecto;
                              PICTURE "!" VALID( cCorrecto $ "SN" )
                  READ
                  @ 13,25 SAY "                             "
                  IF cCorrecto == "S"
                     DBDELETE( )
                     FAM002->( DBCOMMIT() )
                     SETCOLOR( cCMensa )
                     SHOW_MSG( 0,"Se ha borrado el registro" )
                     SETCOLOR( cCPanta )
                  ELSE
                     UNLOCK
                     FAM002->( DBCOMMIT() )
                  ENDIF
                  SET( _SET_CONFIRM, .T. )
                  cCorrecto := " "
               ENDIF
            ENDIF
         ELSE
            lSalir := .F.
         ENDIF
      ENDDO
   ENDIF
   CerrarBBDD( )
   RESTSCREEN( 3,0,24,79,cPantalla )
   SETCOLOR( cColorAnt )
   SET( _SET_INTENSITY, .T. )
   SETCURSOR( 0 )
   SET KEY K_F5 TO
   SET KEY K_F9 TO
 RETURN .T.


//
FUNCTION ConsulFam()
   LOCAL cPantalla  := SAVESCREEN( 3,0,24,79 )
   LOCAL GetList    := {}
   LOCAL cColorAnt  := SETCOLOR( )
   LOCAL lSalir     := .T.
   LOCAL cCorrecto  := " "

   SETCOLOR( cCNormal )
   @ 3,0 CLEAR TO 24,79
   SETCOLOR( cCPanta )
   SET( _SET_INTENSITY, .F. )
   SETCURSOR( 1 )
   SET KEY K_F5 TO Buscar
   SET KEY K_F9 TO Visualizar
   IF AbrirBBDD( )
      CajaTitulo( 8,8,15,70,2," Consultas de Familias "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 10,23 GET nFamCodigo PICTURE "99"
         READ
         IF !EMPTY( nFamCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nFamCodigo )
            IF !FOUND( )
               SETCOLOR( cCMensa )
               SHOW_MSG( 0,"El registro no existe" )
               SETCOLOR( cCPanta )
            ELSE
               DO Recuperar
               DO MostrarDatos
               Control()
            ENDIF
         ELSE
            lSalir := .F.
         ENDIF
      ENDDO
   ENDIF
   CerrarBBDD( )
   RESTSCREEN( 3,0,24,79,cPantalla )
   SETCOLOR( cColorAnt )
   SET( _SET_INTENSITY, .T. )
   SETCURSOR( 0 )
   SET KEY K_F5 TO
   SET KEY K_F9 TO
 RETURN .T.

//
FUNCTION ModifFam()
   LOCAL cPantalla  := SAVESCREEN( 3,0,24,79 )
   LOCAL GetList    := {}
   LOCAL cColorAnt  := SETCOLOR( )
   LOCAL lSalir     := .T.
   LOCAL cCorrecto  := " "

   SETCOLOR( cCNormal )
   @ 3,0 CLEAR TO 24,79
   SETCOLOR( cCPanta )
   SET( _SET_INTENSITY, .F. )
   SETCURSOR( 1 )
   SET KEY K_F5 TO Buscar
   SET KEY K_F9 TO Visualizar
   IF AbrirBBDD( )
      CajaTitulo( 8,8,15,70,2," Modificaciones de Familias "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 10,23 GET nFamCodigo PICTURE "99"
         READ
         IF !EMPTY( nFamCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nFamCodigo )
            IF !FOUND( )
               SETCOLOR( cCMensa )
               SHOW_MSG( 0,"El registro no existe" )
               SETCOLOR( cCPanta )
            ELSE
               IF !RLOCK( )
                  ALERT( "Registro usado por otro usuario" )
               ELSE
                  DO Recuperar
                  DO PedirDatos
                  IF !EMPTY( nFamCodigo ) .AND. LASTKEY( ) != K_ESC
                     SET( _SET_CONFIRM, .F. )
                     @ 13,25 SAY "¨Confirma los datos (S/N)?" GET cCorrecto;
                             PICTURE "!" VALID( cCorrecto $ "SN" )
                     READ
                     @ 13,25 SAY "                               "
                     IF cCorrecto == "S"
                        DO Salvar
                        FAM002->( DBCOMMIT() )
                        SETCOLOR( cCMensa )
                        SHOW_MSG( 0,"Se ha salvado el registro" )
                        SETCOLOR( cCPanta )
                     ELSE
                        UNLOCK
                        FAM002->( DBCOMMIT() )
                     ENDIF
                     SET( _SET_CONFIRM, .T. )
                     cCorrecto := " "
                  ELSE
                     UNLOCK
                     FAM002->( DBCOMMIT() )
                  ENDIF
               ENDIF
            ENDIF
         ELSE
            lSalir := .F.
         ENDIF
      ENDDO
   ENDIF
   CerrarBBDD( )
   RESTSCREEN( 3,0,24,79,cPantalla )
   SETCOLOR( cColorAnt )
   SET( _SET_INTENSITY, .T. )
   SETCURSOR( 0 )
   SET KEY K_F5 TO
   SET KEY K_F9 TO
 RETURN .T.

//
FUNCTION LFam_Cod
   LOCAL cPantalla  := SAVESCREEN( 3,0,24,79 )
   LOCAL GetList    := {}
   LOCAL nDesde    := 0
   LOCAL nHasta    := 99
   LOCAL cDestino  := "P"
   LOCAL cCorrecto := "N"
   LOCAL cColorAnt := SETCOLOR( )
   LOCAL oListado , oCol, nTecla
   LOCAL lMas      := .T.

   SETCOLOR( cCNormal )
   @ 3,0 CLEAR TO 24,79
   SETCOLOR( cCPanta )
   SET( _SET_INTENSITY, .F. )
   SET( _SET_DELIMITERS, .T. )
   SETCURSOR( 1 )
   IF AbrirBBDD( )
      CajaTitulo( 5,15,17,65,2," Listado de Familias por C¢digo "," ESC = Salir ÍÍÍÍÍÍÍÍ 80 Columnas " )
      @  8,25 SAY "C¢digo desde:" GET nDesde PICTURE "99"
      @ 10,25 SAY "C¢digo Hasta:" GET nHasta PICTURE "99"
      @ 12,25 SAY "Destino del listado(P/I):" GET cDestino ;
              PICTURE "!" VALID( cDestino $ "PI" )
      @ 14,25 SAY "¨Confirma los datos(S/N)?" GET cCorrecto ;
              PICTURE "!" VALID( cCorrecto $ "SN" )
      READ

      IF cCorrecto == "S"
         IF cDestino == "P"
            SET FILTER TO FAM002->codigo >= nDesde .AND. ;
                          FAM002->codigo <= nHasta
            DBGOTOP( )
            CajaTitulo( 3,0,24,79,2," Listado de Familias por C¢digo ",;
                                     " Pulse <ESC> para Salir " )
            oListado := TBrowseDB( 4,1,23,78 )
            oListado:headSep := "Í"
            oCol := TBColumnNew( "C¢digo", { || FAM002->CODIGO } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Nombre", { || FAM002->NOMBRE } )
            oListado:addColumn( oCol )
            DO WHILE ( lMas )
               nTecla := 0
               DO WHILE nTecla == 0 .AND. .NOT. oListado:stable
                  oListado:stabilize( )
                  nTecla := INKEY( )
               ENDDO
               IF oListado:stable
                  IF oListado:hitTop .OR. oListado:hitBottom
                     TONE( 125,0 )
                  ENDIF
                  nTecla := INKEY( 0 )
                  DO CASE
                     CASE nTecla == K_ESC
                          lMas := .F.
                     CASE nTecla == K_DOWN
                          oListado:down( )
                     CASE nTecla == K_PGDN
                          oListado:pageDown( )
                     CASE nTecla == K_UP
                          oListado:up( )
                     CASE nTecla == K_PGUP
                          oListado:pageUp( )
                     CASE nTecla == K_RIGHT
                          oListado:right( )
                     CASE nTecla == K_LEFT
                          oListado:left( )
                     OTHERWISE
                          TONE( 125,0 )
                  ENDCASE
               ENDIF
            ENDDO
            SET FILTER TO
         ELSE
            REPORT FORM "reports\gesfam01.frm" ;
                   FOR FAM002->codigo >= nDesde .AND. ;
                       FAM002->codigo <= nHasta ;
                   TO PRINTER NOCONSOLE
         ENDIF
      ENDIF
   ENDIF
   CerrarBBDD( )
   RESTSCREEN( 3,0,24,79,cPantalla )
   SETCOLOR( cColorAnt )
   SET( _SET_INTENSITY, .T. )
   SET( _SET_DELIMITERS, .F. )
   SETCURSOR( 0 )
 RETURN .T.

//
FUNCTION LFam_Nom
   LOCAL cPantalla  := SAVESCREEN( 3,0,24,79 )
   LOCAL GetList    := {}
   LOCAL cDesde    := SPACE( 30 )
   LOCAL cHasta    := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
   LOCAL cDestino  := "P"
   LOCAL cCorrecto := "N"
   LOCAL cColorAnt := SETCOLOR( )
   LOCAL oListado, oCol, nTecla
   LOCAL lMas      := .T.

   SETCOLOR( cCNormal )
   @ 3,0 CLEAR TO 24,79
   SETCOLOR( cCPanta )
   SET( _SET_INTENSITY, .F. )
   SET( _SET_DELIMITERS, .T. )
   SETCURSOR( 1 )
   IF AbrirBBDD( )
      DBSETORDER( 2 )
      CajaTitulo( 5,15,17,65,2," Listado de Familias por Nombre "," ESC = Salir ÍÍÍÍÍÍÍÍ 80 Columnas " )
      @  8,17 SAY "Familia desde:" GET cDesde PICTURE "@K!"
      @ 10,17 SAY "Familia Hasta:" GET cHasta PICTURE "@K!"
      @ 12,25 SAY "Destino del listado(P/I):" GET cDestino ;
              PICTURE "!" VALID( cDestino $ "PI" )
      @ 14,25 SAY "¨Confirma los datos(S/N)?" GET cCorrecto ;
              PICTURE "!" VALID( cCorrecto $ "SN" )
      READ

      IF cCorrecto == "S"
         IF cDestino == "P"
            SET FILTER TO FAM002->nombre >= cDesde .AND. ;
                          FAM002->nombre <= cHasta
            DBGOTOP( )
            CajaTitulo( 3,0,24,79,2," Listado de Familias por Nombre ",;
                                     " Pulse <ESC> para Salir " )
            oListado := TBrowseDB( 4,1,23,78 )
            oListado:headSep := "Í"
            oCol := TBColumnNew( "Nombre", { || FAM002->NOMBRE } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "C¢digo", { || FAM002->CODIGO } )
            oListado:addColumn( oCol )
            DO WHILE ( lMas )
               nTecla := 0
               DO WHILE nTecla == 0 .AND. .NOT. oListado:stable
                  oListado:stabilize( )
                  nTecla := INKEY( )
               ENDDO
               IF oListado:stable
                  IF oListado:hitTop .OR. oListado:hitBottom
                     TONE( 125,0 )
                  ENDIF
                  nTecla := INKEY( 0 )
                  DO CASE
                     CASE nTecla == K_ESC
                          lMas := .F.
                     CASE nTecla == K_DOWN
                          oListado:down( )
                     CASE nTecla == K_PGDN
                          oListado:pageDown( )
                     CASE nTecla == K_UP
                          oListado:up( )
                     CASE nTecla == K_PGUP
                          oListado:pageUp( )
                     CASE nTecla == K_RIGHT
                          oListado:right( )
                     CASE nTecla == K_LEFT
                          oListado:left( )
                     OTHERWISE
                          TONE( 125,0 )
                  ENDCASE
               ENDIF
            ENDDO
            SET FILTER TO
         ELSE
            REPORT FORM "reports\gesfam02.frm" ;
                   FOR FAM002->nombre >= cDesde .AND. ;
                       FAM002->nombre <= cHasta ;
                   TO PRINTER NOCONSOLE
         ENDIF
      ENDIF
   ENDIF
   CerrarBBDD( )
   RESTSCREEN( 3,0,24,79,cPantalla )
   SETCOLOR( cColorAnt )
   SET( _SET_INTENSITY, .T. )
   SET( _SET_DELIMITERS, .F. )
   SETCURSOR( 0 )
 RETURN .T.

//
///////////////////////////////////////////////////////////////////////////
//

//
STATIC FUNCTION AbrirBBDD()
   USE ( "DATOS\FAMILIAS.DBF" ) INDEX ( "DATOS\FAMILIAS.NT1" ) ,;
       ( "DATOS\FAMILIAS.NT2" ) SHARED ALIAS FAM002 NEW
   IF NETERR( )
      ALERT( "­­­ ACCESO DENEGADO !!!;;El fichero de FAMILIAS est  siendo utilizado;en modo exclusivo por otro usuario" )
      RETURN .F.
      DBSETORDER( 1 )
   ENDIF
 RETURN .T.

//
STATIC PROCEDURE CerrarBBDD
   FAM002->( DBCLOSEAREA() )

//
STATIC PROCEDURE InitVars
   nFamCodigo := 0
   cFamNombre := SPACE( 30 )

//
STATIC PROCEDURE Literales
   @ 10,11 SAY "C¢digo...: [  ]"
   @ 11,11 SAY "Nombre...: [                              ]"

//
STATIC PROCEDURE PedirDatos
   LOCAL getlist := {}
   @ 11,23 GET cFamNombre PICTURE "@!"
   READ

//
STATIC PROCEDURE MostrarDatos
   @ 10,23 SAY nFamCodigo PICTURE "99"
   @ 11,23 SAY cFamNombre

//
STATIC PROCEDURE Salvar
   FAM002->Codigo := nFamCodigo
   FAM002->Nombre := cFamNombre

//
STATIC PROCEDURE Recuperar
   nFamCodigo := FAM002->Codigo
   cFamNombre := FAM002->Nombre

//
STATIC FUNCTION Buscar( cProcName, nProcLine, cReadVar )
   LOCAL areactual := SELECT( )
   LOCAL cPantalla := SAVESCREEN( 3,0,24,79 )
   LOCAL cABuscar  := SPACE( 30 )
   LOCAL GetList   := {}
   LOCAL oBuscar, oCol, nTecla
   LOCAL lMas      := .T.

   IF cReadVar == "NFAMCODIGO"
      CajaTitulo( 10,20,12,60,2," Familia a buscar: " )
      @ 11,25 GET cABuscar PICTURE "@!"
      READ
      IF LASTKEY( ) != K_ESC
         DBSETORDER( 2 )
         IF RECCOUNT( ) != 0
            SEEK( cABuscar )
         ENDIF
      ENDIF
      CajaTitulo( 3,0,24,40,2," Visualizaci¢n de Familias ", " <ESC> Salir ÍÍ <INTRO> Seleccionar " )
      oBuscar := TBrowseDB( 4,1,23,39 )
      oBuscar:headSep := "Í"
      oCol := TBColumnNew( "Nombre", { || FAM002->NOMBRE } )
      oBuscar:addColumn( oCol )
      oCol := TBColumnNew( "C¢digo", { || FAM002->CODIGO } )
      oBuscar:addColumn( oCol )
      DO WHILE ( lMas )
         nTecla := 0
         DO WHILE nTecla == 0 .AND. .NOT. oBuscar:stable
            oBuscar:stabilize( )
            nTecla := INKEY( )
         ENDDO
         IF oBuscar:stable
            IF oBuscar:hitTop .OR. oBuscar:hitBottom
               TONE( 125,0 )
            ENDIF
            nTecla := INKEY( 0 )
            DO CASE
               CASE nTecla == K_ESC
                    lMas := .F.
               CASE nTecla == K_ENTER
                    nFamCodigo := FAM002->Codigo
                    lMas := .F.
               CASE nTecla == K_DOWN
                    oBuscar:down( )
               CASE nTecla == K_PGDN
                    oBuscar:pageDown( )
               CASE nTecla == K_UP
                    oBuscar:up( )
               CASE nTecla == K_PGUP
                    oBuscar:pageUp( )
               CASE nTecla == K_RIGHT
                    oBuscar:right( )
               CASE nTecla == K_LEFT
                    oBuscar:left( )
               OTHERWISE
                    TONE( 125,0 )
            ENDCASE
         ENDIF
      ENDDO
   ENDIF
   DBSETORDER( 1 )
   RESTSCREEN( 3,0,24,79,cPantalla )
   SELECT( areactual )
 RETURN NIL

//
STATIC FUNCTION Visualizar( cProcName, nProcLine, cReadVar )
   LOCAL areactual := SELECT( )
   LOCAL cPantalla := SAVESCREEN( 3,0,24,40 )
   LOCAL oVisualizar, oCol, nTecla
   LOCAL lMas      := .T.

   IF cReadVar == "NFAMCODIGO"
      DBSETORDER( 2 )
      IF RECCOUNT( ) != 0
         DBGOTOP( )
      ENDIF
      CajaTitulo( 3,0,24,40,2," Visualizaci¢n de Familias ", " <ESC> Salir ÍÍ <INTRO> Seleccionar " )
      oVisualizar := TBrowseDB( 4,1,23,39 )
      oVisualizar:headSep := "Í"
      oCol:= TBColumnNew( "Nombre", { || FAM002->NOMBRE } )
      oVisualizar:addColumn( oCol )
      oCol := TBColumnNew( "C¢digo", { || FAM002->CODIGO } )
      oVisualizar:addColumn( oCol )
      DO WHILE ( lMas )
         nTecla := 0
         DO WHILE nTecla == 0 .AND. .NOT. oVisualizar:stable
            oVisualizar:stabilize( )
            nTecla := INKEY( )
         ENDDO
         IF oVisualizar:stable
            IF oVisualizar:hitTop .OR. oVisualizar:hitBottom
               TONE( 125,0 )
            ENDIF
            nTecla := INKEY( 0 )
            DO CASE
               CASE nTecla == K_ESC
                    lMas := .F.
               CASE nTecla == K_ENTER
                    nFamCodigo := FAM002->Codigo
                    lMas := .F.
               CASE nTecla == K_DOWN
                    oVisualizar:down( )
               CASE nTecla == K_PGDN
                    oVisualizar:pageDown( )
               CASE nTecla == K_UP
                    oVisualizar:up( )
               CASE nTecla == K_PGUP
                    oVisualizar:pageUp( )
               CASE nTecla == K_RIGHT
                    oVisualizar:right( )
               CASE nTecla == K_LEFT
                    oVisualizar:left( )
               OTHERWISE
                    TONE( 125,0 )
            ENDCASE
         ENDIF
      ENDDO
   ENDIF
   DBSETORDER( 1 )
   RESTSCREEN( 3,0,24,40,cPantalla )
   SELECT( areactual )
 RETURN NIL

//
STATIC FUNCTION Control()
   LOCAL nTecla   := 0
   LOCAL nPrimero := 0
   LOCAL nUltimo  := 0
   LOCAL nActual  := 0

   nActual := RECNO( )
   DBGOTOP( )
   nPrimero := RECNO( )
   DBGOBOTTOM( )
   nUltimo  := RECNO( )
   DBGOTO( nActual )
   SETCURSOR( 0 )
   @ 13,15 SAY "Posibilidades: (Inicio) (-) (+) (fin) (ESC=Salir)"
   DO WHILE nTecla != K_ESC
      @ 14,10 SAY SPACE( 60 )
      IF nPrimero == nUltimo
         @ 14,25 SAY "Principio/Final del fichero"
      ELSEIF RECNO( ) == nPrimero
         @ 14,28 SAY "Principio del fichero"
      ELSEIF RECNO( ) == nUltimo
         @ 14,30 SAY "Final del fichero"
      ENDIF
      nTecla := INKEY( 0 )
      IF nTecla == K_HOME
         DBGOTOP( )
      ELSEIF nTecla == K_END
         DBGOBOTTOM( )
      ELSEIF nTecla == 43
         IF RECNO( ) != nUltimo
            DBSKIP( )
         ENDIF
      ELSEIF nTecla == 45
         DBSKIP( -1 )
      ENDIF
      DO Recuperar
      DO MostrarDatos
   ENDDO
   @ 13,15 SAY "                                                 "
   @ 14,10 SAY SPACE( 60 )
   SETCURSOR( 1 )
 RETURN NIL
