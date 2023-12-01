/* IMPORT */
% :-include('utilities.pl').
% :-include('dynamicfacts.pl').
% :-include('staticfacts.pl').
% :-include('risk.pl').

/* UJI INISIALISASI */
initplayerturn:-
    asserta(totalMoves(1, 0)),
    asserta(totalMoves(2, 0)),
    asserta(ceasefire(1,0)),
    asserta(ceasefire(2,0)),
    asserta(supplyissue(1,0)),
    asserta(supplyissue(2,1)),
    asserta(disease(1,0)),
    asserta(disease(2,0)),
    asserta(hasrisked(1,0)),
    asserta(hasrisked(2,0)),
    asserta(hasattacked(1,0)),
    asserta(hasattacked(2,0)),
    asserta(supersoldier(1,0)),
    asserta(supersoldier(2,0)),

    asserta(whoseTurn(1)), 

    asserta(infoPlayer(1, 'AMEL', [na1, na2, na3, na4, na5, sa2], ['AMERIKA UTARA', 'ASIA'], 10, 1, 0)),
    asserta(infoPlayer(2, 'WIGA', [sa1, af3, a2], ['AMERIKA UTARA', 'AMERIKA SELATAN', 'AFRIKA', 'ASIA'], 10, 1, 0)),
    
    asserta(wilayah(_, 1, na1, 'AMERIKA UTARA', 10, 0)),
    asserta(wilayah(_, 1, na2, 'AMERIKA UTARA', 10, 0)),
    asserta(wilayah(_, 1, na3, 'AMERIKA UTARA', 10, 0)),
    asserta(wilayah(_, 1, na4, 'AMERIKA UTARA', 10, 0)),
    asserta(wilayah(_, 1, na5, 'AMERIKA UTARA', 10, 0)),
    asserta(wilayah(_, 1, sa2, 'AMERIKA SELATAN', 10, 0)),
    
    asserta(wilayah(_, 2, sa1, 'AMERIKA SELATAN', 2, 0)),
    asserta(wilayah(_, 2, af3, 'AFRIKA', 1, 0)),
    asserta(wilayah(_, 2, a2, 'ASIA', 1, 0)),
    asserta(playerListAfterOrder([1, 2])),
    
    asserta(auxiliary(1, 0)),
    asserta(auxiliary(2, 0)),

    asserta(jumlahDadu(1, 0)),
    asserta(jumlahDadu(2, 0)).


/* END TURN */
endTurn :-
    whoseTurn(CurrentPlayer),
    getNamaFromKode(CurrentPlayer, Nama),
    format('Player ~w mengakhiri giliran.', [Nama]), nl,

    findNextPlayer(NextPlayer),
    getNamaFromKode(NextPlayer, NamaNext),


    % Reset jumlah dadu
    /* retract(jumlahDadu(CurrentPlayer, _)),
    asserta(jumlahDadu(CurrentPlayer, 0)),
    retract(jumlahDadu(NextPlayer, _)),
    asserta(jumlahDadu(NextPlayer, 0)), */

    % Hitung bonus troops from territories
    getJumlahWilayah(NextPlayer, JumlahWilayah),
    % Jumlah div 2
    BonusTroopsFromWilayah is JumlahWilayah // 2,

    % Hitung bonus troops from continent control
    % Jika menguasai benua, dapat bonus tertentu
    getTotalTroopsBonus(NextPlayer, BonusBenua),
    
    % Hitung total troops bonus
    TotalTroopsBonus is BonusTroopsFromWilayah + BonusBenua,
    
    nl,
    (auxiliary(NextPlayer, 1) -> 
        TotalTroopsBonusAux is TotalTroopsBonus * 2,
        format('Sekarang giliran Player ~w!', [NamaNext]), nl,
        format('Player ~w mendapatkan AUXILIARY TROOPS!', [NamaNext]), nl,

        nl,
        format('Player ~w mendapatkan ~w tentara tambahan.', [NamaNext, TotalTroopsBonusAux]), nl,

        % Update infoPlayer untuk NextPlayer
        retract(infoPlayer(NextPlayer, NamaNext, C, D, E, Total, G)),
        NewTotal is TotalTroopsBonusAux + Total,
        asserta(infoPlayer(NextPlayer, NamaNext, C, D, E, NewTotal, G))
    ;
        (supplyissue(NextPlayer, 1) -> 
            TotalTroopsBonusSupp is TotalTroopsBonus * 0,
            format('Sekarang giliran Player ~w!', [NamaNext]), nl,
            format('Player ~w terdampak SUPPLY CHAIN ISSUE!', [NamaNext]), nl,

            nl,
            format('Player ~w tidak mendapatkan tentara tambahan.', [NamaNext]), nl,

            % Update infoPlayer untuk NextPlayer
            retract(infoPlayer(NextPlayer, NamaNext, C, D, E, Total, G)),
            NewTotal is TotalTroopsBonusSupp + Total,
            asserta(infoPlayer(NextPlayer, NamaNext, C, D, E, NewTotal, G))
        ;
            format('Sekarang giliran Player ~w!', [NamaNext]), nl,
            format('Player ~w mendapatkan ~w tentara tambahan.', [NamaNext, TotalTroopsBonus]), nl,
            retract(infoPlayer(NextPlayer, Name, A, B, C, Total, D)),
            NewTotal is Total + TotalTroopsBonus,
            asserta(infoPlayer(NextPlayer, Name, A, B,C, NewTotal, D)))
    ),
    retract(whoseTurn(CurrentPlayer)),
    asserta(whoseTurn(NextPlayer)),

    resetRisk(NextPlayer),
    retract(playerListAfterOrder(PlayerList)),
    changeOrder(PlayerList, NewList),
    asserta(playerListAfterOrder(NewList)).
    % Update infoPlayer untuk NewPlayer.

/* DRAFT - MAIN PROGRAM */
draft(Wilayah, Troops) :-
    whoseTurn(CurrentPlayer),
    getNamaFromKode(CurrentPlayer, Nama),
    getTroopsFromWilayah(Wilayah, OldJumlahTentara),

    % Dapat tentara tambahan setelah endTurn
    infoPlayer(CurrentPlayer, Nama, _, _, _, TotalTroopsBonus, _),

    (isMenguasaiWilayah(CurrentPlayer, Wilayah, 1) ->
        convert_to_uppercase(Wilayah, WilayahUpper),
        format('Player ~w meletakkan ~w tentara tambahan di ~w.', [Nama, Troops, WilayahUpper]), nl,

        nl,
        NewTotalTroopsBonus is TotalTroopsBonus - Troops,
        NewJumlahTentara is OldJumlahTentara + Troops,

        (NewTotalTroopsBonus < 0 ->
            % Jika draft gagal, kembalikan wilayah ke keadaan semula
            write('Pasukan tidak mencukupi.'), nl,
            format('Jumlah Pasukan Tambahan Player ~w: ~w', [Nama, TotalTroopsBonus]), nl,
            write('draft dibatalkan.'), nl, !

        ;
            format('Tentara total di ~w: ~w', [Wilayah, NewJumlahTentara]), nl,
            format('Jumlah Pasukan Tambahan Player ~w: ~w', [Nama, NewTotalTroopsBonus]), nl,
            retract(wilayah(A, _, Wilayah, B, _, C)),
            asserta(wilayah(A, CurrentPlayer, Wilayah, B, NewJumlahTentara, C)), 
            
            retract(infoPlayer(CurrentPlayer, Nama, X, Y, AktifTentara, TotalTambahan, Z)),

            NewAktif is AktifTentara + Troops,
            NewBonus is TotalTambahan - Troops,
            
            asserta(infoPlayer(CurrentPlayer, Nama, X, Y, NewAktif, NewBonus, Z)), !
        )
    ; 
        true
    ).

% KASUS DRAFT GAGAL
draft(Wilayah, _Troops) :-
    whoseTurn(CurrentPlayer),
    getNamaFromKode(CurrentPlayer, Nama),
    \+ (isMenguasaiWilayah(CurrentPlayer, Wilayah, 1)),
    convert_to_uppercase(Wilayah, WilayahUpper),
    format('~w tidak memiliki wilayah ~w.', [Nama, WilayahUpper]), nl,
    write('draft dibatalkan.'), nl, !.


/* MOVE - MAIN PROGRAM */
move(WilayahAsal, WilayahTujuan, JumlahTentaraDipindahkan) :-
    whoseTurn(CurrentPlayer),
    getNamaFromKode(CurrentPlayer, Nama),
    
    
    wilayah(_,_,WilayahAsal,_,JumlahTentaraAsal,_),
    wilayah(_,_,WilayahTujuan,_,JumlahTentaraTujuan,_),

    % Check if the player has made maximum 3 moves in the current turn
    totalMoves(CurrentPlayer, JumlahMoves), JumlahMoves < 3,
    
    % Check if the player owns both the source and destination territories
    (isMenguasaiWilayah(CurrentPlayer, WilayahAsal, 1), isMenguasaiWilayah(CurrentPlayer, WilayahTujuan, 1)),

    % Ensure a valid number of troops are moved
    ((JumlahTentaraDipindahkan >= 1, JumlahTentaraDipindahkan < JumlahTentaraAsal) ->
        % Successfully moved troops from WilayahAsal to WilayahTujuan with JumlahTentaraDipindahkan
        convert_to_uppercase(WilayahAsal, WilayahAsalUpper),
        convert_to_uppercase(WilayahTujuan, WilayahTujuanUpper),
        format('~w memindahkan ~w tentara dari ~w ke ~w.', [Nama, JumlahTentaraDipindahkan, WilayahAsalUpper, WilayahTujuanUpper]), nl,

        % Update troops in source and destination territories
        NewJumlahTentaraAsal is JumlahTentaraAsal - JumlahTentaraDipindahkan,
        NewJumlahTentaraTujuan is JumlahTentaraTujuan + JumlahTentaraDipindahkan,

        format('Jumlah tentara di ~w: ~w', [WilayahAsalUpper, NewJumlahTentaraAsal]), nl,
        format('Jumlah tentara di ~w: ~w', [WilayahTujuanUpper, NewJumlahTentaraTujuan]), nl,

        retract(wilayah(A, _, WilayahAsal, B, _, C)),
        asserta(wilayah(A, CurrentPlayer, WilayahAsal, B, NewJumlahTentaraAsal, C)),

        retract(wilayah(A, _, WilayahTujuan, B, _, C)),
        asserta(wilayah(A, CurrentPlayer, WilayahTujuan, B, NewJumlahTentaraTujuan, C)),

        % Update totalMoves counter
        retract(totalMoves(CurrentPlayer, JumlahMoves)),
        NewJumlahMoves is JumlahMoves + 1,
        asserta(totalMoves(CurrentPlayer, NewJumlahMoves))
    ;
        write('Jumlah tentara yang dipindahkan tidak valid.'), nl,
        write('Pemindahan dibatalkan.'), nl), !.

% KASUS MOVE GAGAL
move(_WilayahAsal, _WilayahTujuan, _JumlahTentaraDipindahkan) :-
    whoseTurn(CurrentPlayer),
    getNamaFromKode(CurrentPlayer, Nama),
    totalMoves(CurrentPlayer, JumlahMoves), JumlahMoves >= 3,
    write('Player '), write(Nama), write(' sudah tidak dapat MOVE lagi.'), nl,
    write('Pemindahan dibatalkan.'), nl,!.

move(WilayahAsal, WilayahTujuan, _JumlahTentaraDipindahkan) :-
    whoseTurn(CurrentPlayer),
    getNamaFromKode(CurrentPlayer, Nama),
    \+ (isMenguasaiWilayah(CurrentPlayer, WilayahAsal, 1)), 
    isMenguasaiWilayah(CurrentPlayer, WilayahTujuan, 1),
    convert_to_uppercase(WilayahAsal, WilayahAsalUpper),
    format('~w tidak memiliki wilayah ~w.', [Nama, WilayahAsalUpper]), nl,
    write('Pemindahan dibatalkan.'), nl, !.

move(WilayahAsal, WilayahTujuan, _JumlahTentaraDipindahkan) :-
    whoseTurn(CurrentPlayer),
    getNamaFromKode(CurrentPlayer, Nama),
    \+ (isMenguasaiWilayah(CurrentPlayer, WilayahTujuan, 1)), 
    isMenguasaiWilayah(CurrentPlayer, WilayahAsal, 1),
    convert_to_uppercase(WilayahTujuan, WilayahTujuanUpper),
    format('~w tidak memiliki wilayah ~w.', [Nama, WilayahTujuanUpper]), nl,
    write('Pemindahan dibatalkan.'), nl, !.

move(WilayahAsal, WilayahTujuan, _JumlahTentaraDipindahkan) :-
    whoseTurn(CurrentPlayer),
    getNamaFromKode(CurrentPlayer, Nama),
    \+ (isMenguasaiWilayah(CurrentPlayer, WilayahAsal, 1), isMenguasaiWilayah(CurrentPlayer, WilayahTujuan, 1)),
    convert_to_uppercase(WilayahAsal, WilayahAsalUpper),
    convert_to_uppercase(WilayahTujuan, WilayahTujuanUpper),
    format('~w tidak memiliki kedua wilayah ~w dan ~w.', [Nama, WilayahAsalUpper, WilayahTujuanUpper]), nl,
    write('Pemindahan dibatalkan.'), nl, !.