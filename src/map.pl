/* display map */

getTentara(NamaWilayah, JumlahTentara) :-
    wilayah(_, _, NamaWilayah, _, JumlahTentara, _).

displayMap:-
    write('#################################################################################################'), nl,
    write('#         North America         #        Europe         #                 Asia                  #'), nl,
    write('#                               #                       #                                       #'), nl,
    write('#       [NA1('), getTentara(na1, TN1), write(TN1), write(')]-[NA2('), getTentara(na2, TN2), write(TN2), write(')]       #                       #                                       #'), nl,
    write('-----------|       |----[NA5('), getTentara(na5, TN5), write(TN5), write(')]----[E1('), getTentara(e1, TE1), write(TE1), write(')]-[E2('), getTentara(e2, TE2), write(TE2), write(')]----------[A1('), getTentara(a1, TA1), write(TA1), write(')] [A2('), getTentara(a2, TA2), write(TA2), write(')] [A3('), getTentara(a3, TA3), write(TA3), write(')]-------------'), nl,
    write('#       [NA3('), getTentara(na3, TN3), write(TN3), write(')]-[NA4('), getTentara(na4, TN4), write(TN4), write(')]       #       |       |       #        |       |       |              #'), nl,
    write('#          |                    #    [E3('), getTentara(e3, TE3), write(TE3), write(')]-[E4('), getTentara(e4, TE4), write(TE4), write(')]    ####     |       |       |              #'), nl,
    write('###########|#####################       |       |-[E5('), getTentara(e5, TE5), write(TE5), write(')]-----[A4('), getTentara(a4, TA4), write(TA4), write(')]----+----[A5('), getTentara(a5, TA5), write(TA5), write(')]           #'), nl,
    write('#          |                    ########|#######|###########             |                      #'), nl,
    write('#       [SA1('), getTentara(sa1, TSA1), write(TSA1), write(')]                #       |       |          #             |                      #'), nl,
    write('#          |                    #       |    [AF2('), getTentara(af2, TAF2), write(TAF2), write(')]      #          [A6('), getTentara(a6, TA6), write(TA6), write(')]---[A7('), getTentara(a7, TA7), write(TA7), write(')]         #'), nl,
    write('#   |---[SA2('), getTentara(sa2, TSA2), write(TSA2), write(')]---------------------[AF1('), getTentara(af1, TAF1), write(TAF1), write(')]---|          #             |                      #'), nl,
    write('#   |                           #               |          ##############|#######################'), nl,
    write('#   |                           #            [AF3('), getTentara(af3, TAF3), write(TAF3), write(')]      #             |                      #'), nl,
    write('----|                           #                          #          [AU1('), getTentara(au1, TAU1), write(TAU1), write(')]---[AU2('), getTentara(au2, TAU2), write(TAU2), write(')]--------'), nl,
    write('#                               #                          #                                    #'), nl,
    write('#       South America           #         Africa           #          Australia                 #'), nl,
    write('#################################################################################################'), nl,!.