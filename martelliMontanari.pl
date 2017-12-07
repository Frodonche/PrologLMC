% Encodage en UTF-8
:- encoding(utf8).

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
menu :- 
set_echo, nl,
ansi_format([fg(blue)], '=============================', []), nl,
ansi_format([fg(red)], '   MARTELLI - MONTANARI', []), nl,
ansi_format([fg(red)], '   UNIFICATION PROGRAM', []), nl, nl,
ansi_format([fg(green)], '- menu : afficher ce menu', []), nl,
ansi_format([fg(green)], '- toto : blabla oui oui', []), nl,
ansi_format([fg(blue)], '=============================', []), nl, nl.

% init : sera éxécuté dès le lancement du programme
init :- menu.

:- init.

% Definition de l'operateur fourni
:- op(20, xfy, =?). 


% Question 1 : partie unification

% Definition de regle(E, R)
% Definition des regles de transformation
% Definition de Rename
regle(X ?= T, rename) :- var(X), var(T).

% Definition de Simplify
regle(X ?= T, simplify) :- var(X), atom(T).

% Definition de Expand
# regle(X ?= T, expand) :- var(X), compound(T), \+


% Ne pas utiliser de liste pour les arguments de fonctions f(x,y) -> [f,x,y] A NE PAS FAIRE
% Utiliser functor et arg a la place 
