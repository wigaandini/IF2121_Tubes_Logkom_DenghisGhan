# Tugas-Besar-Logika-Komputasional-2023-denghis-ghan
Global Conquest: Battle for Supremacy
> built using GNU Prolog programming language.

## Table of Contents

-   [General Info](#general-information)
-   [Team Members](#team-members)
-   [How to Run](#how-to-run)
-   [Program Structure](#program-structure)

## General Information

```
#################################################################################################
#         AMERIKA UTARA         #        EROPA          #                 ASIA                  #
#                               #                       #                                       #
#       [NA1(4)]-[NA2(1)]       #                       #                                       #
-----------|       |----[NA5(2)]----[E1(11)]-[E2(4)]----------[A1(1)] [A2(13)] [A3(3)]-----------
#       [NA3(3)]-[NA4(1)]       #       |       |       #        |       |       |              #
#          |                    #    [E3(3)]-[E4(2)]    ####     |       |       |              #
###########|#####################       |       |-[E5(2)]-----[A4(3)]----+----[A5(4)]           #
#          |                    ########|#######|###########             |                      #
#       [SA1(11)]               #       |       |          #             |                      #
#          |                    #       |    [AF2(14)]     #          [A6(1)]---[A7(2)]         #
#   |---[SA2(2)]---------------------[AF1(3)]---|          #             |                      #
#   |                           #               |          ##############|#######################
#   |                           #            [AF3(2)]      #             |                      #
----|                           #                          #          [AU1(7)]---[AU2(13)]-------
#                               #                          #                                    #
#       AMERIKA SELATAN         #         AFRIKA           #          AUSTRALIA                 #
#################################################################################################
```

## Team Members

| **NIM**  |       **Nama**             |
| :------: | :-------------------:      |
| 13522013 | Denise Felicia Tiowanni    |
| 13522042 |      Amalia Putri          |
| 13522053 | Erdianti Wiga Putri Andini |
| 13522058 | Imanuel Sebastian Girsang  |

## How to Run

1. Install GNU Prolog Console.

2. Clone this repository.
```
$ git clone https://github.com/GAIB21/tugas-besar-if2121-logika-komputasional-2023-denghis-ghan.git
```

3. Open GNU Prolog Console and change working directory using `change_directory('directory').`. Navigate to `src` folder.

4. Consult `initiate.pl` file using `consult('initiate.pl').` in GNU Prolog Console.

5. Run initiate.pl with the argument below

```
$ startGame.
```

## Program Structure

```
.
│   README.md
|
└───doc
|   └───Progress1_G03.pdf
|       Progress2_G03.pdf
|       Laporan_G03.pdf
|
└───src
    |
    └───attack.pl
        dynamicfacts.pl
        initiate.pl
        map.pl
        player.pl
        risk.pl
        rules.pl
        staticfacts.pl
        troops.pl
        turn.pl
        utilities.pl
        wilayah.pl
```

