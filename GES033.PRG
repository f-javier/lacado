* * * * * * * * * * *
* Programa .........: Gesti¢n para Talleres de Lacado v1.00
* Subprograma ......: Compactaci¢n y Reindexaci¢n de Ficheros.
* Programador ......: Fco. Javier P‚rez Vidal.
* * * * * *
* Compactar()  : Funci¢n general para la compactaci¢n de las bases de datos.
* CompactPro() : Funci¢n para compactar Proveedores.
* CompactFam() : Funci¢n para compactar Familias.
* CompactArt() : Funci¢n para compactar Art¡culos.
* CompactCli() : Funci¢n para compactar Clientes.
* * * * *

MEMVAR cCNormal, cCMenus

//
FUNCTION Compactar()
   LOCAL nMenu := 1
   LOCAL cPantalla := SAVESCREEN( 6,13,22,67 )
   LOCAL aFDistrib

   DO WHILE .T.
      CajaTitulo( 6,13,22,67,2," COMPACTACION DE FICHEROS DE DATOS ", "" )
      @  7,15 PROMPT " 1) Compactaci¢n de Proveedores                    "
      @  8,15 PROMPT " 2) Compactaci¢n de Familias                       "
      @  9,15 PROMPT " 3) Compactaci¢n de Art¡culos                      "
      @ 10,15 PROMPT " 4) Compactaci¢n de Clientes                       "
      @ 11,15 PROMPT " 5) Compactaci¢n de TODOS los Ficheros             "

      MENU TO nMenu
      DO CASE
         CASE nMenu == 1
              CompactPro()
         CASE nMenu == 2
              CompactFam()
         CASE nMenu == 3
              CompactArt()
         CASE nMenu == 4
              CompactCli()
         CASE nMenu == 5
              CompactPro()
              CompactFam()
              CompactArt()
              CompactCli()
         ENDCASE
         RESTSCREEN( 6,13,22,67,cPantalla )
         RETURN NIL
      ENDDO
 RETURN NIL

//
STATIC FUNCTION CompactPro()
   FIELD CODIGO, NOMBRE

   USE ( "DATOS\PROVEEDO.DBF" ) EXCLUSIVE ALIAS PRO033 NEW
   PACK
   INDEX ON CODIGO TO ( "DATOS\PROVEEDO.NT1" )
   INDEX ON NOMBRE TO ( "DATOS\PROVEEDO.NT2" )
   PRO033->(DBCLOSEAREA() )
 RETURN NIL

//
STATIC FUNCTION CompactFam()
   FIELD CODIGO, NOMBRE

   USE ( "DATOS\FAMILIAS.DBF" ) EXCLUSIVE ALIAS FAM033 NEW
   PACK
   INDEX ON CODIGO TO ( "DATOS\FAMILIAS.NT1" )
   INDEX ON NOMBRE TO ( "DATOS\FAMILIAS.NT2" )
   FAM033->(DBCLOSEAREA() )
 RETURN NIL

//
STATIC FUNCTION CompactArt()
   FIELD CODIGO, NOMBRE

   USE ( "DATOS\ARTICU.DBF" ) EXCLUSIVE ALIAS ART033 NEW
   PACK
   INDEX ON CODIGO TO ( "DATOS\ARTICU.NT1" )
   INDEX ON NOMBRE TO ( "DATOS\ARTICU.NT2" )
   ART033->(DBCLOSEAREA() )
 RETURN NIL

//
STATIC FUNCTION CompactCli()
   FIELD CODIGO, NOMBRE

   USE ( "DATOS\CLIENTES.DBF" ) EXCLUSIVE ALIAS CLI033 NEW
   PACK
   INDEX ON CODIGO TO ( "DATOS\CLIENTES.NT1" )
   INDEX ON NOMBRE TO ( "DATOS\CLIENTES.NT2" )
   CLI033->(DBCLOSEAREA() )
 RETURN NIL
