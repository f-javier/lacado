* * * * * * * * * * *
* Programa .........: Gesti¢n para Talleres de Lacado v1.00
* Subprograma ......: Creaci¢n de Ficheros de Datos.
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
FUNCTION CrearDatos()
   LOCAL nMenu := 1
   LOCAL cPantalla := SAVESCREEN( 6,13,22,67 )
   LOCAL cPassword := SPACE( 20 )
   LOCAL GetList := {}
   LOCAL cPantAcceso := ""

// Proceso utilizado para pedir una clave de acceso a fin de provenir usos indebidos.
   cPantAcceso := SAVESCREEN( 7,20,16,60 )
   @ 7,20 CLEAR TO 16,60
   CajaTitulo( 7,20,16,60,2," ACCESO RESTRINGIDO ","" )
   @ 10,25 SAY "INTRODUZCA CLAVE DE ACCESO....:"
   @ 13,30 GET cPassword COLOR "B/B"
   READ
   RESTSCREEN( 7,20,16,60,cPantAcceso )
   IF !( cPassword == "JAVIER              " )
      ALERT( ";­­­ A T E N C I O N !!!;;PASSWORD ERRONEO;PROCESO NO AUTORIZADO" )
   ELSE
// Proceso utilizado para crear los ficheros. Se filtra anteriormente para no borrar datos.
      DO WHILE .T.
         CajaTitulo( 6,13,22,67,2," CREACION DE FICHEROS DE DATOS ", "" )
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
    ENDIF
 RETURN NIL

//
STATIC FUNCTION CrearPro()
       LOCAL aFProveedo :={}

       aadd(aFProveedo,{"CODIGO","N",3,0})
       aadd(aFProveedo,{"NOMBRE","C",30,0})
       aadd(aFProveedo,{"DIRECCION","C",30,0})
       aadd(aFProveedo,{"CODPOSTAL","C",5,0})
       aadd(aFProveedo,{"POBLACION","C",25,0})
       aadd(aFProveedo,{"PROVINCIA","C",25,0})
       aadd(aFProveedo,{"TELEFONO","C",15,0})
       aadd(aFProveedo,{"FAX","C",15,0})
       aadd(aFProveedo,{"NIFCIF","C",10,0})
       aadd(aFProveedo,{"CONTACTO","C",30,0})
       aadd(aFProveedo,{"ACUCOMPRAS","N",10,2})
       *
       DBCREATE( "DATOS\PROVEEDO", aFProveedo )
 RETURN NIL

//
STATIC FUNCTION CrearFam()
       LOCAL aFFamilias := {}

       aadd(aFFamilias,{"CODIGO","N",2,0})
       aadd(aFFamilias,{"NOMBRE","C",30,0})
       *
       DBCREATE( "DATOS\FAMILIAS", aFFamilias )
 RETURN NIL

//
STATIC FUNCTION CrearArt()
       LOCAL aFArticu := {}
       aadd(aFArticu,{"CODIGO","N",5,0})
       aadd(aFArticu,{"NOMBRE","C",40,0})
       aadd(aFArticu,{"FAMILIA","N",2,0})
       aadd(aFArticu,{"PROVEEDOR","N",3,0})
       aadd(aFArticu,{"PTSCOSTE","N",8,2})
       aadd(aFArticu,{"PTSVENTA","N",8,2})
       *
       DBCREATE( "DATOS\ARTICU", aFArticu )
 RETURN NIL

//
STATIC FUNCTION CrearCli()
       LOCAL aFClientes := {}

       aadd(aFClientes,{"CODIGO","N",5,0})
       aadd(aFClientes,{"NOMBRE","C",30,0})
       aadd(aFClientes,{"DIRECCION","C",30,0})
       aadd(aFClientes,{"CODPOSTAL","C",5,0})
       aadd(aFClientes,{"POBLACION","C",25,0})
       aadd(aFClientes,{"PROVINCIA","C",25,0})
       aadd(aFClientes,{"TELEFONO","C",15,0})
       aadd(aFClientes,{"FAX","C",15,0})
       aadd(aFClientes,{"NIFCIF","C",10,0})
       aadd(aFClientes,{"CONTACTO","C",30,0})
       aadd(aFClientes,{"ACUVENTAS","N",10,2})
       *
       DBCREATE( "DATOS\CLIENTES", aFClientes )
 RETURN NIL
