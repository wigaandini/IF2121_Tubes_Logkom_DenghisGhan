isCeaseFire(X, R) :- ceasefire(X, Result), R is Result.
isSuperSoldier(X, R) :- supersoldier(X, Result), R is Result.
isAuxiliary(X, R) :- auxiliary(X, Result), R is Result.
isDisease(X, R) :- disease(X, Result), R is Result.
isSupplyIssue(X, R) :- supplyissue(X, Result), R is Result.

risk_scenarios([
    'CEASEFIRE ORDER',
    'SUPER SOLDIER SERUM',
    'AUXILIARY TROOPS',
    'REBELLION',
    'DISEASE OUTBREAK',
    'SUPPLY CHAIN ISSUE'
]).
initiateRiskTest:-
    asserta(totalMoves(1, 0)),
    asserta(totalMoves(2, 0)),

    asserta(whoseTurn(1)), 
    asserta(infoPlayer(1, 'AMEL', [na1, na2, na3, na4, na5, sa2], ['AMERIKA UTARA', 'ASIA'], 10, 1, _)),
    asserta(infoPlayer(2, 'WIGA', [sa1, af3, a2], ['AMERIKA UTARA', 'AMERIKA SELATAN', 'AFRIKA', 'ASIA'], 10, 1, _)),
    
    asserta(wilayah('Hm', 1, na1, 'AMERIKA UTARA', 10, 1)),
    asserta(wilayah('Hm', 1, na2, 'AMERIKA UTARA', 10, 1)),
    asserta(wilayah('Hm', 1, na3, 'AMERIKA UTARA', 10, 1)),
    asserta(wilayah('Hm', 1, na4, 'AMERIKA UTARA', 10, 1)),
    asserta(wilayah('Hm', 1, na5, 'AMERIKA UTARA', 10, 1)),
    asserta(wilayah('Hm', 1, sa2, 'AMERIKA SELATAN', 10, 1)),
    
    asserta(wilayah('Hm', 2, sa1, 'AMERIKA SELATAN', 2, 1)),
    asserta(wilayah('Hm', 2, af3, 'AFRIKA', 1, 1)),
    asserta(wilayah('Hm', 2, a2, 'ASIA', 1, 1)),

    asserta(playerListAfterOrder([1,2])),
    initiateRisk(1),
    initiateRisk(2),
    asserta(jumlahDadu(1, 0)),
    asserta(jumlahDadu(2, 0)).

initiateRisk(NextPlayer) :- 
    asserta(ceasefire(NextPlayer, 0)),
    asserta(supersoldier(NextPlayer, 0)),
    asserta(supplyissue(NextPlayer, 0)),
    asserta(auxiliary(NextPlayer, 0)),
    asserta(disease(NextPlayer, 0)),
    asserta(hasrisked(NextPlayer, 0)),
    asserta(hasattacked(NextPlayer, 0)),
    asserta(jumlahDadu(NextPlayer, 0)),
    asserta(totalMoves(NextPlayer, 0)).


% buat reset risk
resetRisk(NextPlayer) :-
    
    retract(ceasefire(NextPlayer, _)),
    retract(supersoldier(NextPlayer, _)),
    retract(supplyissue(NextPlayer, _)),
    retract(auxiliary(NextPlayer, _)),
    
    retract(disease(NextPlayer, _)),
    retract(hasrisked(NextPlayer, _)),
    
    retract(hasattacked(NextPlayer, _)),
    
    retract(totalMoves(NextPlayer, _)),
    retract(jumlahDadu(NextPlayer, _)),
    initiateRisk(NextPlayer).

% Ini buat manggil rules
risk:-
    (hasrisked(CurrentPlayer, 1) ->
        write('Anda sudah mendapatkan risk card pada giliran ini.'), nl,fail
    ;true),
    whoseTurn(CurrentPlayer),
    riskit(CurrentPlayer).
% Ini buat ngerandom risknya
riskit(CurrentPlayer) :-
    risk_scenarios(Scenarios),
    random_member(Scenario, Scenarios),
    getNamaFromKode(CurrentPlayer, Nama),
    write('Player '), write(Nama), write(' mendapatkan risk card '), write(Scenario), nl,
    apply_risk(Scenario, CurrentPlayer),
    retract(hasrisked(CurrentPlayer, _)),
    asserta(hasrisked(CurrentPlayer, 1)).

apply_risk('CEASEFIRE ORDER', CurrentPlayer):-
    write('Hingga giliran berikutnya, wilayah pemain tidak dapat diserang oleh lawan.'), nl,
    findall(wilayah(A,CurrentPlayer, X, Y, Z, 1), wilayah(A,CurrentPlayer, X, Y, Z, 1), Facts),
    update_facts(Facts, CurrentPlayer, 0),nl,
    retract(ceasefire(CurrentPlayer, _)),
    asserta(ceasefire(CurrentPlayer, 1)),!.

apply_risk('SUPER SOLDIER SERUM', CurrentPlayer) :-
    write('Hingga giliran berikutnya,'), nl,
    write('semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 6.'), nl,
    retract(supersoldier(CurrentPlayer, _)),
    asserta(supersoldier(CurrentPlayer, 1)),!.

apply_risk('AUXILIARY TROOPS', CurrentPlayer) :-
    write('Pada giliran berikutnya,'), nl,
    write('Tentara tambahan yang didapatkan pemain akan bernilai 2 kali lipat.'),nl,
    retract(auxiliary(CurrentPlayer, _)),
    asserta(auxiliary(CurrentPlayer, 1)),!.

apply_risk('REBELLION', CurrentPlayer) :-
    write('Salah satu wilayah acak pemain akan berpindah kekuasaan menjadi milik lawan.'), nl,
    findall(Wilayah, wilayah(_,CurrentPlayer, Wilayah,_,_,_), Facts),
    
    random_member(Hasil, Facts),
    playerListAfterOrder(List),
    length(List, NumPlayer),
    
    findall(Pemain, (infoPlayer(Pemain, _, _, _, _, _, _), Pemain \= CurrentPlayer), PlayerList),
    
    random_member(RandomPlayer, PlayerList),
    getNamaFromKode(CurrentPlayer, NamaNew),
    getNamaFromKode(RandomPlayer, Nama), nl,
    format('Wilayah ~w sekarang dikuasai oleh Player ~w .', [Hasil, Nama]), nl,
    isCeaseFire(RandomPlayer,Res),
    retract(wilayah(A, CurrentPlayer, Hasil, Y, Z, _)),
    asserta(wilayah(A, RandomPlayer, Hasil, Y, Z, Res)),
    updateWilayahAndBenua(CurrentPlayer),
    updateWilayahAndBenua(RandomPlayer),
    getJumlahWilayah(CurrentPlayer, JumlahWilayah),
    
    
    (JumlahWilayah =:= 0 ->
    nl,
        write('Jumlah Wilayah Player '), write(NamaNew), write(' 0.'), nl,
        write('Player '), write(NamaNew), write(' keluar dari permainan!'), nl,
        
        retract(playerListAfterOrder(PlayerListNew)),
        delete(PlayerListNew, CurrentPlayer, NewPlayerList),
        asserta(playerListAfterOrder(NewPlayerList)),
        (length(NewPlayerList, Len), Len =:= 1 ->
            write('******************************'), nl,
            write('* Player '), write(Nama), write(' menang!'), nl,
            write('*'), nl,
            write('* '), write(Nama), write(' telah menguasai dunia *'), nl,
            write('*'), nl,
            write('******************************'), nl
            ;true
        )
        ;
        true
    ),!.

apply_risk('DISEASE OUTBREAK', CurrentPlayer) :-
    write('Hingga giliran berikutnya,'), nl,
    write('semua hasil lemparan dadu saat penyerangan dan pertahanan akan bernilai 1.'), nl,
    retract(disease(CurrentPlayer, _)),
    asserta(disease(CurrentPlayer, 1)),!.

apply_risk('SUPPLY CHAIN ISSUE', CurrentPlayer) :-
    write('Pada giliran berkitnya, pemain tidak mendapatkan tentara tambahan.'), nl,
    retract(supplyissue(CurrentPlayer, _)),
    asserta(supplyissue(CurrentPlayer, 1)),!.

update_facts([], _, _).
update_facts([wilayah(A,CurrentPlayer, B, C, D, OldNum)|Rest], CurrentPlayer, Num) :-
    retract(wilayah(A,CurrentPlayer, B, C, D, OldNum)),
    asserta(wilayah(A,CurrentPlayer, B, C, D, Num)),
    update_facts(Rest, CurrentPlayer, Num).
    

random_member(X, List) :-
    length(List, Length),
    random(0, Length, Index),
    nth0(Index, List, X).