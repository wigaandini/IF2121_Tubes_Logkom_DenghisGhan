/* wilayah(NamaWilayah, KodePemain, KodeWilayah, NamaBenua, Owned, JumlahTroops, StatusAttackable) */
initiateLoc:-
    asserta(wilayah('Greenland', 0, na1, 'AMERIKA UTARA', 0, 1)),
    asserta(wilayah('Canada', 0, na2, 'AMERIKA UTARA', 0, 1)),
    asserta(wilayah('Amerika Serikat', 0, na3, 'AMERIKA UTARA', 0, 1)),
    asserta(wilayah('Mexico', 0, na4, 'AMERIKA UTARA', 0, 1)),
    asserta(wilayah('Guatemala', 0, na5, 'AMERIKA UTARA', 0, 1)),
    asserta(wilayah('Brazil', 0, sa1, 'AMERIKA SELATAN', 0, 1)),
    asserta(wilayah('Argentina', 0, sa2, 'AMERIKA SELATAN', 0, 1)),
    asserta(wilayah('Islandia', 0, e1, 'EROPA', 0, 1)),
    asserta(wilayah('Swedia', 0, e2, 'EROPA', 0, 1)),
    asserta(wilayah('Finlandia', 0, e3, 'EROPA', 0, 1)),
    asserta(wilayah('Rusia', 0, e4, 'EROPA', 0, 1)),
    asserta(wilayah('Ukraina', 0, e5, 'EROPA', 0, 1)),
    asserta(wilayah('Algeria', 0, af1, 'AFRIKA', 0, 1)),
    asserta(wilayah('Sudan', 0, af2, 'AFRIKA', 0, 1)),
    asserta(wilayah('Afrika Selatan', 0, af3, 'AFRIKA', 0, 1)),
    asserta(wilayah('China', 0, a1, 'ASIA', 0, 1)),
    asserta(wilayah('Korea', 0, a2, 'ASIA', 0, 1)),
    asserta(wilayah('Jepang', 0, a3, 'ASIA', 0, 1)),
    asserta(wilayah('India', 0, a4, 'ASIA', 0, 1)),
    asserta(wilayah('Taiwan', 0, a5, 'ASIA', 0, 1)),
    asserta(wilayah('Thailand', 0, a6, 'ASIA', 0, 1)),
    asserta(wilayah('Indonesia', 0, a7, 'ASIA', 0, 1)),
    asserta(wilayah('New South Wales', 0, au1, 'AUSTRALIA', 0, 1)),
    asserta(wilayah('Queensland', 0, au2, 'AUSTRALIA', 0, 1)).

takeLocation(Location) :-
    whoseTurn(Player),
    getNamaFromKode(Player, PlayerName),
    wilayah(_, KodePemain, Location, _, _, _),
    iterator(Iterate),
    
    (Iterate =\= 23 ->
        handleLocationSelection(Location, KodePemain, Player, PlayerName, Iterate)
    ;
        handleLastLocationSelection(Location, KodePemain, Player, PlayerName),
        switchTurn,
        change_iterator
    ), !.

updatePlayerTerritories(Player, Location, NewListWilayah) :-
    infoPlayer(Player, NamaPemain, ListWilayah, ListBenua, TentaraAktif, TentaraTambahan, RollDice),
    SisaTroops is TentaraAktif - 1,
    insert(Location, ListWilayah, NewListWilayah),
    retract(infoPlayer(Player, NamaPemain, ListWilayah, ListBenua, TentaraAktif, TentaraTambahan, _)),
    asserta(infoPlayer(Player, NamaPemain, NewListWilayah, ListBenua, SisaTroops, TentaraTambahan, RollDice)).

updatePlayerBenua(Player, KodeWilayah, NewListBenua) :-
    wilayah(_, Player, KodeWilayah, Benua, _, _),
    infoPlayer(Player, NamaPemain, ListWilayah, ListBenua, TentaraAktif, TentaraTambahan, _),
    (
        member(Benua, ListBenua) ->
            NewListBenua = ListBenua
        ;
            append(ListBenua, [Benua], NewListBenua)
    ),
    retract(infoPlayer(Player, NamaPemain, ListWilayah, ListBenua, TentaraAktif, TentaraTambahan, _)),
    asserta(infoPlayer(Player, NamaPemain, ListWilayah, NewListBenua, TentaraAktif, TentaraTambahan, _)).


handleLocationSelection(Location, KodePemain, Player, PlayerName, Iterate) :-
    (KodePemain =\= 0 ->
        convert_to_uppercase(Location, LocationUpper),
        format('Wilayah ~w sudah dikuasai. Tidak bisa mengambil.~nGiliran ~w untuk memilih wilayahnya.', [LocationUpper, PlayerName])
    ;
        retract(wilayah(A, _, Location, B, C, D)),
        asserta(wilayah(A, Player, Location, B, 1, D)),
        convert_to_uppercase(Location, LocationUpper),
        format('~w mengambil wilayah ~w.~n', [PlayerName, LocationUpper]),
        updatePlayerTerritories(Player, Location, NewListWilayah),
        updatePlayerBenua(Player, Location, NewListBenua),
        switchTurn,
        whoseTurn(NextPlayer),
        getNamaFromKode(NextPlayer, NextPlayerName),
        format('Giliran ~w untuk memilih wilayahnya.', [NextPlayerName]),
        change_iterator
    ).

handleLastLocationSelection(Location, KodePemain, Player, PlayerName) :-
    (KodePemain =\= 0 ->
        format('Wilayah ~w sudah dikuasai. Tidak bisa mengambil.~nGiliran ~w untuk memilih wilayahnya.', [Location, PlayerName])
    ;
        retract(wilayah(A, _, Location, B, C, D)),
        asserta(wilayah(A, Player, Location, B, 1, D)),
        convert_to_uppercase(Location, LocationUpper),
        format('~w mengambil wilayah ~w.~n', [PlayerName, LocationUpper]),
        updatePlayerTerritories(Player, Location, NewListWilayah),
        updatePlayerBenua(Player, Location, NewListBenua),
        jumlahPlayer(N),
        findNextPlayer(NextPlayer),
        getNamaFromKode(NextPlayer, NextPlayerName),
        write('Seluruh wilayah telah diambil pemain.'), nl,
        write('Memulai pembagian sisa tentara.'), nl,
        format('Giliran ~w untuk meletakkan tentaranya.~n', [NextPlayerName])
    ).

change_iterator :-
    retract(iterator(Current)),
    New is Current + 1,
    asserta(iterator(New)).

switchTurn :-
    whoseTurn(CurrentPlayer),
    jumlahPlayer(N),
    findNextPlayer(NextPlayer),
    playerListAfterOrder(PlayerList),
    changeOrder(PlayerList, Result),
    retract(playerListAfterOrder(_)),
    asserta(playerListAfterOrder(Result)),
    retract(whoseTurn(CurrentPlayer)),
    asserta(whoseTurn(NextPlayer)).
    
placeTroopsHelper(KodePemain, RemainingTroops, KodeWilayah, JumlahTroopsYangDitaroh) :-
    RemainingTroops > 0,
    whoseTurn(CurrentPlayer),
    getNamaFromKode(CurrentPlayer, Nama),
    infoPlayer(CurrentPlayer, Nama, ListWilayah, ListBenua, TentaraAktif, TentaraTambahan, _),
    wilayah(_, CekCode, KodeWilayah, _, JumlahTroops, _),
    (CekCode =\= CurrentPlayer ->
        write('Wilayah tersebut dimiliki pemain lain.'), nl,
        write('Silakan pilih wilayah lain.'), nl, 
        format('Giliran ~w untuk meletakkan tentaranya.~n', [Nama]),
        !
    ;
        (JumlahTroopsYangDitaroh > TentaraAktif ->
            format('Jumlah tentara yang dimiliki ~w tidak cukup.~n', [Nama]), !
        ;
            NewJumlahTroops is JumlahTroops + JumlahTroopsYangDitaroh,
            retract(wilayah(A, CurrentPlayer, KodeWilayah, B, JumlahTroops, C)),
            asserta(wilayah(A, CurrentPlayer, KodeWilayah, B, NewJumlahTroops, C)),
            convert_to_uppercase(KodeWilayah, KodeWilayahUpper),
            format('Player ~w meletakkan ~w tentara di ~w.~n', [Nama, JumlahTroopsYangDitaroh, KodeWilayahUpper]),
            SisaTroops is TentaraAktif - JumlahTroopsYangDitaroh,
            retract(infoPlayer(CurrentPlayer, Nama, ListWilayah, ListBenua, TentaraAktif, TentaraTambahan, _)),
            asserta(infoPlayer(CurrentPlayer, Nama, ListWilayah, ListBenua, SisaTroops, TentaraTambahan, _)),
            (SisaTroops =:= 0 -> 
                whoseTurn(KodePemain),
                getNamaFromKode(KodePemain, Nama),
                format('Seluruh tentara ~w sudah diletakkan.~n', [Nama]),
                switchTurn,
                whoseTurn(NextPlayer),
                getNamaFromKode(NextPlayer, NextPlayerName),
                format('Giliran ~w untuk meletakkan tentaranya.~n', [NextPlayerName])
            ;
                format('Terdapat ~w tentara yang tersisa.', [SisaTroops]), nl,
                format('Giliran ~w untuk meletakkan tentaranya.~n', [Nama ])
            )
        ), !        
    ).

placeTroops(KodeWilayah, JumlahTroopsYangDitaroh) :-
    whoseTurn(KodePemain),
    infoPlayer(KodePemain, Nama, ListWilayah, ListBenua, RemainingTroops, TentaraTambahan, _),
    placeTroopsHelper(KodePemain, RemainingTroops, KodeWilayah, JumlahTroopsYangDitaroh).
    
change_iterator_troops :-
    retract(iteratorTroops(Current)),
    New is Current + 1,
    asserta(iteratorTroops(New)).
placeAutomatic :-
    whoseTurn(KodePemain),
    getNamaFromKode(KodePemain, Nama),
    infoPlayer(KodePemain, Nama, ListWilayah, ListBenua, TentaraAktif, TentaraTambahan, _),
    length(ListWilayah, NumWilayah),
    placeAutoTroops(KodePemain, ListWilayah, TentaraAktif, NumWilayah),
    write('Seluruh tentara '), write(Nama), write(' sudah diletakkan.'), nl,
    switchTurn,
    whoseTurn(NextPlayer),
    getNamaFromKode(NextPlayer, NextPlayerName),
    format('Giliran ~w untuk meletakkan tentaranya.~n', [NextPlayerName]).

placeAutoTroops(_, [], 0, _).
placeAutoTroops(KodePemain, [Wilayah|Rest], SisaTentara, NumWilayah) :-
    infoPlayer(KodePemain, Nama, ListWilayah, ListBenua, TentaraAktif, TentaraTambahan, _),
    iteratorTroops(Count),
    (
        Count < NumWilayah,
        random(1, SisaTentara, Randomize),
        assertz(troops(KodePemain, Wilayah, Randomize)),
        convert_to_uppercase(Wilayah, WilayahUpper),
        assertTroopsAuto(KodePemain, Randomize),
        change_iterator_troops,
        NewSisaTentara is SisaTentara - Randomize,
        write(Nama), write(' meletakkan '), write(Randomize), write(' tentara di wilayah '), write(WilayahUpper), write('.'), nl,
        placeAutoTroops(KodePemain, Rest, NewSisaTentara, NumWilayah)
    ;
        Count =:= NumWilayah,
        assertz(troops(KodePemain, Wilayah, SisaTentara)),
        convert_to_uppercase(Wilayah, WilayahUpper),
        assertTroopsAuto(KodePemain, SisaTentara),
        write(Nama), write(' meletakkan '), write(SisaTentara), write(' tentara di wilayah '), write(WilayahUpper), write('.'), nl
    ).

placeTroopsAutoHelper(KodePemain, Wilayah, JumlahTroops) :-
    infoPlayer(KodePemain, Nama, ListWilayah, ListBenua, TentaraAktif, TentaraTambahan, _),
    member(Wilayah, ListWilayah),
    iteratorTroops(Count),
    length(ListWilayah, NumWilayah),
    (
        % For the first four territories, use random placement
        Count < NumWilayah,
        JumlahTroops > 0,
        random(1, JumlahTroops+1, Randomize),
        assertz(troops(KodePemain, Wilayah, Randomize)),
        convert_to_uppercase(Wilayah, WilayahUpper),
        assertTroopsAuto(KodePemain, Randomize),
        change_iterator_troops,
        write(Nama), write(' meletakkan '), write(Randomize), write(' tentara di wilayah '), write(WilayahUpper), write('.'), nl
    ;
        % For the fifth territory, assert remaining troops
        Count =:= NumWilayah,
        JumlahTroops > 0,
        assertz(troops(KodePemain, Wilayah, JumlahTroops)),
        convert_to_uppercase(Wilayah, WilayahUpper),
        assertTroopsAuto(KodePemain, JumlahTroops),
        write(Nama), write(' meletakkan '), write(JumlahTroops), write(' tentara di wilayah '), write(WilayahUpper), write('.'), nl
    ).

assertTroopsAuto(KodePemain, JumlahTroops) :-
    infoPlayer(KodePemain, Nama, ListWilayah, ListBenua, TentaraAktif, TentaraTambahan, _),
    SisaTroops is TentaraAktif - JumlahTroops,
    retract(wilayah(A, KodePemain, Wilayah, B, _, C)),
    asserta(wilayah(A, KodePemain, Wilayah, B, JumlahTroops, C)),
    retract(infoPlayer(KodePemain, Nama, ListWilayah, ListBenua, TentaraAktif, TentaraTambahan, _)),
    asserta(infoPlayer(KodePemain, Nama, ListWilayah, ListBenua, SisaTroops, TentaraTambahan, _)).
