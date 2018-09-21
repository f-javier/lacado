// ---------------------------------------------------------------------------
// Funci¢n ....: CajaTitulo.
// Descripci¢n : Funci¢n que nos muestra en pantalla un cuadro con un
//               mensaje en la cabecera y en el pie del mismo.
// Sintaxis ...: CajaTitulo( <expN1>,<expN2>,<expN3>,<expN4>,<expN5>,<expC1>,
//                           <expC2> )
//               Donde <exp1>, <exp2>, <exp3> y <exp4> son las coordenadas
//               del cuadrado. <exp5> es el tipo de cuadro: 1 = sencillo y
//               2 = doble. <expC1> es la cadena que aparecer† como t°tulo en
//               el cuadro. <expC2> es la cadena que aparecer† como pie en el
//               cuadro.
// Ejemplo ....: CajaTitulo( 1, 1, 5, 79, 1, "T°tulo Superior",
//                         "Titulo Inferior" )
// Autor ......: Fco. Javier PÇrez Vidal.
// F. Creaci¢n : Abril de 1995.
// F. Revisi¢n : Mayo de 1995.
// ---------------------------------------------------------------------------
function CajaTitulo( x1, y1, x2, y2, nTipo, cMensaje1, cMensaje2)
   @ x1,y1 clear to x2,y2
   if nTipo == 1
      @ x1,y1 to x2,y2
   else
      @ x1,y1 to x2,y2 double
   endif
   if cMensaje1 != NIL
      @ x1, y1+int( ( ( y2-y1 )-len( cMensaje1 ) )/2 ) say cMensaje1
   endif
   if cMensaje2 != NIL
      @ x2, y1+int( ( ( y2-y1 )-len( cMensaje2 ) )/2 ) say cMensaje2
   endif
return nil

// ---------------------------------------------------------------------------
// Funci¢n ....: Show_Msg.
// Descripci¢n : Muestra en pantalla mensajes para usuarios.
// Sintaxis ...: show_msg (<expN>,<expC>).
//               Donde <expN> ser† la variable que contendr† el n£mero de
//               l°nea del mensaje y donde <expC> ser† una variable o cadena
//               alfanumÇrica que se pasa como par†metro a la funci¢n. Esta
//               cadena ser† el mensaje a mostrar en pantalla.
// Ejemplo ....: show_msg (5,"Mensaje a mostrar en pantalla")
// Autor ......: Fco. Javier PÇrez Vidal.
// ---------------------------------------------------------------------------
function show_msg( msg_lin, msg )
         local long := 0
         local tecla := 0
         local vent_msg
         msg := alltrim( msg )
         long := len( msg ) + 3
         vent_msg := savescreen( msg_lin,79-long,msg_lin+2,79 )
         @ msg_lin,79-long clear to msg_lin+2,79
         @ msg_lin,79-long,msg_lin+2,79 box "…Õª∫ºÕ»∫"
         @ msg_lin+1,79-long+2 say msg
         set cursor off
         tecla := inkey( 2 )
         set cursor on
         restscreen ( msg_lin,79-long,msg_lin+2,79,vent_msg )
return nil

// ---------------------------------------------------------------------------
// Funci¢n ....: DeEncripta.
// Descripci¢n : Desencripta la cadena de car†cteres que nos ha sido genrada
//               por el programa ENCRIPTA.EXE.
// Ejemplo ....: DeEncripta (CHR(65)+CHR(66))
// Autor ......: Fco. Javier PÇrez Vidal
// ---------------------------------------------------------------------------
function DeEncripta( CadenaIn )
   local CadenaOut := ""
   local Letra
   local Codigo
   local Cantidad := len( CadenaIn )
   local Contador
   for Contador := 1 to Cantidad
       Letra := substr( CadenaIn, Contador, 1 )
       Codigo := asc( Letra )
       if !( Letra == " " )
          Codigo := Codigo - Contador
       endif
       Letra := chr( Codigo )
       CadenaOut := CadenaOut + Letra
   endfor
return CadenaOut
