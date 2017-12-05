% Prédicats d'affichage fournis

% set_echo: ce prédicat active l'affichage par le prédicat echo
set_echo :- assert(echo_on).

% clr_echo: ce prédicat inhibe l'affichage par le prédicat echo
clr_echo :- retractall(echo_on).

% echo(T): si le flag echo_on est positionné, echo(T) affiche le terme T
%          sinon, echo(T) réussit simplement en ne faisant rien.

echo(T) :- echo_on, !, write(T).
echo(_).

% Predicats d'affichage custom

% menu : ce predicat va set_echo, puis echo un menu d'accueil
menu :- set_echo,
echo('========================================='), nl,
echo('LMC UNIFICATION PROGRAM'), nl, 
echo('Option 1 : ça c est l option 1 tavu'), nl, 
echo('Option 2 : et ça c est l option 2 mdr'), nl,
echo('========================================='), nl.

% init : sera éxécuté dès le lancement du programme
init :- menu.

:- init.
