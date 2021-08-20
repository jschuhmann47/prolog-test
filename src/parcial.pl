:- use_module(begin_tests_con).

nacio(juan,(9,7,1994)).
nacio(aye,(26,3,1992)).
nacio(feche,(22,12,1995)).

%fechaAntesQueOtra(fechaanterior,fecha)
fechaAntesQueOtra((_,_,Anio1),(_,_,Anio2)):-
    between(0, Anio2, Anio1),
    Anio1\=Anio2.
fechaAntesQueOtra((_,Mes1,Anio),(_,Mes2,Anio)):-
    between(0, Mes2, Mes1),
    Mes1\=Mes2.
fechaAntesQueOtra((Dia1,Mes,Anio),(Dia2,Mes,Anio)):-
    between(0, Dia2, Dia).
    
%pasoCumpleanios(Fecha,Cumpleanios).
pasoCumpleanios((Dia,Mes),(DiaCumpleanios,MesCumpleanios)):-
    fechaAntesQueOtra((DiaCumpleanios,MesCumpleanios,0),(Dia,Mes,0)). %el año igual para que no se fije por año

regalo(juan,libro(fantasia,terryPratchet),feche,2018).
regalo(juan,producto(harryPotter),aye,2019).
regalo(juan,cerveza(artesanal,roja),aye,2020).
regalo(juan,cerveza(quilmes,rubia),feche,2021).
regalo(aye,libro(fantasia,terryPratchet),feche,2019).
regalo(aye,libro(cienciaFiccion,stainslawLem),juan,2020).
regalo(feche,cerveza(artesanal,rubia),juan,2019).
regalo(feche,producto(pokemon),juan,2020).
regalo(feche,libro(terror,maryShelly),aye,2021).


poderRegalarleA((Dia,Mes,Anio),DadoraRegalo,RecibeRegalo):-
    regalo(DadoraRegalo,_,_,_),
    nacio(RecibeRegalo,_),
    not(regalo(DadoraRegalo,_,_,Anio)),
    not(regalo(_,_,RecibeRegalo,Anio)),
    not(cumplioAnios(RecibeRegalo,(Dia,Mes,Anio))).
    

cumplioAnios(Persona,(Dia,Mes,Anio)):- %si la persona, a la fecha que uno ingresa, ya cumplio años o no
    nacio(Persona,(DiaCumple,MesCumple,_)),
    pasoCumpleanios((Dia,Mes),(DiaCumple,MesCumple)).


gusta(aye,cerveza(heineken,rubia)).
gusta(aye,producto(harryPotter)).
gusta(juan,libro(fantasia,_)).
gusta(juan,libro(cienciaFiccion,_)).
gusta(juan,Regalo):-
    regaloCaro(Regalo).
gusta(feche,producto(monsterHunter)).
gusta(feche,libro(Genero,terryPratchet)):-
    not(regaloCaro(libro(Genero,terryPratchet))).

regaloCaro(libro(cienciaFiccion,rayBradbury)).
regaloCaro(libro(novela,_)).
regaloCaro(cerveza(artesanal,_)).

buenRegalo(Regalador,Regalado,Regalo):-
    regalo(Regalador,Regalo,Regalado,_),
    gusta(Regalado,Regalo).

habilRegalador(Regalador):-
    nacio(Regalador,_),
    forall(regalo(Regalador,Regalo,RecibeRegalo,_),buenRegalo(Regalador,RecibeRegalo,Regalo)),
    not(dosRegalosParecidosEnDistintoAnio(Regalador)).

dosRegalosParecidosEnDistintoAnio(Regalador):-
    regalo(Regalador,Regalo1,_,Anio1),
    regalo(Regalador,Regalo2,_,Anio2),
    Anio1\=Anio2,
    regalosParecidos(Regalo1,Regalo2).

regalosParecidos(cerveza(_,_),cerveza(_,_)).
regalosParecidos(libro(Genero,_),libro(Genero,_)).
regalosParecidos(producto(Tematica),producto(Tematica)).

monotematico(Regalado):-
    nacio(Regalado,_),
    forall(dosBuenRegalosDistintos(Regalado,Regalo1,Regalo2),regalosParecidos(Regalo1,Regalo2)). %si tiene menos de dos regalos da verdadero, por la regla del condicional F->? da V

dosBuenRegalosDistintos(Persona,Regalo1,Regalo2):-
    buenRegalo(_,Persona,Regalo1),
    buenRegalo(_,Persona,Regalo2),
    Regalo1\=Regalo2.

regaloNinja(Regalador,Regalo):-
    regalo(Regalador,Regalo,_,_),
    gusta(Regalador,Regalo).

regaladorNinja(Regalador):-
    regalo(Regalador,_,_,_),
    cantidadBuenosRegalos(Regalador,CantidadBuenosRegalos),
    cantidadRegalosNinja(Regalador,CantidadRegalosNinja),
    between(0, CantidadRegalosNinja, CantidadBuenosRegalos).

cantidadBuenosRegalos(Regalador,CantidadBuenosRegalos):-
    findall(BuenRegalo,buenRegalo(Regalador,_,BuenRegalo),ListaBuenRegalo),
    length(ListaBuenRegalo, CantidadBuenosRegalos).

cantidadRegalosNinja(Regalador,CantidadRegalosNinja):-
    findall(RegaloNinja,regaloNinja(Regalador,RegaloNinja),ListaRegaloNinja),
    length(ListaRegaloNinja, CantidadRegalosNinja).
    
    
    

:- begin_tests_con(parcial, []).

test(fechaAntesQueOtraPorAnio):-
    fechaAntesQueOtra((1,1,2000),(2,3,2004)).
test(fechaAntesQueOtraPorMes_MismoAnio):-
    fechaAntesQueOtra((1,1,2000),(2,3,2000)).
test(fechaAntesQueOtraPorDia_MismoMesyAnio):-
    fechaAntesQueOtra((1,1,2000),(20,1,2000)).
test(pasoCumpleaniosDeJuan):-
    pasoCumpleanios((20,8),(9,7)).
test(noPasoCumpleFeche):-
    not(pasoCumpleanios((20,8),(22,12))).
test(paraEl_5Enero2021_ayeLePuedeRegalarAJuan):-
    poderRegalarleA((5,1,2021),aye,juan).
test(paraEl_10Enero2020_nadieLePuedeRegalarAJuan):-
    not(poderRegalarleA((5,1,2020),_,juan)).
test(paraJuanEsBuenRegaloLaCervezaArtesanalRubia):-
    buenRegalo(_,juan,cerveza(artesanal, rubia)).
test(paraJuanNoEsBuenRegaloLibroDeTerrorMaryShelly):-
    not(buenRegalo(_,juan,(terror,maryShelly))).
test(buenRegaloParaAyeEsProductosDeHarryPotter):-
    buenRegalo(_,aye,producto(harryPotter)).
test(noEsbuenRegaloParaAyeLibroDeTerrorMaryShelly):-
    not(buenRegalo(_,aye,(terror,maryShelly))).
test(buenRegaloParaFecheEsLibroFantasiaTerry):-
    buenRegalo(_,feche,libro(fantasia,terryPratchet)).
test(noEsbuenRegaloParaFecheQuilmesRubia):-
    not(buenRegalo(_,feche,cerveza(quilmes,rubia))).
test(ayeEsHabilRegaladora):-
    habilRegalador(aye).
test(fecheEsMonotematicoPorTenerDosRegalosParecidos):-
    monotematico(feche).
test(ayeEsMonotematicaPorTenerUnRegalo):-
    monotematico(aye). %(F->(V/F)  asi que el condicional da V)
test(juanNoEsMonotematico):-
    not(monotematico(juan)).
test(juanEsRegaladorNinja):-
    regaladorNinja(juan).
test(fecheNoEsRegaladorNinja):-
    not(regaladorNinja(feche)).


:- end_tests(parcial).