% STATIC
/* Hubungan antar wilayah (ketetanggaan) - bertetangga(X, Y). */
bertetangga(na1, na2).
bertetangga(na1, na3).
bertetangga(na2, na5).
bertetangga(na2, na1).
bertetangga(na2, na4).
bertetangga(na3, na4).
bertetangga(na3, na1).
bertetangga(na3, sa1).
bertetangga(na4, na3).
bertetangga(na4, na2).
bertetangga(na4, na5).
bertetangga(na5, na2).
bertetangga(na5, na4).
bertetangga(na5, e1).

bertetangga(e1, e2).
bertetangga(e1, e3).
bertetangga(e1, na5).
bertetangga(e2, e1).
bertetangga(e2, e4).
bertetangga(e2, a1).
bertetangga(e3, e1).
bertetangga(e3, e4).
bertetangga(e3, af1).
bertetangga(e4, e5).
bertetangga(e4, e3).
bertetangga(e4, e2).
bertetangga(e4, af2).
bertetangga(e5, e4).
bertetangga(e5, af2).
bertetangga(e5, a4).

bertetangga(a1, e2).
bertetangga(a1, a4).
bertetangga(a2, a4).
bertetangga(a2, a5).
bertetangga(a3, a5).
bertetangga(a4, a1).
bertetangga(a4, a5).
bertetangga(a4, a6).
bertetangga(a4, e5).
bertetangga(a5, a3).
bertetangga(a5, a4).
bertetangga(a5, a6).
bertetangga(a6, a4).
bertetangga(a6, a5).
bertetangga(a6, a7).
bertetangga(a6, au1).
bertetangga(a7, a6).

bertetangga(au1, au2).
bertetangga(au1, a6).
bertetangga(au2, au1).

bertetangga(af1, af2).
bertetangga(af1, af3).
bertetangga(af1, e3).
bertetangga(af1, sa2).
bertetangga(af2, af3).
bertetangga(af2, af1).
bertetangga(af2, e4).
bertetangga(af2, e5).
bertetangga(af3, af1).
bertetangga(af3, af2).

bertetangga(sa1, sa2).
bertetangga(sa1, na3).
bertetangga(sa2, sa1).
bertetangga(sa2, af1).

/* Batas antar benua - batas_benua(X, Y).*/
batas_benua(na5, e1).
batas_benua(na3, sa1).
batas_benua(e1, na5).
batas_benua(e2, a1).
batas_benua(e3, af1).
batas_benua(e4, af2).
batas_benua(e5, a4).
batas_benua(a1, e2).
batas_benua(a4, e5).
batas_benua(a6, au1).
batas_benua(au1, a6).
batas_benua(af1, e3).
batas_benua(af1, sa2).
batas_benua(af2, e4).
batas_benua(sa1, na3).
batas_benua(sa2, af1).

/* Pemain terakhir yang melakukan roll - lastPlayerRoll(X).*/
lastPlayerRoll(p1).
lastPlayerRoll(p2).
lastPlayerRoll(p3).
lastPlayerRoll(p4).

/* Bonus tentara tiap Benua - bonusTroops(X, Y). */
bonusTroops('AMERIKA UTARA', 5).
bonusTroops('EROPA', 5).
bonusTroops('ASIA', 7).
bonusTroops('AMERIKA SELATAN', 2).
bonusTroops('AFRIKA', 3).
bonusTroops('AUSTRALIA', 2).

/* Tentara awal player tiap player - initialTroops(X, Y). */
/* X = jumlah player, Y = jumlah tentara awal per player */
initialTroops(2, 24).
initialTroops(3, 16).
initialTroops(4, 12).

/* TOTAL WILAYAH */
totalWilayahInBenua('AMERIKA UTARA', 5).
totalWilayahInBenua('EROPA', 5).
totalWilayahInBenua('ASIA', 7).
totalWilayahInBenua('AMERIKA SELATAN', 2).
totalWilayahInBenua('AFRIKA', 3).
totalWilayahInBenua('AUSTRALIA', 2).

/* DATA BENUA */
benua(['AMERIKA UTARA', 'AMERIKA SELATAN', 'EROPA', 'AFRIKA', 'ASIA', 'AUSTRALIA']).

% wilayahList([na1, na2, na3, na4, na5, sa1, sa2, e1, e2, e3, e4, e5, af1, af2, af3, a1, a2, a3, a4, a5, a6, a7, au1, au2]).