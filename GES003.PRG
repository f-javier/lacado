* * * * * * * * * * *
* Programa .........: Gesti¢n para Talleres de Lacado v1.00
* Subprograma ......: Mantenimiento de Clientes.
* Programador ......: Fco. Javier P‚rez Vidal.
* * * * * *
* AltasCli()  : Funci¢n para las ALTAS DE CLIENTE.
* BajasCli()  : Funci¢n para las BAJAS DE CLIENTES.
* ConsulCli() : Funci¢n para las CONSULTAS DE CLIENTES.
* ModifCli()  : Funci¢n para las MODIFICACIONES DE CLIENTES.
* LCli_Cod()  : Funci¢n para LISTADO DE CLIENTES POR CODIGO.
* LCli_Nom()  : Funci¢n para LISTADO DE CLIENTES POR NOMBRE.
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
   STATIC nCliCodigo
   STATIC cCliNombre
   STATIC cCliDirecc
   STATIC cCliCodPos
   STATIC cCliPoblac
   STATIC cCliProvin
   STATIC cCliTelefo
   STATIC cCliFAX
   STATIC cCliNIFCIF
   STATIC cCliContac
   STATIC nCliAcuVen

//
FUNCTION AltasCli( )
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
      CajaTitulo( 5,8,19,70,2," Altas de Clientes "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 7,23 GET nCliCodigo PICTURE "99999"
         READ
         IF !EMPTY( nCliCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nCliCodigo )
            IF FOUND( )
               SETCOLOR( cCMensa )
               SHOW_MSG( 0,"El registro ya existe")
               SETCOLOR( cCPanta )
            ELSE
                  DBAPPEND( )
                  IF NETERR( )
                     ALERT( "­­­ ACCESO DENEGADO !!!;;No se puede a¤adir el registro" )
                  ELSE
                     CLI003->Codigo := nCliCodigo
                     CLI003->( DBCOMMIT() )
                     DO PedirDatos
                     IF !EMPTY( nCliCodigo ) .AND. LASTKEY( ) != K_ESC
                        SET( _SET_CONFIRM, .F. )
                        @ 17,25 SAY "¨Confirma los datos (S/N)?" GET cCorrecto;
                                PICTURE "!" VALID( cCorrecto $ "SN" )
                        READ
                        @ 17,25 SAY "                               "
                        IF cCorrecto == "S"
                           DO Salvar
                           CLI003->( DBCOMMIT( ) )
                           UNLOCK
                           CLI003->( DBCOMMIT() )
                           SETCOLOR( cCMensa )
                           SHOW_MSG( 0,"Se ha salvado el registro" )
                           SETCOLOR( cCPanta )
                        ELSE
                           DBDELETE( )
                           CLI003->( DBCOMMIT( ) )
                        ENDIF
                        SET( _SET_CONFIRM, .T. )
                        cCorrecto := " "
                     ELSE
                        DBDELETE( )
                        CLI003->( DBCOMMIT( ) )
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
FUNCTION BajasCli()
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
      CajaTitulo( 5,8,19,70,2," Bajas de Clientes "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 7,23 GET nCliCodigo PICTURE "99999"
         READ
         IF !EMPTY( nCliCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nCliCodigo )
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
                     CLI003->( DBCOMMIT() )
                     SETCOLOR( cCMensa )
                     SHOW_MSG( 0,"Se ha borrado el registro" )
                     SETCOLOR( cCPanta )
                  ELSE
                     UNLOCK
                     CLI003->( DBCOMMIT() )
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
FUNCTION ConsulCli()
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
      CajaTitulo( 5,8,19,70,2," Consultas de Clientes "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 7,23 GET nCliCodigo PICTURE "99999"
         READ
         IF !EMPTY( nCliCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nCliCodigo )
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
FUNCTION ModifCli()
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
      CajaTitulo( 5,8,19,70,2," Modificaciones de Clientes "," F5=Buscar ÍÍÍÍ F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 7,23 GET nCliCodigo PICTURE "99999"
         READ
         IF !EMPTY( nCliCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nCliCodigo )
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
                  IF !EMPTY( nCliCodigo ) .AND. LASTKEY( ) != K_ESC
                     SET( _SET_CONFIRM, .F. )
                     @ 17,25 SAY "¨Confirma los datos (S/N)?" GET cCorrecto;
                             PICTURE "!" VALID( cCorrecto $ "SN" )
                     READ
                     @ 17,25 SAY "                               "
                     IF cCorrecto == "S"
                        DO Salvar
                        CLI003->( DBCOMMIT() )
                        SETCOLOR( cCMensa )
                        SHOW_MSG( 0,"Se ha salvado el registro" )
                        SETCOLOR( cCPanta )
                     ELSE
                        UNLOCK
                        CLI003->( DBCOMMIT() )
                     ENDIF
                     SET( _SET_CONFIRM, .T. )
                     cCorrecto := " "
                  ELSE
                     UNLOCK
                     CLI003->( DBCOMMIT() )
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
FUNCTION LCli_Cod
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
      CajaTitulo( 5,15,17,65,2," Listado de Clientes por C¢digo "," ESC = Salir ÍÍÍÍÍÍÍÍ132 Columnas " )
      @  8,25 SAY "C¢digo desde:" GET nDesde PICTURE "99999"
      @ 10,25 SAY "C¢digo Hasta:" GET nHasta PICTURE "99999"
      @ 12,25 SAY "Destino del listado(P/I):" GET cDestino ;
              PICTURE "!" VALID( cDestino $ "PI" )
      @ 14,25 SAY "¨Confirma los datos(S/N)?" GET cCorrecto ;
              PICTURE "!" VALID( cCorrecto $ "SN" )
      READ

      IF cCorrecto == "S"
         IF cDestino == "P"
            SET FILTER TO CLI003->codigo >= nDesde .AND. ;
                          CLI003->codigo <= nHasta
            DBGOTOP( )
            CajaTitulo( 3,0,24,79,2," Listado de Clientes por C¢digo ",;
                                     " Pulse <ESC> para Salir " )
            oListado := TBrowseDB( 4,1,23,78 )
            oListado:headSep := "Í"
            oCol := TBColumnNew( "C¢digo", { || CLI003->CODIGO } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Nombre", { || CLI003->NOMBRE } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Direcci¢n", { || CLI003->DIRECCION } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "C.P.", { || CLI003->CODPOSTAL } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Poblaci¢n", { || CLI003->POBLACION } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Prov¡ncia", { || CLI003->PROVINCIA } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Tel‚fono", { || CLI003->TELEFONO } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "FAX", { || CLI003->FAX } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "NIF/CIF", { || CLI003->NIFCIF } )
            oListado:addCOlumn( oCol )
            oCol := TBColumnNew( "Persona de Contacto", { || CLI003->CONTACTO } )
            oListado:addColumn( oCol )
	    oCol := TBColumnNew( "Acum. Ventas",;
		    { || TRANSFORM((CLI003->ACUVENTAS), "@EZ 9,999,999.99") } )
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
            REPORT FORM "reports\gescli01.frm" ;
                   FOR CLI003->codigo >= nDesde .AND. ;
                       CLI003->codigo <= nHasta ;
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
FUNCTION LCli_Nom
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
      CajaTitulo( 5,14,17,68,2," Listado de Clientes por Nombre "," ESC = Salir ÍÍÍÍÍÍÍÍ 132 Columnas " )
      @  8,17 SAY "Cliente desde:" GET cDesde PICTURE "@K!"
      @ 10,17 SAY "Cliente Hasta:" GET cHasta PICTURE "@K!"
      @ 12,25 SAY "Destino del listado(P/I):" GET cDestino ;
              PICTURE "!" VALID( cDestino $ "PI" )
      @ 14,25 SAY "¨Confirma los datos(S/N)?" GET cCorrecto ;
              PICTURE "!" VALID( cCorrecto $ "SN" )
      READ

      IF cCorrecto == "S"
         IF cDestino == "P"
            SET FILTER TO CLI003->nombre >= cDesde .AND. ;
                          CLI003->nombre <= cHasta
            DBGOTOP( )
            CajaTitulo( 3,0,24,79,2," Listado de Clientes por Nombre ",;
                                     " Pulse <ESC> para Salir " )
            oListado := TBrowseDB( 4,1,23,78 )
            oListado:headSep := "Í"
            oCol := TBColumnNew( "Nombre", { || CLI003->NOMBRE } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "C¢digo", { || CLI003->CODIGO } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Direcci¢n", { || CLI003->DIRECCION } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "C.P.", { || CLI003->CODPOSTAL } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Poblaci¢n", { || CLI003->POBLACION } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Prov¡ncia", { || CLI003->PROVINCIA } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Tel‚fono", { || CLI003->TELEFONO } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "FAX", { || CLI003->FAX } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "NIF/CIF", { || CLI003->NIFCIF } )
            oListado:addCOlumn( oCol )
            oCol := TBColumnNew( "Persona de Contacto", { || CLI003->CONTACTO } )
            oListado:addColumn( oCol )
	    oCol := TBColumnNew( "Acum. Ventas", ;
		    { || TRANSFORM((CLI003->ACUVENTAS), "@EZ 9,999,999.99") } )
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
            REPORT FORM "reports\gescli02.frm" ;
                   FOR CLI003->nombre >= cDesde .AND. ;
                       CLI003->nombre <= cHasta ;
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
   USE ( "DATOS\CLIENTES.DBF" ) INDEX ( "DATOS\CLIENTES.NT1" ) ,;
       ( "DATOS\CLIENTES.NT2" ) SHARED ALIAS CLI003 NEW
   IF NETERR( )
      ALERT( "­­­ ACCESO DENEGADO !!!;;El fichero de CLIENTES est  siendo utilizado;en modo exclusivo por otro usuario" )
      RETURN .F.
      DBSETORDER( 1 )
   ENDIF
 RETURN .T.

//
STATIC PROCEDURE CerrarBBDD
   CLI003->( DBCLOSEAREA() )

//
STATIC PROCEDURE InitVars
   nCliCodigo := 0
   cCliNombre := SPACE( 30 )
   cCliDirecc := SPACE( 30 )
   cCliCodPos := SPACE( 5 )
   cCliPoblac := SPACE( 25 )
   cCliProvin := SPACE( 25 )
   cCliTelefo := SPACE( 15 )
   cCliFAX    := SPACE( 15 )
   cCliNIFCIF := SPACE( 10 )
   cCliContac := SPACE( 30 )
   nCliAcuVen := 0.0

//
STATIC PROCEDURE Literales
   @  7,11 SAY "C¢digo...: [     ]"
   @  8,11 SAY "Nombre...: [                              ]"
   @  9,11 SAY "Direcci¢n: [                              ]"
   @ 10,11 SAY "Poblaci¢n: [     ] [                         ]"
   @ 11,11 SAY "Prov¡ncia: [                         ]"
   @ 12,11 SAY "Tel‚fono.: [               ]   FAX: [               ]"
   @ 13,11 SAY "NIF/CIF..: [          ]"
   @ 14,11 SAY "Persona de Contacto.: [                              ]"
   @ 15,11 SAY "Acumulado de Ventas.: [            ]"

//
STATIC PROCEDURE PedirDatos
   LOCAL getlist := {}
   @  8,23 GET cCliNombre PICTURE "@!"
   @  9,23 GET cCliDirecc PICTURE "@!"
   @ 10,23 GET cCliCodPos PICTURE "99999"
   @ 10,31 GET cCliPoblac PICTURE "@!"
   @ 11,23 GET cCliProvin PICTURE "@!"
   @ 12,23 GET cCliTelefo
   @ 12,48 GET cCliFAX
   @ 13,23 GET cCliNIFCIF
   @ 14,34 GET cCliContac PICTURE "@!"
   @ 15,34 GET nCliAcuVen PICTURE "@E 9,999,999.99"
   READ

//
STATIC PROCEDURE MostrarDatos
   @  7,23 SAY nCliCodigo PICTURE "99999"
   @  8,23 SAY cCliNombre
   @  9,23 SAY cCliDirecc
   @ 10,23 SAY cCliCodPos
   @ 10,31 SAY cCliPoblac
   @ 11,23 SAY cCliProvin
   @ 12,23 SAY cCliTelefo
   @ 12,48 SAY cCliFAX
   @ 13,23 SAY cCliNIFCIF
   @ 14,34 SAY cCliContac
   @ 15,34 SAY nCliAcuVen PICTURE "@E 9,999,999.99"

//
STATIC PROCEDURE Salvar
   CLI003->Codigo := nCliCodigo
   CLI003->Nombre := cCliNombre
   CLI003->Direccion := cCliDirecc
   CLI003->CodPostal := cCliCodPos
   CLI003->Poblacion := cCliPoblac
   CLI003->Provincia := cCliProvin
   CLI003->Telefono := cCliTelefo
   CLI003->FAX := cCliFax
   CLI003->NIFCIF := cCliNifCif
   CLI003->Contacto := cCliContac
   CLI003->AcuVentas := nCliAcuVen

//
STATIC PROCEDURE Recuperar
   nCliCodigo := CLI003->Codigo
   cCliNombre := CLI003->Nombre
   cCliDirecc := CLI003->Direccion
   cCliCodPos := CLI003->CodPostal
   cCliPoblac := CLI003->Poblacion
   cCliProvin := CLI003->Provincia
   cCliTelefo := CLI003->Telefono
   cCliFAX := CLI003->FAX
   cCliNIFCIF := CLI003->NIFCIF
   cCliContac := CLI003->Contacto
   nCliAcuVen := CLI003->AcuVentas

//
STATIC FUNCTION Buscar( cProcName, nProcLine, cReadVar )
   LOCAL areactual := SELECT( )
   LOCAL cPantalla := SAVESCREEN( 3,0,24,79 )
   LOCAL cABuscar  := SPACE( 30 )
   LOCAL GetList   := {}
   LOCAL oBuscar, oCol, nTecla
   LOCAL lMas      := .T.

   IF cReadVar == "NCLICODIGO"
      CajaTitulo( 10,20,12,60,2," Cliente a buscar: " )
      @ 11,25 GET cABuscar PICTURE "@!"
      READ
      IF LASTKEY( ) != K_ESC
         DBSETORDER( 2 )
         IF RECCOUNT( ) != 0
            SEEK( cABuscar )
         ENDIF
      ENDIF
      CajaTitulo( 3,0,24,40,2," Visualizaci¢n de Clientes ", " <ESC> Salir ÍÍ <INTRO> Seleccionar " )
      oBuscar := TBrowseDB( 4,1,23,39 )
      oBuscar:headSep := "Í"
      oCol := TBColumnNew( "Nombre", { || CLI003->NOMBRE } )
      oBuscar:addColumn( oCol )
      oCol := TBColumnNew( "C¢digo", { || CLI003->CODIGO } )
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
                    nCliCodigo := CLI003->Codigo
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

   IF cReadVar == "NCLICODIGO"
      DBSETORDER( 2 )
      IF RECCOUNT( ) != 0
         DBGOTOP( )
      ENDIF
      CajaTitulo( 3,0,24,40,2," Visualizaci¢n de Clientes ", " <ESC> Salir ÍÍ <INTRO> Seleccionar " )
      oVisualizar := TBrowseDB( 4,1,23,39 )
      oVisualizar:headSep := "Í"
      oCol:= TBColumnNew( "Nombre", { || CLI003->NOMBRE } )
      oVisualizar:addColumn( oCol )
      oCol := TBColumnNew( "C¢digo", { || CLI003->CODIGO } )
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
                    nCliCodigo := CLI003->Codigo
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
