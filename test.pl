% CODE FOURNI PAR LE PROF TAVU

% Prédicats d'affichage fournis

% set_echo: ce prédicat active l'affichage par le prédicat echo
set_echo :- assert(echo_on).

% clr_echo: ce prédicat inhibe l'affichage par le prédicat echo
clr_echo :- retractall(echo_on).

% echo(T): si le flag echo_on est positionné, echo(T) affiche le terme T
%          sinon, echo(T) réussit simplement en ne faisant rien.

echo(T) :- echo_on, !, write(T).
echo(_).


% CODE TROUVE POUR TEST

% Facts
food(burger).
food(sandwich).
food(pizza).
lunch(sandwich).
dinner(pizza).

% Rules
meal(X) :- food(X).

% Queries & answers
?- food(pizza).
true.

?- meal(X), lunch(X).
X = sandwich.

% Le . est l'equivalent du ; en java. Il est indispensable a la fin de chaque ligne, que ce soit dans le programme ou quand on pose des questions dans la console.
% Remarque sur meal(X) et food(X) : 
% Quand on met X au niveau d'une rule, osef que ce soit X, w ou n'importe quelle autre lettre (exemple plus haut avec echo)
% Par contre, quand on pose la question dans la console (Query), le X est obligatoire, sinon ca marche pas.

%Quand la réponse d'une requete ne se termine pas toute seule, il faut appuyer sur espace pour avoir le résultat complet.
