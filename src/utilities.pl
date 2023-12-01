sumList([], 0).
sumList([H | T], Sum):-
    sumList(T, Rest),
    Sum is H + Rest.

copy_list([], []).
copy_list([X|Xs], [X|Ys]):-
    copy_list(Xs, Ys).

/* Basis saat elemen indeks pertama adalah yang dicari */
getIndex([Head | _Tail], SearchedElmt, Index) :- 
    Head = SearchedElmt, !, 
    Index is 1.

/* Base case: elemen tidak ditemukan */
getIndex([], _SearchedElmt, -1).

/* Rekurens */
getIndex([_Head | Tail], SearchedElmt, Index) :- 
    getIndex(Tail, SearchedElmt, NewIndex), 
    (NewIndex = -1 -> Index = -1 ; Index is NewIndex + 1).

getNumTroops(Wilayah, NumTroops):-
    wilayah(_,_,Wilayah,_,NumTroops,_).

getNamaFromKode(KodePemain, Nama) :-
    infoPlayer(KodePemain, Nama, _, _, _, _, _).

getAllAvailableTetangga(Wilayah, KodePemain, List):-
    findall(
        Tetangga,
        (
            bertetangga(Wilayah, Tetangga),
            wilayah(_,Owner, Tetangga, _, _, _), % Get the owner of the neighboring region
            Owner \= KodePemain
        ),
        List
    ).

isWilayah(KodePemain, Wilayah, Result) :-
    (   wilayah(_,KodePemain, Wilayah, _, Num, _), Num > 1
    ->  Result = 1
    ;   Result = 0
    ).

findNextPlayer(NextPlayer) :-
    playerListAfterOrder(CurrentList),
    nth1(2, CurrentList, NextPlayer).

/* buat print jadi kapital */
convert_to_uppercase(Input, Output) :-
    atom_codes(Input, InputCodes),
    maplist(convert_to_uppercase_code, InputCodes, OutputCodes),
    atom_codes(Output, OutputCodes).

convert_to_uppercase_code(Code, UppercaseCode) :-
    Code >= 97, Code =< 122, % Check if the code corresponds to a lowercase letter
    UppercaseCode is Code - 32.
convert_to_uppercase_code(Code, Code) :- % Keep other codes unchanged
    Code < 97 ; Code > 122.


/* PRINT ELEMENT-ELEMENT LIST */
print_list_elements([]) :-
    write('Empty List').
print_list_elements([X]) :-
    write(X).
print_list_elements([H|T]) :-
    write(H),
    write(', '),
    print_list_elements(T).

/* DELETE AT LIST */
deleteAt(Index, List, Result) :-
    deleteAtHelper(Index, List, 0, Result).

deleteAtHelper(_, [], _, []).
deleteAtHelper(Index, [_|T], Index, Result) :-
    !,
    deleteAtHelper(Index, T, Index, Result).
deleteAtHelper(Index, [H|T], CurrentIndex, [H|Result]) :-
    NextIndex is CurrentIndex + 1,
    deleteAtHelper(Index, T, NextIndex, Result).

append_element(Element, List, NewList) :-
    append(List, [Element], NewList).

changeOrder([H|T], Result) :-
    append(T, [H], Result).

getTotalTroopsBonus(KodePlayer, Bonus) :-
    findall(BonusBenua, (totalWilayahInBenua(Benua, JumlahInBenua), isMenguasai(KodePlayer, Benua, 1), BonusBenua is JumlahInBenua), ListBonusKontrolBenua),
    sum_list(ListBonusKontrolBenua, Bonus).

getJumlahWilayah(KodePlayer, JumlahWilayah) :-
    findall(KodePlayer, wilayah(_, KodePlayer, _, _, _, _), ListWilayah),
    length(ListWilayah, JumlahWilayah).

isMenguasai(KodePlayer, KodeBenua, Result) :-
    findall(KodePlayer, wilayah(_, KodePlayer, KodeWilayah, KodeBenua, _, _), ListOwnedTerritories),
    length(ListOwnedTerritories, JumlahWilayah),
    totalWilayahInBenua(KodeBenua, JumlahInBenua),

    (JumlahWilayah =:= JumlahInBenua -> Result is 1; 
     Result is 0
    ).

jumlahPlayer(N) :-
    findall(KodePlayer, infoPlayer(KodePlayer, _, _, _, _, _, _), ListPlayer),
    length(ListPlayer, N).

insert(Element, List, ResultingList) :-
    append(Head, Tail, List),
    append(Head, [Element|Tail], ResultingList).

isMenguasaiWilayah(KodePlayer, KodeWilayah, Result) :-
    wilayah(_, KodePlayer, KodeWilayah, _, _, _),
    Result is 1.

getTroopsFromWilayah(KodeWilayah, JumlahTentara) :-
    wilayah(_, _, KodeWilayah, _, JumlahTentara, _).

updateWilayahAndBenua(KodePlayer) :-
    findall(Benua, wilayah(_, KodePlayer, _, Benua, _, _), ListBenua),
    find_unique(ListBenua, ListBenuaUnique),
    findall(Wilayah, wilayah(_,KodePlayer,Wilayah,_,_,_), ListWilayah),
    findall(Troops, wilayah(_,KodePlayer,_,_,Troops,_), ListTroops),
    sum_list(ListTroops, TotalTroops),
    retract(infoPlayer(KodePlayer, Nama, _, _, _,Tambahan, Roll)),
    asserta(infoPlayer(KodePlayer, Nama,ListWilayah, ListBenuaUnique, TotalTroops,Tambahan, Roll)).

find_unique([], []).
find_unique([X | Tail], [X | RestUnique]) :-
    \+ member(X, Tail),
    find_unique(Tail, RestUnique).
find_unique([X | Tail], RestUnique):-
    member(X, Tail),
    find_unique(Tail, RestUnique).