listBenuaDikuasai(KodePemain, ListBenuaDikuasai) :-
    benua(BenuaList),
    findall(
        Benua,
        (
            member(Benua, BenuaList),
            isMenguasai(KodePemain, Benua, 1)
        ),
        ListBenuaDikuasai
    ).

listWilayahDiBenua(KodePemain, KodeBenua, ListWilayahDiBenua) :-
    findall(
        NamaWilayah,
        (
            wilayah(_, KodePemain, NamaWilayah, KodeBenua, _, _)
        ),
        ListWilayahDiBenua
    ).

print_list_benua([]).
print_list_benua([KodeBenua|Tail]) :-
    listWilayahDiBenua(_, KodeBenua, ListWilayahDiBenua),
    length(ListWilayahDiBenua, JumlahWilayah),
    (JumlahWilayah > 0 ->
        write(KodeBenua),
        benua(NamaBenua),
        format('Nama: ~w.~n', [NamaBenua]),
        format('Jumlah Wilayah: ~w.~n', [JumlahWilayah]),
        totalTroopsBenua(KodeBenua, JumlahTroopsBenua),
        format('Jumlah Tentara: ~w.~n', [JumlahTroopsBenua]),
        nl
    ;
        true
    ),
    print_list_benua(Tail).

displayWilayahBenuaDimiliki(KodePemain, KodeBenua) :-
    listWilayahDiBenua(KodePemain, KodeBenua, ListWilayahDiBenua),
    totalWilayahInBenua(KodeBenua, JumlahWilayah),
    length(ListWilayahDiBenua, JumlahWilayahDimiliki),
    (JumlahWilayahDimiliki > 0 -> 
        format('Benua ~w (~d/~d).~n', [KodeBenua, JumlahWilayahDimiliki, JumlahWilayah]),
        print_list_wilayah_benua(KodeBenua, ListWilayahDiBenua)
    ;
        true
    ).

print_list_wilayah_benua(_, []).
print_list_wilayah_benua(KodeBenua, [KodeWilayah|Tail]) :-
    convert_to_uppercase(KodeWilayah, KodeUpper),
    write(KodeUpper), nl,
    wilayah(NamaWilayah, _, KodeWilayah, KodeBenua, JumlahTroopsWilayah, _),
    format('Nama              : ~w.~n', [NamaWilayah]),
    format('Jumlah Tentara    : ~w.~n', [JumlahTroopsWilayah]),
    nl,
    print_list_wilayah_benua(KodeBenua, Tail).

print_list_wilayah_benua(_, []).

writeBenuaDikuasai(ListBenuaDikuasai) :-
    write('Benua: '),
    (ListBenuaDikuasai == [] ->
        write('Pemain ini tidak menguasai benua manapun.'), nl
    ;
        print_list_elements(ListBenuaDikuasai)
    ).

checkPlayerTerritories(KodePemain) :-
    infoPlayer(KodePemain, NamaPemain, ListWilayah, ListBenua, TentaraAktif, TentaraTambahan, _),
    getNamaFromKode(KodePemain, NamaPemain),
    write('Nama: '), write(NamaPemain), nl, nl,
    displayWilayahBenuaDimiliki(KodePemain, 'AMERIKA UTARA'),
    displayWilayahBenuaDimiliki(KodePemain, 'AMERIKA SELATAN'),
    displayWilayahBenuaDimiliki(KodePemain, 'EROPA'),
    displayWilayahBenuaDimiliki(KodePemain, 'ASIA'), 
    displayWilayahBenuaDimiliki(KodePemain, 'AFRIKA'),
    displayWilayahBenuaDimiliki(KodePemain, 'AUSTRALIA'), !.

/* infoplayer(KodePemain, NamaPemain, ListWilayah, ListBenua, TentaraAktif, TentaraTambahan, RollDice) */
/* contoh :     */
checkPlayerDetail(KodePemain) :-
    infoPlayer(KodePemain, NamaPemain, ListWilayah, _ListBenua, TentaraAktif, TentaraTambahan, _),
    getNamaFromKode(KodePemain, NamaPemain),
    write('Nama: '), write(NamaPemain), nl,
    length(ListWilayah, JumlahWilayah),
    write('Total Wilayah: '), write(JumlahWilayah), nl,
    listBenuaDikuasai(KodePemain, ListBenuaDikuasai),
    writeBenuaDikuasai(ListBenuaDikuasai),
    write('Total Tentara Aktif: '), write(TentaraAktif), nl,
    write('Total Tentara Tambahan: '), write(TentaraTambahan), nl, !.

print_bonus_troops_list([]).
print_bonus_troops_list([KodeBenua|Tail]) :-
    bonusTroops(KodeBenua, BonusTroops),
    format('Bonus benua ~w: ~w.~n', [KodeBenua, BonusTroops]),
    print_bonus_troops_list(Tail).

troopsBenuaDikuasai(KodePemain, ListBenuaDikuasai, TotalBonusTroops) :-
    benua(BenuaList),
    findall(
        Benua,
        (
            member(Benua, BenuaList),
            isMenguasai(KodePemain, Benua, 1)
        ),
        ListBenuaDikuasai
    ),
    calculateBonusTroops(ListBenuaDikuasai, TotalBonusTroops).

calculateBonusTroops([], 0).
calculateBonusTroops([Benua|Rest], TotalBonusTroops) :-
    totalWilayahInBenua(Benua, TotalWilayah),
    calculateBonusTroops(Rest, RemainingBonusTroops),
    TotalBonusTroops is RemainingBonusTroops + TotalWilayah.

checkIncomingTroops(KodePemain) :-
    infoPlayer(KodePemain, NamaPemain, ListWilayah, ListBenua, _TentaraAktif, TentaraTambahan, _),
    getNamaFromKode(KodePemain, NamaPemain),
    length(ListWilayah, JumlahWilayah),
    write('Nama: '), write(NamaPemain), nl,
    write('Total Wilayah: '), write(JumlahWilayah), nl,
    TroopsTambahanWilayah is JumlahWilayah div 2,
    write('Jumlah tentara tambahan dari wilayah: '), write(TroopsTambahanWilayah), nl,
    listBenuaDikuasai(KodePemain, ListBenuaDikuasai),
    print_bonus_troops_list(ListBenuaDikuasai),
    troopsBenuaDikuasai(KodePemain, ListBenuaDikuasai, TotalBonusTroops),
    TotalTentaraTambahan is TroopsTambahanWilayah + TotalBonusTroops,
    write('Total Tentara Tambahan: '), write(TotalTentaraTambahan), nl.