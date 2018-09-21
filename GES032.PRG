* * * * * * * * * * *
* Programa .........: Gesti¢n para Talleresa de Lacado v1.00
* Subprograma ......: Creaci¢n de Ficheros de Indices.
* Programador ......: Fco. Javier P‚rez Vidal.
* * * * * *
* CrearDatos() : Funci¢n general para la creaci¢n de las bases de datos.
* CrearPro()   : Funci¢n para crear Proveedores.
* CrearFam()   : Funci¢n para crear Familias.
* CrearArt()   : Funci¢n para crear Art¡culos.
* CrearCli()   : Funci¢n para crear Clientes.
* * * * *

MEMVAR cCNormal, cCMenus

//
FUNCTION CrearIndic()
   LOCAL nMenu := 1
   LOCAL cPantalla := SAVESCREEN( 6,13,22,67 )
   LOCAL aFDistrib

   DO WHILE .T.
      CajaTitulo( 6,13,22,67,2," CREACION DE FICHEROS DE INDICES ", "" )
      @  7,15 PROMPT " 1) Creaci¢n de Proveedores                        "
      @  8,15 PROMPT " 2) Creaci¢n de Familias                           "
      @  9,15 PROMPT " 3) Creaci¢n de Art¡culos                          "
      @ 10,15 PROMPT " 4) Creaci¢n de Clientes                           "
      @ 11,15 PROMPT " 5) Creaci¢n de TODOS los Ficheros                 "

      MENU TO nMenu
      DO CASE
         CASE nMenu == 1
              CrearPro()
         CASE nMenu == 2
              CrearFam()
         CASE nMenu == 3
              CrearArt()
         CASE nMenu == 4
              CrearCli()
         CASE nMenu == 5
              CrearPro()
              CrearFam()
              CrearArt()
              CrearCli()
         ENDCASE
         RESTSCREEN( 6,13,22,67,cPantalla )
         RETURN NIL
      ENDDO
 RETURN NIL

//
STATIC FUNCTION CrearPro()
   FIELD CODIGO, NOMBRE

   USE ( "DATOS\PROVEEDO.DBF" ) EXCLUSIVE ALIAS PRO032 NEW
   INDEX ON CODIGO TO ( "DATOS\PROVEEDO.NT1" )
   INDEX ON NOMBRE TO ( "DATOS\PROVEEDO.NT2" )
   PRO032->(DBCLOSEAREA() )
 RETURN NIL

//
STATIC FUNCTION CrearFam()
   FIELD CODIGO, NOMBRE

   USE ( "DATOS\FAMILIAS.DBF" ) EXCLUSIVE ALIAS FAM032 NEW
   INDEX ON CODIGO TO ( "DATOS\FAMILIAS.NT1" )
   INDEX ON NOMBRE TO ( "DATOS\FAMILIAS.NT2" )
   FAM032->(DBCLOSEAREA() )
 RETURN NIL

//
STATIC FUNCTION CrearArt()
   FIELD CODIGO, NOMBRE

   USE ( "DATOS\ARTICU.DBF" ) EXCLUSIVE ALIAS ART032 NEW
   INDEX ON CODIGO TO ( "DATOS\ARTICU.NT1" )
   INDEX ON NOMBRE TO ( "DATOS\ARTICU.NT2" )
   ART032->(DBCLOSEAREA() )
 RETURN NIL

//
STATIC FUNCTION CrearCli()
   FIELD CODIGO, NOMBRE

   USE ( "DATOS\CLIENTES.DBF" ) EXCLUSIVE ALIAS CLI032 NEW
   INDEX ON CODIGO TO ( "DATOS\CLIENTES.NT1" )
   INDEX ON NOMBRE TO ( "DATOS\CLIENTES.NT2" )
   CLI032->(DBCLOSEAREA() )
 RETURN NIL
