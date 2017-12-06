:- op(20, xfy, ?=).
:- encoding(utf8).

% Prédicats d'affichage fournis'
% set_echo: ce prédicat active l'affichage par le prédicat echo
set_echo :- assert(echo_on).

% clr_echo: ce prédicat inhibe l'affichage par le prédicat echo
clr_echo :- retractall(echo_on).

% echo(T) : si le flag echo_on est positionné :
%               - echo(T) affiche le terme T
%               - echonl fait un saut de ligne
%           sinon, echo(T) réussit simplement en ne faisant rien.
echonl :- echo_on, !, nl.
echonl.
echo(T) :- echo_on, !, write(T).
echo(_).
:- set_echo.


% Test d'application d'une règle
regle(X ?= T, rename)    :- var(X), var(T).
regle(X ?= T, simplify)  :- var(X), atom(T).
regle(X ?= T, expand)    :- var(X), compound(T), \+(contains_var(X, T)).
regle(X ?= T, check)     :- var(X), X \== T, contains_var(X,T).
regle(T ?= X, orient)    :- var(X), nonvar(T).
regle(X ?= T, decompose) :-
    nonvar(X), nonvar(T),
    functor(X, Xf, Xa), functor(T, Tf, Ta), Xf==Tf, Xa=:=Ta.
regle(X ?= T, clash)     :-
    nonvar(X), nonvar(T),
    functor(X, Xf, Xa), functor(T, Tf, Ta), (Xf\==Tf; Xa=\=Ta), !.


% Application des règles
reduit(rename,    X ?= T, P, Q) :- delete_elem(X?=T, P, Q), X = T.
reduit(simplify,  X ?= T, P, Q) :- delete_elem(X?=T, P, Q), X = T.
reduit(expand,    X ?= T, P, Q) :- delete_elem(X?=T, P, Q), X = T.
reduit(orient,    T ?= X, P, Q) :- delete_elem(T?=X, P, Q2), append([X?=T], Q2, Q).
reduit(decompose, T1 ?= T2, P, Q) :-
    T1 =.. T1_l, T2 =.. T2_l,
    del_head(T1_l, T1_args), del_head(T2_l, T2_args),
    args_to_list(T1_args, T2_args, L),
    delete_elem(T1 ?= T2, P, Q1), append(L, Q1, Q).
reduit(check, _, _, []) :- false.
reduit(clash, _, _, []) :- false.

% Unifie Q avec la liste passée en paramètre privée du terme E
delete_elem(E, [H|T], Q) :- E \== H, append([H], Q2, Q), delete_elem(E, T, Q2), !.
delete_elem(E, [H|T], Q) :- E == H, delete_elem(E, T, Q).
delete_elem(_, [], []).

% Unifie Q de la forme [X ?= Y, Z ?= W, ..] à partir
% de deux listes [X, Z, ..] et [Y, W, ..]
args_to_list([H1|T1], [H2|T2], Q) :- append([H1?=H2], Q2, Q), args_to_list(T1, T2, Q2).
args_to_list([], [], []).

% Supprime la tête de liste
del_head([_|T], T).
del_head([], []).

% Affichage
% R : règle, E : équation, S : système
display_state(R, E, S) :-
    echo('System : '), echo(S), echonl,
    echo('__> '), echo(R), echo(' : '), echo(E), echonl.

% Unification
unifie([], _).
unifie(P, Strat):-
    choix_strat(Strat, P, E, R),
    display_state(R, E, P),
    reduit(R, E, P, Q),
    unifie(Q, Strat), !.


unif(P, Strat) :- clr_echo, unifie(P, Strat).
% Unification avec affichage des étapes
trace_unif(P, Strat) :- set_echo, unifie(P, Strat), echonl.


% LES STRATÉGIES DISPONIBLES
choix_strat(premier,   P, E, R) :- choix_premier(P, E, R).
choix_strat(pondere,   P, E, R) :- choix_pondere(P, E, R).
choix_strat(aleatoire, P, E, R) :- choix_alea(P, E, R).

% Liste de règle ordonnées
ordered_list([clash, check,
              rename, simplify,
              orient,
              decompose,
              expand]).

% Choisit une équation E dans le système P ainsi que la règle R correspondante
choix_premier([E|_], E, R) :- regle(E, R), !.
choix_pondere(P, E, R)     :- ordered_list(X), trouver_regle(X, P, E, R), !.
choix_alea(P, E, R)        :- random_member(E, P), regle(E, R), !.

% Prédicat qui parcourt toutes les règles
trouver_regle(X, P, E, R) :- trouver_eq(X, P, E, R).
trouver_regle([_|T], P, E, R) :- trouver_regle(T, P, E, R).

% Prédicat qui parcourt toutes les équations
trouver_eq([R|_], [E|_], E, R) :- regle(E, R).
trouver_eq(X, [_|T], E, R) :- trouver_eq(X, T, E, R).
trouver_eq(_, [], _, _) :- false.


% INTERFACE UTILISATEUR
unification(P, Strat, o) :- trace_unif(P, Strat).
unification(P, Strat, _) :- unif(P, Strat).

% Applique l’algorithme d’unification sur le liste P
% Permet de choisir la stratégie ainsi que l'affichage ou non de la trace'
% Stratégie 'premier' par défaut.
unifier(P) :-
    write('Choix stratégie :'), nl,
    write('p [premier] | pond [pondéré] | a [aléatoire]'), nl,
    read(St),
    (St == p    -> Strat = premier ;
     St == pond -> Strat = pondere ;
     St == a    -> Strat = aleatoire ; Strat = premier),
    write('Afficher la trace ? o/n '), nl,
    read(Traces), nl,
    ansi_format([fg(yellow)], 'Stratégie : ~w', [Strat]), nl,
    unification(P, Strat, Traces).

init :-
    write('+======================================+\n'),
    write('|                                      |\n'),
    write('|   Unification [martelli-montanari]   |\n'),
    write('|                                      |\n'),
    write('+======================================+\n\n'),
    write('Appeler '),
    ansi_format([fg(green)], 'unifier(X)', []),
    write(' : où X est une liste d\'équations de forme (X ?= Y).\n').

:- init.
