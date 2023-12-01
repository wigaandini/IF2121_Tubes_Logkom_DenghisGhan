attack :-
    whoseTurn(CurrentPlayer),
    (hasattacked(CurrentPlayer,1) -> write('Anda sudah menyerang!'),nl,fail ; true),
    
    getNamaFromKode(CurrentPlayer, NamaAttacker),
    write('Sekarang giliran player '), write(NamaAttacker), nl,

    displayMap,
    repeat,
    nl,
    write('Pilihlah daerah yang ingin Anda mulai untuk melakukan penyerangan: '),
    read(Region),
    isWilayah(CurrentPlayer, Region, Result),
    (Result =:= 1 ->
    nl
    ; 
    nl,
        write('Daerah yang Anda pilih bukan daerah Anda! Silahkan pilih daerah lain.'), nl,
        fail  % Repeat the loop
    ),
    !,
    getNumTroops(Region, NumTroops),

    nl,
    convert_to_uppercase(Region, RegionUpper),
    write('Player '), write(NamaAttacker), write(' ingin memulai penyerangan dari daerah '), write(RegionUpper), write('.'), nl,
    write('Dalam daerah '), write(Region), write(' Anda memiliki sebanyak '), write(NumTroops), write(' tentara'), nl,nl,
    
    repeat,nl,
    write('Masukkan banyak tentara yang akan bertempur: '), read(NumTroopsAttack),
    (   NumTroopsAttack =< NumTroops-1,
        NumTroopsAttack > 1 ->
        nl,
        write('Player '), write(NamaAttacker),
        write(' mengirim sebanyak '), write(NumTroopsAttack),
        write(' tentara untuk berperang.'), nl
    ;
        nl,
        write('Jumlah tentara yang Anda masukkan tidak valid! Silahkan masukkan jumlah tentara yang valid.'), nl,
        fail
    ),
    !,

    displayMap,
    write('Pilihlah daerah yang ingin Anda serang.'),nl,
    getAllAvailableTetangga(Region, CurrentPlayer, List),
    length(List, Max),
    writePossibleWilayah(1,List, Max),
    
    
    repeat,
    nl,
    write('Pilih: '), read(Option), nl,
    (Option =< Max, Option>=1 ->
        nth1(Option,List,RegionAttack),
        convert_to_uppercase(RegionAttack, RegionAttackUpper),
        (wilayah(_,_,RegionAttack,_,_,Status), Status =:= 0 ->
            nl, write('Tidak bisa menyerang!'), nl,
            format('Wilayah ~w dalam pengaruh CEASEFIRE ORDER.',[RegionAttackUpper]), nl,fail
            ;
            format('Perang terhadap wilayah ~w telah dimulai.', [RegionAttackUpper]), nl,nl
        )
    ;
    write('Input tidak valid. Silahkan input kembali.'),nl,fail
    ),!,
    randomDiceAttack(CurrentPlayer, NumTroopsAttack), nl,

    wilayah(_,Defender, RegionAttack, _, NumTroopsDefend, _),
    randomDiceAttack(Defender, NumTroopsDefend),nl,
    getNamaFromKode(Defender, NamaDefender),

    
    jumlahDadu(CurrentPlayer,TotalAttack),
    jumlahDadu(Defender,TotalDefend),
    % Kasus Ketika Menang
    (TotalAttack > TotalDefend ->
    write('Player '), write(NamaAttacker), write(' menang! Wilayah '), write(RegionAttack), write(' sekarang dikuasai oleh '), write('Player '), write(NamaAttacker), write('.'), nl,
    repeat,
    nl,
    write('Silahkan tentukan banyaknya tentara yang menetap di wilayah '), write(RegionAttack), write(' : '), read(NumTroopsSent),
    (NumTroopsSent >= 1, NumTroopsSent =< NumTroopsAttack ->
        true
    ; 
        nl, write('Pasukan harus lebih dari atau sama dengan 1 dan kurang dari atau sama dengan yang berperang!'), nl, fail
    ),
    !,
    retract(wilayah(A,Defender, RegionAttack, Benua, _, Attackable)),
    asserta(wilayah(A,CurrentPlayer, RegionAttack, Benua, NumTroopsSent, Attackable)),
    retract(wilayah(B,CurrentPlayer, Region, Benua, _, Attackable1)),
    N is NumTroops - NumTroopsSent,
    asserta(wilayah(B,CurrentPlayer, Region, Benua, N, Attackable1)),
    write('Tentara di wilayah '), write(Region), write(' : '), TotalTroops is NumTroops - NumTroopsSent, write(TotalTroops), write('.'), nl,
    write('Tentara di wilayah '), write(RegionAttack), write(' : '), write(NumTroopsSent), write('.'), nl,
    updateWilayahAndBenua(CurrentPlayer),
    updateWilayahAndBenua(Defender),
    getJumlahWilayah(Defender, JumlahWilayah),
    (JumlahWilayah =:= 0 ->
    nl,
        write('Jumlah Wilayah Player '), write(NamaDefender), write(' 0.'), nl,
        write('Player '), write(NamaDefender), write(' keluar dari permainan!'), nl,
        retract(playerListAfterOrder(PlayerList)),
        delete(PlayerList, Defender, NewPlayerList),
        asserta(playerListAfterOrder(NewPlayerList)),
        (length(NewPlayerList, Len), Len =:= 1 ->
            write('******************************'), nl,
            write('* Player '), write(NamaAttacker), write(' menang!'), nl,
            write('*'), nl,
            write('* '), write(NamaAttacker), write(' telah menguasai dunia *'), nl,
            write('*'), nl,
            write('******************************'), nl
            ;true
        )
        ;
        true
    )
    ;
    % Kasus Ketika Kalah
    write('Player '), write(NamaDefender), write(' menang! Sayang sekali penyerangan anda gagal :(('), nl,
    write('Tentara di wilayah '), write(Region), write(' : '), NewNum is NumTroops - NumTroopsAttack, write(NewNum), write('.'), nl,
    retract(wilayah(A,CurrentPlayer, Region, Benua, _, Status)),
    asserta(wilayah(A,CurrentPlayer, Region, Benua, NewNum, Status)),
    write('Tentara di wilayah '), write(RegionAttack), write(' : '), write(NumTroopsDefend), write('.'), nl
    ),
    !,
    
    retract(hasattacked(CurrentPlayer, 0)),
    asserta(hasattacked(CurrentPlayer, 1)).


%Untuk Write List Wilayah yang bisa di Attack
writePossibleWilayah(N,[], Max):- N is Max+1.
writePossibleWilayah(Num, [Wilayah | Rest], Max) :-
    write(Num), write('. '), write(Wilayah), nl,
    Next is Num + 1,
    writePossibleWilayah(Next, Rest, Max).


%Randomize Dice Attack
randomDiceAttack(Player, NumDice) :-
    
    getNamaFromKode(Player, NamaPlayer),
    write('Player '), write(NamaPlayer), nl,
    
    isSuperSoldier(Player, X),
    (X =:= 1 -> format('Tentara ~w dalam pengaruh SUPER SOLDIER SERUM.', [NamaPlayer]), nl ; true),
    isDisease(Player, Y),
    (Y =:= 1 -> format('Tentara ~w dalam pengaruh DISEASE OUTBREAK.', [NamaPlayer]), nl ; true),
    rollDices(NumDice, DiceRolls, X, Y),
    displayDiceRolls(1, DiceRolls, NumDice),

    
    sumList(DiceRolls, Total),
    write('Total: '), write(Total), write('.'), nl,
    retract(jumlahDadu(Player,_)),
    asserta(jumlahDadu(Player,Total)).

rollOneDice(Result, X, Y) :-
    (   X =:= 1 ->
        Result is 6
    ;   Y =:= 1 ->
        Result is 1
    ;   random(1, 7, Result)
    ).
%
rollDices(0, [],_,_).
rollDices(N, [Result | Results],X,Y) :-
    N > 0,
    rollOneDice(Result, X, Y),
    Next is N - 1,
    rollDices(Next, Results, X,Y).

displayDiceRolls(N,[],Max):- N is Max+1.
displayDiceRolls(Num, [Roll | Rest], Max) :-
    write('Dadu '), write(Num), write(': '), write(Roll), write('.'), nl,
    Next is Num + 1,
    displayDiceRolls(Next, Rest, Max).
