:-include('dynamicfacts.pl').
:-include('staticfacts.pl').
:-include('utilities.pl').
:-include('wilayah.pl').
:-include('risk.pl').
:-include('player.pl').
:-include('attack.pl').
:-include('map.pl').
:-include('turn.pl').
:-include('troops.pl').

startGame :-
    write('Masukkan jumlah pemain: '),
    read(N),
    (N >= 2, N =< 4 ->
        asserta(playerListAfterOrder([])),
        (N =:= 2 ->
            Troops is 24;
            N =:= 3 ->
            Troops is 16;
            N =:= 4 ->
            Troops is 12),
        initiatePlayer(N, 1, PlayerList, PlayerNames, Troops),
        nl,
        playRound(PlayerList, PlayerNames),
        !;
        write('Mohon masukkan angka antara 2 - 4.'), nl,
        startGame
    ),initiateLoc, asserta(iterator(0)), asserta(iteratorTroops(0)), asserta(iteratorPlace(0)).

playRound(PlayerList, PlayerNames) :-
    rollDice(PlayerList, PlayerNames),
    findMaxDice(PlayerList, MaxPlayer, MaxValue),
    countMaxPlayers(PlayerList, MaxValue, Count),
    nl,
    (Count > 1 ->
        write('Terdapat lebih dari satu pemain dengan nilai dadu maksimal. Memulai putaran dadu baru...'), nl,
        playRound(PlayerList, PlayerNames)
    ;   setPlayerOrder(PlayerList, MaxPlayer),
        displayPlayerOrder(PlayerNames),
        getPlayerNameByIndex(MaxPlayer, PlayerNames, NamaMaxPlayer),
        format('~w dapat mulai terlebih dahulu.', [NamaMaxPlayer]),
        nl,
        playerOrder(MaxPlayer, PlayerListAfterOrder),
        asserta(playerListAfterOrder(PlayerListAfterOrder)),
        length(PlayerList, Len),
        (Len >= 2, Len =< 4 ->
            initialTroops(Len, Troops),
            nl,
            format('Setiap pemain mendapatkan ~d tentara.', [Troops])
        ;   write('Jumlah pemain tidak valid.')
        ), nl,
        format('Giliran ~w untuk memilih wilayahnya.', [NamaMaxPlayer])
        ,asserta(whoseTurn(MaxPlayer))
    ).

initiatePlayer(0, _, [], [], Troops) :- !.
initiatePlayer(N, Z, [Z | Rest], [Name | NamesListRest], Troops) :-
    write('Masukkan nama pemain '), write(Z), write(': '),
    read(Name),
    asserta(infoPlayer(Z, Name, [], [], Troops, 0, 0)),
    asserta(hasrisked(Z,0)),
    asserta(hasattacked(Z, 0)),
    asserta(totalMoves(Z, 0)),
    asserta(ceasefire(Z, 0)),
    asserta(supersoldier(Z, 0)),
    asserta(supplyissue(Z, 0)),
    asserta(auxiliary(Z, 0)),
    asserta(disease(Z, 0)),
    asserta(jumlahDadu(Z, 0)),
    M is N - 1,
    Z1 is Z + 1,
    initiatePlayer(M, Z1, Rest, NamesListRest, Troops).

rollDice([], _PlayerNames).
rollDice([PlayerName | Rest], PlayerNames) :-
    infoPlayer(PlayerName, _, _, _, _, _, _),
    getPlayerNameByIndex(PlayerName, PlayerNames, NamaPlayer),
    random(2, 13, Roll),
    format('~w melempar dadu dan mendapatkan ~w.~n', [NamaPlayer, Roll]),
    initDice(PlayerName, Roll),
    rollDice(Rest, PlayerNames).

initDice(PlayerName, Roll) :-
    retract(infoPlayer(PlayerName, A, B, C, D, E, _)),
    asserta(infoPlayer(PlayerName, A, B, C, D, E, Roll)).

findMaxDice(PlayerList, MaxPlayer, MaxValue) :-
    findMaxDiceHelper(PlayerList, '', 0, MaxPlayer, MaxValue).

findMaxDiceHelper([], MaxPlayer, MaxValue, MaxPlayer, MaxValue).
findMaxDiceHelper([PlayerName | Rest], CurrMaxPlayer, CurrMaxValue, MaxPlayer, MaxValue) :-
    infoPlayer(PlayerName, _, _, _, _, _, Roll),
    (Roll > CurrMaxValue ->
        findMaxDiceHelper(Rest, PlayerName, Roll, MaxPlayer, MaxValue);
        findMaxDiceHelper(Rest, CurrMaxPlayer, CurrMaxValue, MaxPlayer, MaxValue)
    ).

setPlayerOrder(PlayerList, MaxPlayer) :-
    findPlayerIndex(PlayerList, MaxPlayer, Index),
    rotateList(PlayerList, Index, RotatedPlayerList),
    asserta(playerOrder(MaxPlayer, RotatedPlayerList)).

displayPlayerOrder(PlayerNames) :-
    playerOrder(_MaxPlayer, PlayerList),
    write('Urutan pemain: '),
    displayPlayerList(PlayerList, PlayerNames),
    nl.

displayPlayerList([], _PlayerNames).
displayPlayerList([Player | []], PlayerNames) :-
    getPlayerNameByIndex(Player, PlayerNames, NamaPlayer),
    write(NamaPlayer).
displayPlayerList([Player | Rest], PlayerNames) :-
    getPlayerNameByIndex(Player, PlayerNames, NamaPlayer),
    write(NamaPlayer),
    write(' - '),
    displayPlayerList(Rest, PlayerNames).

findPlayerIndex([Player | _], Player, 1).
findPlayerIndex([_ | Rest], Player, Index) :-
    findPlayerIndex(Rest, Player, IndexRest),
    Index is IndexRest + 1.

rotateList(List, N, RotatedList) :-
    N1 is N - 1,
    length(Front, N1),
    append(Front, Back, List),
    append(Back, Front, RotatedList).

countMaxPlayers([], _, 0).
countMaxPlayers([PlayerName | Rest], MaxValue, Count) :-
    infoPlayer(PlayerName, _, _, _, _, _, Roll),
    (Roll =:= MaxValue ->
        countMaxPlayers(Rest, MaxValue, CountRest),
        Count is CountRest + 1;
        countMaxPlayers(Rest, MaxValue, Count)
    ).

displayPlayerNames([]).
displayPlayerNames([PlayerName | Rest]) :-
    infoPlayer(PlayerName, _, _, _, _, _, _),
    write(PlayerName),
    write(' - '),
    displayPlayerNames(Rest).

getPlayerNameByIndex(Index, PlayerNames, NamaPlayer) :-
    nth1(Index, PlayerNames, NamaPlayer).