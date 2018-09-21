* * * * * * * * * * *
* Programa .........: Gestion para Talleres de Lacado v1.00
* Subprograma ......: Creacion de Ficheros de Indices.
* Programador ......: Fco. Javier Perez Vidal.
* * * * * *
* CrearDatos() : Funcion general para la creacion de las bases de datos.
* CrearPro()   : Funcion para crear Proveedores.
* CrearFam()   : Funcion para crear Familias.
* CrearArt()   : Funcion para crear Articulos.
* CrearCli()   : Funcion para crear Clientes.
* * * * *

MEMVAR cCNormal, cCMenus

//
FUNCTION CrearIndic()
   LOCAL nMenu := 1
   LOCAL cPantalla := SAVESCREEN( 6,13,22,67 )
   LOCAL aFDistrib

   DO WHILE .T.
      CajaTitulo( 6,13,22,67,2," CREACION DE FICHEROS DE INDICES ", "" )
      @  7,15 PROMPT " 1) Creacion de Proveedores                        "
      @  8,15 PROMPT " 2) Creacion de Familias                           "
      @  9,15 PROMPT " 3) Creacion de Articulos                          "
      @ 10,15 PROMPT " 4) Creacion de Clientes                           "
      @ 11,15 PROMPT " 5) Creacion de TODOS los Ficheros                 "

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
