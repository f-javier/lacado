* * * * * * * * * * *
* Programa .........: Gesti¢n para Talleres de Lacado v1.00
* Subprograma ......: Mantenimiento de Proveedores.
* Programador ......: Fco. Javier P‚rez Vidal.
* * * * * *
* AltasPro()  : Funci¢n para las ALTAS DE PROVEEDORES.
* BajasPro()  : Funci¢n para las BAJAS DE PROVEEDORES.
* ConsulPro() : Funci¢n para las CONSULTAS DE PROVEEDORES.
* ModifPro()  : Funci¢n para las MODIFICACIONES DE PROVEEDORES.
* LPro_Cod()  : Funci¢n para LISTADO DE PROVEEDORES POR CODIGO.
* LPro_Nom()  : Funci¢n para LISTADO DE PROVEEDORES POR NOMBRE.
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
   STATIC nProCodigo
   STATIC cProNombre
   STATIC cProDirecc
   STATIC cProCodPos
   STATIC cProPoblac
   STATIC cProProvin
   STATIC cProTelefo
   STATIC cProFAX
   STATIC cProNIFCIF
   STATIC cProContac
   STATIC nProAcuCom

//
FUNCTION AltasPro( )
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
      CajaTitulo( 5,8,19,70,2," Altas de Proveedores "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 7,23 GET nProCodigo PICTURE "999"
         READ
         IF !EMPTY( nProCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nProCodigo )
            IF FOUND( )
               SETCOLOR( cCMensa )
               SHOW_MSG( 0,"El registro ya existe")
               SETCOLOR( cCPanta )
            ELSE
                  DBAPPEND( )
                  IF NETERR( )
                     ALERT( "­­­ ACCESO DENEGADO !!!;;No se puede a¤adir el registro" )
                  ELSE
                     PRO001->Codigo := nProCodigo
                     PRO001->( DBCOMMIT() )
                     DO PedirDatos
                     IF !EMPTY( nProCodigo ) .AND. LASTKEY( ) != K_ESC
                        SET( _SET_CONFIRM, .F. )
                        @ 17,25 SAY "¨Confirma los datos (S/N)?" GET cCorrecto;
                                PICTURE "!" VALID( cCorrecto $ "SN" )
                        READ
                        @ 17,25 SAY "                               "
                        IF cCorrecto == "S"
                           DO Salvar
                           PRO001->( DBCOMMIT( ) )
                           UNLOCK
                           PRO001->( DBCOMMIT() )
                           SETCOLOR( cCMensa )
                           SHOW_MSG( 0,"Se ha salvado el registro" )
                           SETCOLOR( cCPanta )
                        ELSE
                           DBDELETE( )
                           PRO001->( DBCOMMIT( ) )
                        ENDIF
                        SET( _SET_CONFIRM, .T. )
                        cCorrecto := " "
                     ELSE
                        DBDELETE( )
                        PRO001->( DBCOMMIT( ) )
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
FUNCTION BajasPro()
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
      CajaTitulo( 5,8,19,70,2," Bajas de Provvedores "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 7,23 GET nProCodigo PICTURE "999"
         READ
         IF !EMPTY( nProCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nProCodigo )
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
                  @ 17,25 SAY "¨Confirma la baja (S/N)?" GET cCorrecto;
                              PICTURE "!" VALID( cCorrecto $ "SN" )
                  READ
                  @ 17,25 SAY "                             "
                  IF cCorrecto == "S"
                     DBDELETE( )
                     PRO001->( DBCOMMIT() )
                     SETCOLOR( cCMensa )
                     SHOW_MSG( 0,"Se ha borrado el registro" )
                     SETCOLOR( cCPanta )
                  ELSE
                     UNLOCK
                     PRO001->( DBCOMMIT() )
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
FUNCTION ConsulPro()
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
      CajaTitulo( 5,8,19,70,2," Consultas de Proveedores "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 7,23 GET nProCodigo PICTURE "999"
         READ
         IF !EMPTY( nProCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nProCodigo )
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
FUNCTION ModifPro()
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
      CajaTitulo( 5,8,19,70,2," Modificaciones de Proveedores "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 7,23 GET nProCodigo PICTURE "999"
         READ
         IF !EMPTY( nProCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nProCodigo )
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
                  IF !EMPTY( nProCodigo ) .AND. LASTKEY( ) != K_ESC
                     SET( _SET_CONFIRM, .F. )
                     @ 17,25 SAY "¨Confirma los datos (S/N)?" GET cCorrecto;
                             PICTURE "!" VALID( cCorrecto $ "SN" )
                     READ
                     @ 17,25 SAY "                               "
                     IF cCorrecto == "S"
                        DO Salvar
                        PRO001->( DBCOMMIT() )
                        SETCOLOR( cCMensa )
                        SHOW_MSG( 0,"Se ha salvado el registro" )
                        SETCOLOR( cCPanta )
                     ELSE
                        UNLOCK
                        PRO001->( DBCOMMIT() )
                     ENDIF
                     SET( _SET_CONFIRM, .T. )
                     cCorrecto := " "
                  ELSE
                     UNLOCK
                     PRO001->( DBCOMMIT() )
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
FUNCTION LPro_Cod
   LOCAL cPantalla  := SAVESCREEN( 3,0,24,79 )
   LOCAL GetList    := {}
   LOCAL nDesde    := 0
   LOCAL nHasta    := 999
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
      CajaTitulo( 5,15,17,65,2," Listado de Proveedores por C¢digo "," ESC = Salir ÍÍÍÍÍÍÍÍ 132 Columnas " )
      @  8,25 SAY "C¢digo desde:" GET nDesde PICTURE "999"
      @ 10,25 SAY "C¢digo Hasta:" GET nHasta PICTURE "999"
      @ 12,25 SAY "Destino del listado(P/I):" GET cDestino ;
              PICTURE "!" VALID( cDestino $ "PI" )
      @ 14,25 SAY "¨Confirma los datos(S/N)?" GET cCorrecto ;
              PICTURE "!" VALID( cCorrecto $ "SN" )
      READ

      IF cCorrecto == "S"
         IF cDestino == "P"
            SET FILTER TO PRO001->codigo >= nDesde .AND. ;
                          PRO001->codigo <= nHasta
            DBGOTOP( )
            CajaTitulo( 3,0,24,79,2," Listado de Proveedores por C¢digo ",;
                                     " Pulse <ESC> para Salir " )
            oListado := TBrowseDB( 4,1,23,78 )
            oListado:headSep := "Í"
            oCol := TBColumnNew( "C¢digo", { || PRO001->CODIGO } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Nombre", { || PRO001->NOMBRE } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Direcci¢n", { || PRO001->DIRECCION } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "C.P.", { || PRO001->CODPOSTAL } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Poblaci¢n", { || PRO001->POBLACION } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Prov¡ncia", { || PRO001->PROVINCIA } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Tel‚fono", { || PRO001->TELEFONO } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "FAX", { || PRO001->FAX } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "NIF/CIF", { || PRO001->NIFCIF } )
            oListado:addCOlumn( oCol )
            oCol := TBColumnNew( "Persona de Contacto", { || PRO001->CONTACTO } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Acum. Compras",;
                    { || TRANSFORM((PRO001->ACUCOMPRAS), "@EZ 9,999,999.99") } )
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
            REPORT FORM "reports\gespro01.frm" ;
                   FOR PRO001->codigo >= nDesde .AND. ;
                       PRO001->codigo <= nHasta ;
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
FUNCTION LPro_Nom
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
      CajaTitulo( 5,14,17,68,2," Listado de Proveedores por Nombre "," ESC = Salir ÍÍÍÍÍÍÍÍ 132 Columnas " )
      @  8,17 SAY "Proveedor desde:" GET cDesde PICTURE "@K!"
      @ 10,17 SAY "Proveedor Hasta:" GET cHasta PICTURE "@K!"
      @ 12,25 SAY "Destino del listado(P/I):" GET cDestino ;
              PICTURE "!" VALID( cDestino $ "PI" )
      @ 14,25 SAY "¨Confirma los datos(S/N)?" GET cCorrecto ;
              PICTURE "!" VALID( cCorrecto $ "SN" )
      READ

      IF cCorrecto == "S"
         IF cDestino == "P"
            SET FILTER TO PRO001->nombre >= cDesde .AND. ;
                          PRO001->nombre <= cHasta
            DBGOTOP( )
            CajaTitulo( 3,0,24,79,2," Listado de Proveedores por Nombre ",;
                                     " Pulse <ESC> para Salir " )
            oListado := TBrowseDB( 4,1,23,78 )
            oListado:headSep := "Í"
            oCol := TBColumnNew( "Nombre", { || PRO001->NOMBRE } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "C¢digo", { || PRO001->CODIGO } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Direcci¢n", { || PRO001->DIRECCION } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "C.P.", { || PRO001->CODPOSTAL } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Poblaci¢n", { || PRO001->POBLACION } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Prov¡ncia", { || PRO001->PROVINCIA } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Tel‚fono", { || PRO001->TELEFONO } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "FAX", { || PRO001->FAX } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "NIF/CIF", { || PRO001->NIFCIF } )
            oListado:addCOlumn( oCol )
            oCol := TBColumnNew( "Persona de Contacto", { || PRO001->CONTACTO } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Acum. Compras", ;
                    { || TRANSFORM((PRO001->ACUCOMPRAS), "@EZ 9,999,999.99") } )
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
            REPORT FORM "reports\gespro02.frm" ;
                   FOR PRO001->nombre >= cDesde .AND. ;
                       PRO001->nombre <= cHasta ;
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
   USE ( "DATOS\PROVEEDO.DBF" ) INDEX ( "DATOS\PROVEEDO.NT1" ) ,;
       ( "DATOS\PROVEEDO.NT2" ) SHARED ALIAS PRO001 NEW
   IF NETERR( )
      ALERT( "­­­ ACCESO DENEGADO !!!;;El fichero de PROVEEDORES est  siendo utilizado;en modo exclusivo por otro usuario" )
      RETURN .F.
      DBSETORDER( 1 )
   ENDIF
 RETURN .T.

//
STATIC PROCEDURE CerrarBBDD
   PRO001->( DBCLOSEAREA() )

//
STATIC PROCEDURE InitVars
   nProCodigo := 0
   cProNombre := SPACE( 30 )
   cProDirecc := SPACE( 30 )
   cProCodPos := SPACE( 5 )
   cProPoblac := SPACE( 25 )
   cProProvin := SPACE( 25 )
   cProTelefo := SPACE( 15 )
   cProFAX    := SPACE( 15 )
   cProNIFCIF := SPACE( 10 )
   cProContac := SPACE( 30 )
   nProAcuCom := 0.0

//
STATIC PROCEDURE Literales
   @  7,11 SAY "C¢digo...: [   ]"
   @  8,11 SAY "Nombre...: [                              ]"
   @  9,11 SAY "Direcci¢n: [                              ]"
   @ 10,11 SAY "Poblaci¢n: [     ] [                         ]"
   @ 11,11 SAY "Prov¡ncia: [                         ]"
   @ 12,11 SAY "Tel‚fono.: [               ]   FAX: [               ]"
   @ 13,11 SAY "NIF/CIF..: [          ]"
   @ 14,11 SAY "Persona de Contacto.: [                              ]"
   @ 15,11 SAY "Acumulado de Compras: [            ]"

//
STATIC PROCEDURE PedirDatos
   LOCAL getlist := {}
   @  8,23 GET cProNombre PICTURE "@!"
   @  9,23 GET cProDirecc PICTURE "@!"
   @ 10,23 GET cProCodPos PICTURE "99999"
   @ 10,31 GET cProPoblac PICTURE "@!"
   @ 11,23 GET cProProvin PICTURE "@!"
   @ 12,23 GET cProTelefo
   @ 12,48 GET cProFAX
   @ 13,23 GET cProNIFCIF
   @ 14,34 GET cProContac PICTURE "@!"
   @ 15,34 GET nProAcuCom PICTURE "@E 9,999,999.99"
   READ

//
STATIC PROCEDURE MostrarDatos
   @  7,23 SAY nProCodigo PICTURE "999"
   @  8,23 SAY cProNombre
   @  9,23 SAY cProDirecc
   @ 10,23 SAY cProCodPos
   @ 10,31 SAY cProPoblac
   @ 11,23 SAY cProProvin
   @ 12,23 SAY cProTelefo
   @ 12,48 SAY cProFAX
   @ 13,23 SAY cProNIFCIF
   @ 14,34 SAY cProContac
   @ 15,34 SAY nProAcuCom PICTURE "@E 9,999,999.99"

//
STATIC PROCEDURE Salvar
   PRO001->Codigo := nProCodigo
   PRO001->Nombre := cProNombre
   PRO001->Direccion := cProDirecc
   PRO001->CodPostal := cProCodPos
   PRO001->Poblacion := cProPoblac
   PRO001->Provincia := cProProvin
   PRO001->Telefono := cProTelefo
   PRO001->FAX := cProFax
   PRO001->NIFCIF := cProNifCif
   PRO001->Contacto := cProContac
   PRO001->AcuCompras := nProAcuCom

//
STATIC PROCEDURE Recuperar
   nProCodigo := PRO001->Codigo
   cProNombre := PRO001->Nombre
   cProDirecc := PRO001->Direccion
   cProCodPos := PRO001->CodPostal
   cProPoblac := PRO001->Poblacion
   cProProvin := PRO001->Provincia
   cProTelefo := PRO001->Telefono
   cProFAX := PRO001->FAX
   cProNIFCIF := PRO001->NIFCIF
   cProContac := PRO001->Contacto
   nProAcuCom := PRO001->AcuCompras

//
STATIC FUNCTION Buscar( cProcName, nProcLine, cReadVar )
   LOCAL areactual := SELECT( )
   LOCAL cPantalla := SAVESCREEN( 3,0,24,79 )
   LOCAL cABuscar  := SPACE( 30 )
   LOCAL GetList   := {}
   LOCAL oBuscar, oCol, nTecla
   LOCAL lMas      := .T.

   IF cReadVar == "NPROCODIGO"
      CajaTitulo( 10,20,12,60,2," Proveedor a buscar: " )
      @ 11,25 GET cABuscar PICTURE "@!"
      READ
      IF LASTKEY( ) != K_ESC
         DBSETORDER( 2 )
         IF RECCOUNT( ) != 0
            SEEK( cABuscar )
         ENDIF
      ENDIF
      CajaTitulo( 3,0,24,40,2," Visualizaci¢n de Proveedores ", " <ESC> Salir ÍÍ <INTRO> Seleccionar " )
      oBuscar := TBrowseDB( 4,1,23,39 )
      oBuscar:headSep := "Í"
      oCol := TBColumnNew( "Nombre", { || PRO001->NOMBRE } )
      oBuscar:addColumn( oCol )
      oCol := TBColumnNew( "C¢digo", { || PRO001->CODIGO } )
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
                    nproCodigo := PRO001->Codigo
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

   IF cReadVar == "NPROCODIGO"
      DBSETORDER( 2 )
      IF RECCOUNT( ) != 0
         DBGOTOP( )
      ENDIF
      CajaTitulo( 3,0,24,40,2," Visualizaci¢n de Proveedores ", " <ESC> Salir ÍÍ <INTRO> Seleccionar " )
      oVisualizar := TBrowseDB( 4,1,23,39 )
      oVisualizar:headSep := "Í"
      oCol:= TBColumnNew( "Nombre", { || PRO001->NOMBRE } )
      oVisualizar:addColumn( oCol )
      oCol := TBColumnNew( "C¢digo", { || PRO001->CODIGO } )
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
                    nProCodigo := PRO001->Codigo
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
      DO MostrarDatos
   ENDDO
   @ 17,15 SAY "                                                 "
   @ 18,10 SAY SPACE( 60 )
   SETCURSOR( 1 )
 RETURN NIL
