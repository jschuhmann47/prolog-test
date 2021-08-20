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
    not(cumplioAnios(RecibeRegalo,(Dia,Mes,Anio))),
    not(regalo(_,_,RecibeRegalo,Anio)).

cumplioAnios(Pesona,(Dia,Mes,Anio)):-
    nacio(Persona,(DiaCumple,MesCumple,_)),
    pasoCumpleanios((Dia,Mes),(DiaCumple,MesCumple)).


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
    not(poderRegalarleA((5,1,2021),_,juan)).

:- end_tests(parcial).