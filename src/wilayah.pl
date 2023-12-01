tetanggaList(KodeWilayah, ListTetangga) :-
    findall(
        NamaTetangga,
        (
            bertetangga(KodeWilayah, Tetangga),
            wilayah(NamaTetangga, _, Tetangga, _, _, _)
        ),
        ListTetangga
    ).
    
writeTetangga(ListTetangga) :-
    write('Tetangga: '),
    print_list_elements(ListTetangga),
    nl.

checkLocationDetail(KodeWilayah) :-
    wilayah(NamaWilayah, _, KodeWilayah, _NamaBenua, JumlahTroops, _),
    convert_to_uppercase(KodeWilayah, KodeWilayahUpper),
    write('Kode: '), write(KodeWilayahUpper), nl,
    write('Nama: '), write(NamaWilayah), nl,
    write('Total Tentara: '), write(JumlahTroops), nl,
    tetanggaList(KodeWilayah, ListTetangga),
    writeTetangga(ListTetangga), !.