* * * * * * * * * * *
* Programa .........: Gesti¢n para Talleres de Lacado v1.00
* Subprograma ......: Mantenimiento de Art¡culos.
* Programador ......: Fco. Javier P‚rez Vidal.
* * * * * *
* AltasArt()  : Funci¢n para las ALTAS DE ARTICULOS
* BajasArt()  : Funci¢n para las BAJAS DE ARTICULOS.
* ConsulArt() : Funci¢n para las CONSULTAS DE ARTICULOS.
* ModifArt()  : Funci¢n para las MODIFICACIONES DE ARTICULOS.
* LArt_Cod()  : Funci¢n para LISTADO DE ARTICULOS POR CODIGO.
* LArt_Nom()  : Funci¢n para LISTADO DE ARTICULOS POR NOMBRE.
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
   STATIC nArtCodigo
   STATIC cArtNombre
   STATIC nArtFamili
   STATIC nArtProvee
   STATIC nArtPtsCos
   STATIC nArtPtsVen

   STATIC cFamilia
   STATIC cProveedor

//
FUNCTION AltasArt( )
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
      CajaTitulo( 8,8,19,70,2," Altas de Art¡culos "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 10,23 GET nArtCodigo PICTURE "99999"
         READ
         IF !EMPTY( nArtCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nArtCodigo )
            IF FOUND( )
               SETCOLOR( cCMensa )
               SHOW_MSG( 0,"El registro ya existe")
               SETCOLOR( cCPanta )
            ELSE
                  DBAPPEND( )
                  IF NETERR( )
                     ALERT( "­­­ ACCESO DENEGADO !!!;;No se puede a¤adir el registro" )
                  ELSE
                     ART004->Codigo := nArtCodigo
                     ART004->( DBCOMMIT() )
                     DO PedirDatos
                     IF !EMPTY( nArtCodigo ) .AND. LASTKEY( ) != K_ESC
                        SET( _SET_CONFIRM, .F. )
                        @ 17,25 SAY "¨Confirma los datos (S/N)?" GET cCorrecto;
                                PICTURE "!" VALID( cCorrecto $ "SN" )
                        READ
                        @ 17,25 SAY "                               "
                        IF cCorrecto == "S"
                           DO Salvar
                           ART004->( DBCOMMIT( ) )
                           UNLOCK
                           ART004->( DBCOMMIT() )
                           SETCOLOR( cCMensa )
                           SHOW_MSG( 0,"Se ha salvado el registro" )
                           SETCOLOR( cCPanta )
                        ELSE
                           DBDELETE( )
                           ART004->( DBCOMMIT( ) )
                        ENDIF
                        SET( _SET_CONFIRM, .T. )
                        cCorrecto := " "
                     ELSE
                        DBDELETE( )
                        ART004->( DBCOMMIT( ) )
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
FUNCTION BajasArt()
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
      CajaTitulo( 8,8,19,70,2," Bajas de Art¡culos "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 10,23 GET nArtCodigo PICTURE "99999"
         READ
         IF !EMPTY( nArtCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nArtCodigo )
            IF !FOUND( )
               SETCOLOR( cCMensa )
               SHOW_MSG( 0,"El registro no existe" )
               SETCOLOR( cCPanta )
            ELSE
               IF !RLOCK( )
                  ALERT( "Registro usado por otro usuario" )
               ELSE
                  DO Recuperar
                  cFamilia := FAM004->NOMBRE
                  cProveedor := PRO004->NOMBRE
                  DO MostrarDatos
                  SET( _SET_CONFIRM, .F. )
                  @ 17,25 SAY "¨Confirma la baja (S/N)?" GET cCorrecto;
                              PICTURE "!" VALID( cCorrecto $ "SN" )
                  READ
                  @ 17,25 SAY "                             "
                  IF cCorrecto == "S"
                     DBDELETE( )
                     ART004->( DBCOMMIT() )
                     SETCOLOR( cCMensa )
                     SHOW_MSG( 0,"Se ha borrado el registro" )
                     SETCOLOR( cCPanta )
                  ELSE
                     UNLOCK
                     ART004->( DBCOMMIT() )
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
FUNCTION ConsulArt()
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
      CajaTitulo( 8,8,19,70,2," Consultas de Art¡culos "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 10,23 GET nArtCodigo PICTURE "99999"
         READ
         IF !EMPTY( nArtCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nArtCodigo )
            IF !FOUND( )
               SETCOLOR( cCMensa )
               SHOW_MSG( 0,"El registro no existe" )
               SETCOLOR( cCPanta )
            ELSE
               DO Recuperar
               cFamilia := FAM004->NOMBRE
               cProveedor := PRO004->NOMBRE
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
FUNCTION ModifArt()
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
      CajaTitulo( 8,8,19,70,2," Modificaciones de Art¡culos "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 10,23 GET nArtCodigo PICTURE "99999"
         READ
         IF !EMPTY( nArtCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nArtCodigo )
            IF !FOUND( )
               SETCOLOR( cCMensa )
               SHOW_MSG( 0,"El registro no existe" )
               SETCOLOR( cCPanta )
            ELSE
               IF !RLOCK( )
                  ALERT( "Registro usado por otro usuario" )
               ELSE
                  DO Recuperar
                  cFamilia := FAM004->NOMBRE
                  cProveedor := PRO004->NOMBRE
                  DO MostrarDatos
                  DO PedirDatos
                  IF !EMPTY( nArtCodigo ) .AND. LASTKEY( ) != K_ESC
                     SET( _SET_CONFIRM, .F. )
                     @ 17,25 SAY "¨Confirma los datos (S/N)?" GET cCorrecto;
                             PICTURE "!" VALID( cCorrecto $ "SN" )
                     READ
                     @ 17,25 SAY "                               "
                     IF cCorrecto == "S"
                        DO Salvar
                        ART004->( DBCOMMIT() )
                        SETCOLOR( cCMensa )
                        SHOW_MSG( 0,"Se ha salvado el registro" )
                        SETCOLOR( cCPanta )
                     ELSE
                        UNLOCK
                        ART004->( DBCOMMIT() )
                     ENDIF
                     SET( _SET_CONFIRM, .T. )
                     cCorrecto := " "
                  ELSE
                     UNLOCK
                     ART004->( DBCOMMIT() )
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
FUNCTION LArt_Cod
   LOCAL cPantalla  := SAVESCREEN( 3,0,24,79 )
   LOCAL GetList    := {}
   LOCAL nDesde    := 0
   LOCAL nHasta    := 99999
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
      CajaTitulo( 5,15,17,65,2," Listado de Art¡culos por C¢digo "," ESC = Salir ÍÍÍÍÍÍÍÍ132 Columnas " )
      @  8,25 SAY "C¢digo desde:" GET nDesde PICTURE "99999"
      @ 10,25 SAY "C¢digo Hasta:" GET nHasta PICTURE "99999"
      @ 12,25 SAY "Destino del listado(P/I):" GET cDestino ;
              PICTURE "!" VALID( cDestino $ "PI" )
      @ 14,25 SAY "¨Confirma los datos(S/N)?" GET cCorrecto ;
              PICTURE "!" VALID( cCorrecto $ "SN" )
      READ

      IF cCorrecto == "S"
         IF cDestino == "P"
            SET FILTER TO ART004->codigo >= nDesde .AND. ;
                          ART004->codigo <= nHasta
            DBGOTOP( )
            CajaTitulo( 3,0,24,79,2," Listado de Art¡culos por C¢digo ",;
                                     " Pulse <ESC> para Salir " )
            oListado := TBrowseDB( 4,1,23,78 )
            oListado:headSep := "Í"
            oCol := TBColumnNew( "C¢digo", { || ART004->CODIGO } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Nombre", { || ART004->NOMBRE } )
            oListado:addColumn( oCol )
//	     oCol := TBColumnNew( "Familia", { || ART004->FAMILIA } )
//	    oListado:addColumn( oCol )
	    oCol := TBColumnNew( "Familia", { || FAM004->NOMBRE } )
	    oListado:addColumn( oCol )
//	     oCol := TBColumnNew( "Proveedor", { || ART004->PROVEEDOR } )
//	    oListado:addColumn( oCol )
	    oCol := TBColumnNew( "Proveedor", { || PRO004->NOMBRE } )
	    oListado:addColumn( oCol )
	    oCol := TBColumnNew( "Pts. Coste", ;
		    { || TRANSFORM((ART004->PTSCOSTE), "@EZ 99,999.99") } )
            oListado:addColumn( oCol )
	    oCol := TBColumnNew( "Pts. Venta", ;
		    { || TRANSFORM((ART004->PTSVENTA), "@EZ 99,999.99") } )
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
            REPORT FORM "reports\gesart01.frm" ;
                   FOR ART004->codigo >= nDesde .AND. ;
                       ART004->codigo <= nHasta ;
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
FUNCTION LArt_Nom
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
      CajaTitulo( 5,14,17,68,2," Listado de Art¡culos por Nombre "," ESC = Salir ÍÍÍÍÍÍÍÍ 132 Columnas " )
      @  8,17 SAY "Art¡culo desde:" GET cDesde PICTURE "@K!"
      @ 10,17 SAY "Art¡culo Hasta:" GET cHasta PICTURE "@K!"
      @ 12,25 SAY "Destino del listado(P/I):" GET cDestino ;
              PICTURE "!" VALID( cDestino $ "PI" )
      @ 14,25 SAY "¨Confirma los datos(S/N)?" GET cCorrecto ;
              PICTURE "!" VALID( cCorrecto $ "SN" )
      READ

      IF cCorrecto == "S"
         IF cDestino == "P"
            SET FILTER TO ART004->nombre >= cDesde .AND. ;
                          ART004->nombre <= cHasta
            DBGOTOP( )
            CajaTitulo( 3,0,24,79,2," Listado de Art¡culos por Nombre ",;
                                     " Pulse <ESC> para Salir " )
            oListado := TBrowseDB( 4,1,23,78 )
            oListado:headSep := "Í"
            oCol := TBColumnNew( "Nombre", { || ART004->NOMBRE } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "C¢digo", { || ART004->CODIGO } )
            oListado:addColumn( oCol )
	    oCol := TBColumnNew( "Familia", { || FAM004->NOMBRE } )
            oListado:addColumn( oCol )
	    oCol := TBColumnNew( "Proveedor", { || PRO004->NOMBRE } )
            oListado:addColumn( oCol )
	    oCol := TBColumnNew( "Pts. Coste", ;
		    { || TRANSFORM((ART004->PTSCOSTE), "@EZ 99,999.99") } )
            oListado:addColumn( oCol )
	    oCol := TBColumnNew( "Pts. Venta", ;
		    { || TRANSFORM((ART004->PTSVENTA), "@EZ 99,999.99") } )
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
            REPORT FORM "reports\gesart02.frm" ;
                   FOR ART004->nombre >= cDesde .AND. ;
                       ART004->nombre <= cHasta ;
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
   USE ( "DATOS\ARTICU.DBF" ) INDEX ( "DATOS\ARTICU.NT1" ) ,;
       ( "DATOS\ARTICU.NT2" ) SHARED ALIAS ART004 NEW
   IF NETERR( )
      ALERT( "­­­ ACCESO DENEGADO !!!;;El fichero de ARTICULOS est  siendo utilizado;en modo exclusivo por otro usuario" )
      RETURN .F.
   ELSE
      DBSETORDER( 1 )
      USE ( "DATOS\PROVEEDO.DBF" ) INDEX ( "DATOS\PROVEEDO.NT1" ) ,;
          ( "DATOS\PROVEEDO.NT2" ) SHARED ALIAS PRO004 NEW
      IF NETERR( )
         ALERT( "­­­ ACCESO DENEGADO !!!;;El fichero de PROVEEDORES est  siendo utilizado;en modo exclusivo por otro usuario" )
         RETURN .F.
      ELSE
         DBSETORDER( 1 )
         USE ( "DATOS\FAMILIAS.DBF" ) INDEX ( "DATOS\FAMILIAS.NT1" ) ,;
             ( "DATOS\FAMILIAS.NT2" ) SHARED ALIAS FAM004 NEW
         IF NETERR( )
            ALERT( "­­­ ACCESO DENEGADO !!!;;El fichero de FAMILIAS est  siendo utilizado;en modo exclusivo por otro usuario" )
            RETURN .F.
         ELSE
            DBSETORDER( 1 )
         ENDIF
      ENDIF
   ENDIF
   SELECT ART004
   DBSETRELATION( "PRO004", { || ART004->PROVEEDOR }, "ART004->PROVEEDOR" )
   DBSETRELATION( "FAM004", { || ART004->FAMILIA }, "ART004->FAMILIA" )
 RETURN .T.

//
STATIC PROCEDURE CerrarBBDD
   ART004->( DBCLOSEAREA() )
   PRO004->( DBCLOSEAREA() )
   FAM004->( DBCLOSEAREA() )

//
STATIC PROCEDURE InitVars
   nArtCodigo := 0
   cArtNombre := SPACE( 40 )
   nArtFamili := 0
   nArtProvee := 0
   nArtPtsCos := 0.0
   nArtPtsVen := 0.0

   cFamilia   := SPACE( 30 )
   cProveedor := SPACE( 30 )

//
STATIC PROCEDURE Literales
   @ 10,11 SAY "C¢digo...: [     ]"
   @ 11,11 SAY "Nombre...: [                                        ]"
   @ 12,11 SAY "Familia..: [  ] [                              ]"
   @ 13,11 SAY "Proveedor: [   ] [                              ]"
   @ 14,11 SAY "Pts.Coste: [         ]"
   @ 15,11 SAY "Pts.Venta: [         ]"

//
STATIC PROCEDURE PedirDatos
   LOCAL getlist := {}
   @ 11,23 GET cArtNombre PICTURE "@!"
   @ 12,23 GET nArtFamili PICTURE "99" VALID AceptaFam()
   @ 13,23 GET nArtProvee PICTURE "999" VALID AceptaPro()
   @ 14,23 GET nArtPtsCos PICTURE "@E 99,999.99"
   @ 15,23 GET nArtPtsVen PICTURE "@E 99,999.99"
   READ

//
STATIC PROCEDURE MostrarDatos
   @ 10,23 SAY nArtCodigo PICTURE "99999"
   @ 11,23 SAY cArtNombre
   @ 12,23 SAY nArtFamili PICTURE "99"
   @ 12,28 SAY cFamilia
   @ 13,23 SAY nArtProvee PICTURE "999"
   @ 13,29 SAY cProveedor
   @ 14,23 SAY nArtPtsCos PICTURE "@E 99,999.99"
   @ 15,23 SAY nArtPtsVen PICTURE "@E 99,999.99"

//
STATIC PROCEDURE Salvar
   ART004->Codigo := nArtCodigo
   ART004->Nombre := cArtNombre
   ART004->Familia := nArtFamili
   ART004->Proveedor := nArtProvee
   ART004->PtsCoste := nArtPtsCos
   ART004->PtsVenta := nArtPtsVen

//
STATIC PROCEDURE Recuperar
   nArtCodigo := ART004->Codigo
   cArtNombre := ART004->Nombre
   nArtFamili := ART004->Familia
   nArtProvee := ART004->Proveedor
   nArtPtsCos := ART004->PtsCoste
   nArtPtsVen := ART004->PtsVenta

//
STATIC FUNCTION Buscar( cProcName, nProcLine, cReadVar )
   LOCAL areactual := SELECT( )
   LOCAL cPantalla := SAVESCREEN( 3,0,24,79 )
   LOCAL cABuscar  := SPACE( 30 )
   LOCAL GetList   := {}
   LOCAL oBuscar, oCol, nTecla
   LOCAL lMas      := .T.

   IF cReadVar == "NARTCODIGO"
      CajaTitulo( 10,20,12,60,2," Art¡culo a buscar: " )
      @ 11,25 GET cABuscar PICTURE "@!"
      READ
      IF LASTKEY( ) != K_ESC
         DBSETORDER( 2 )
         IF RECCOUNT( ) != 0
            SEEK( cABuscar )
         ENDIF
      ENDIF
      CajaTitulo( 3,0,24,50,2," Visualizaci¢n de Art¡culos ", " <ESC> Salir ÍÍ <INTRO> Seleccionar " )
      oBuscar := TBrowseDB( 4,1,23,49 )
      oBuscar:headSep := "Í"
      oCol := TBColumnNew( "Nombre", { || ART004->NOMBRE } )
      oBuscar:addColumn( oCol )
      oCol := TBColumnNew( "C¢digo", { || ART004->CODIGO } )
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
                    nArtCodigo := ART004->Codigo
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
   LOCAL cPantalla := SAVESCREEN( 3,0,24,50 )
   LOCAL oVisualizar, oCol, nTecla
   LOCAL lMas      := .T.

   IF cReadVar == "NARTCODIGO"
      DBSETORDER( 2 )
      IF RECCOUNT( ) != 0
         DBGOTOP( )
      ENDIF
      CajaTitulo( 3,0,24,50,2," Visualizaci¢n de Art¡culos ", " <ESC> Salir ÍÍ <INTRO> Seleccionar " )
      oVisualizar := TBrowseDB( 4,1,23,49 )
      oVisualizar:headSep := "Í"
      oCol:= TBColumnNew( "Nombre", { || ART004->NOMBRE } )
      oVisualizar:addColumn( oCol )
      oCol := TBColumnNew( "C¢digo", { || ART004->CODIGO } )
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
                    nArtCodigo := ART004->Codigo
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
   RESTSCREEN( 3,0,24,50,cPantalla )
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
   @ 17,15 SAY "Posibilidades: (Inicio) (-) (+) (fin) (ESC=Salir)"
   DO WHILE nTecla != K_ESC
      @ 18,10 SAY SPACE( 60 )
      IF nPrimero == nUltimo
         @ 18,25 SAY "Principio/Final del fichero"
      ELSEIF RECNO( ) == nPrimero
         @ 18,28 SAY "Principio del fichero"
      ELSEIF RECNO( ) == nUltimo
         @ 18,30 SAY "Final del fichero"
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
      cFamilia := FAM004->NOMBRE
      cProveedor := PRO004->NOMBRE
      DO MostrarDatos
   ENDDO
   @ 17,15 SAY "                                                 "
   @ 18,10 SAY SPACE( 60 )
   SETCURSOR( 1 )
 RETURN NIL

//
STATIC FUNCTION AceptaFam
   SELECT FAM004
      IF EMPTY( nArtFamili )
         cFamilia := SPACE( 30 )
         @ 12,28 SAY SPACE( 30 )
      ELSE
         SEEK ( nArtFamili )
         IF FOUND( )
            cFamilia := FAM004->NOMBRE
            @ 12,28 SAY cFamilia
            SELECT ART004
            RETURN .T.
         ELSE
            SETCOLOR( cCMensa )
            SHOW_MSG( 0,"La Familia no existe")
            SETCOLOR( cCPanta )
            RETURN .F.
         ENDIF
      ENDIF
   SELECT ART004
 RETURN .T.
//
STATIC FUNCTION AceptaPro
   SELECT PRO004
      IF EMPTY( nArtProvee )
         cProveedor := SPACE( 30 )
         @ 13,29 SAY SPACE( 30 )
      ELSE
         SEEK ( nArtProvee )
         IF FOUND( )
            cProveedor := PRO004->NOMBRE
            @ 13,29 SAY cProveedor
            SELECT ART004
            RETURN .T.
         ELSE
            SETCOLOR( cCMensa )
            SHOW_MSG( 0,"El Proveedor no existe")
            SETCOLOR( cCPanta )
            RETURN .F.
         ENDIF
      ENDIF
   SELECT ART004
 RETURN .T.
