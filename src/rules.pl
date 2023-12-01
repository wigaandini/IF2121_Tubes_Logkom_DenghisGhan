# :- include('facts.pl')
# :- include('wilayah.pl')

# /* RULES */
# /*  X = nama pemain, 
#     Y = banyak dadu yang ingin di-roll oleh pemain X,
#     Z = status SSS (Super Soldier Serum)
#         0 → tidak
#         1 → iya,
#     A = status DO (Disease Outbreak) 
#         0 → tidak
#         1 → iya
# */
# randomDiceAttack(X, Y,  Z, A) :- 
    
# /*  X = nama pemain,
#     Y = banyak dadu yang di-roll (udah pasti 2),
#     R = result
# */
# randomDiceInit(X, 2,  R) :- random(2, 12, R) :-

# /*  X = kode wilayah,
#     R = jumlah troops di wilayah itu */
# getTroopsWilayah(X, R) :- 
#     wilayah(_, X, _, JT, _), 
#     R is JT.


# /*  W = kode pemain
#     X = jumlah tentara sekarang yang dimiliki
#     Y = status AT (Auxiliary Troops) → 0 jika tidak, 1 jika iua
#         Y = 1 →  X + (jumlah wilayah//2)*2 ATAU Y = 0 → X + (jumlah wilayah // 2)
#     Z = status SCI (Supply Chain Issue) → 0 jika tidak, 1 jika iya 
#         Z = 0 → X + (jumlah wilayah // 2) ATAU Z = 1 → X*/
# jumlahTroopsPemain(W, X, Y, Z)


# /*  W = wilayah yang akan diattack
#     X = jumlah troops di wilayah yang akan diattack
#     Y = wilayah kita yang mau ngeattack
#     Z = jumlah troops di wilayah kita yang mau ngeattack
#     A = is wilayah attackable? → RISK 1,
#         0 → tidak, 
#         1 → iya
#     R = attack berhasil/ ga, 
#         0 → ditolak (attack wilayah sendiri)
#         1 → menang (berhasil attack, jml dadu yg attack > jml dadu yg diattack)
#         2 → kalah (gagal attack jml dadu yg attack <= jml dadu yg diattack)

# */
# attackWilayah(W, X, Y, Z, A, R)

# /*  X = sum dice pemain yang ngeattack
#     Y = sum dice pemain yang diattack 
#     Res = sum dice yang lebih besar */
# maxDice (X, Y, Res)

# /*  X = wilayah 1
#     Y = wilayah
#     Res = kalo bertetangga → 1, kalo ga → 0 */
# isBertetangga(X, Y, res)

# /*  W = player yang lagi main
#     X = wilayah yang ingin didraft
#     Y = jumlah tentara tambahan
#     Z = jumlah tentara yang mau ditaroh
#     A = 0 jika bukan wilayah dia, 1 jika berhasil, 2 jika jumlah tentara yang ingin ditempatkan < jumlah tentara tambahan yang dimiliki */
# isDraftValid (W, X, Y, Z, A)

# /*  X = kode pemain
#     Y = wilayah yang dimaksud
#     Res = kalo wilayah dia → 1, kalo ga → 0 */
# isWilayah(X, Y, R) :-
#     wilayah(_, X, _, _, _),
#     wilayah(_, Y, _, _, _),
#     X \= Y,
#     R is 1.

# /*  X = kode pemain
#     Y = wilayah yang dimaksud
#     Z = jumlah tentara yang ingin ditaruh
#     R = 0 jika bukan wilayah, 1 jika berhasil, 2 jika tentara kurang */
# draftWilayah (X, Y,  Z, R) :-

# /*  X = kode player yang lagi turn
#     Y = benua (isMenguasaiBenua(X, Y))
#     Z = jumlah troops bonus yg didapat */
# getBonusTroops (X, Y, Z)

# /*  X = kode player
#     Y = access info player trus save nominal tentara tambahan
#     R = jumlah tentara tambahannya */
# getTentaraTambahan (X, Y, R)

# /*  W = kode player
#     X  = wilayah 1
#     Y = wilayah 2
#     Z = jumlah tentara X
#     Harus bikin check isWilayah X sama Y buat player W */
# isMoveValid (W, X, Y, Z)