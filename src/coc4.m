#*************************************************************************************************************************
#
#Copyright or © or Copr.[DGFIP][2015]
#
#Ce logiciel a été initialement développé par la Direction Générale des 
#Finances Publiques pour permettre le calcul de l'impôt sur le revenu 2015 
#au titre des revenus perçus en 2014. La présente version a permis la 
#génération du moteur de calcul des chaînes de taxation des rôles d'impôt 
#sur le revenu de ce millésime.
#
#Ce logiciel est régi par la licence CeCILL 2.1 soumise au droit français 
#et respectant les principes de diffusion des logiciels libres. Vous pouvez 
#utiliser, modifier et/ou redistribuer ce programme sous les conditions de 
#la licence CeCILL 2.1 telle que diffusée par le CEA, le CNRS et l'INRIA  sur 
#le site "http://www.cecill.info".
#
#Le fait que vous puissiez accéder à cet en-tête signifie que vous avez pris 
#connaissance de la licence CeCILL 2.1 et que vous en avez accepté les termes.
#
#**************************************************************************************************************************
verif 700:
application : iliad ,batch ;

si
   RDCOM > 0
   et
   SOMMEA700 = 0

alors erreur A700 ;
verif 702:
application : batch , iliad ;

si
   (V_REGCO+0) dans (1,3,5,6,7)
   et
   INTDIFAGRI * positif(INTDIFAGRI) + 0 > RCMHAB * positif(RCMHAB) + COD2FA * positif(COD2FA) + 0

alors erreur A702 ;
verif 703:
application : batch , iliad ;

si
 (
  ( (positif(PRETUD+0) = 1 ou positif(PRETUDANT+0) = 1)
   et
    V_0DA < 1979
   et
    positif(BOOL_0AM+0) = 0 )
  ou
  ( (positif(PRETUD+0) = 1 ou positif(PRETUDANT+0) = 1)
   et
   positif(BOOL_0AM+0) = 1
   et
   V_0DA < 1979
   et
   V_0DB < 1979 )
  )
alors erreur A703 ;
verif 704:
application : batch , iliad ;

si
   (positif(CASEPRETUD + 0) = 1 et positif(PRETUDANT + 0) = 0)
   ou
   (positif(CASEPRETUD + 0) = 0 et positif(PRETUDANT + 0) = 1)

alors erreur A704 ;
verif 705:
application : batch , iliad ;

si
   CONVCREA + 0 > 15
   et
   V_IND_TRAIT > 0

alors erreur A705 ;
verif 706:
application : batch , iliad ;

si
   CONVHAND + 0 > CONVCREA + 0
   et
   V_IND_TRAIT > 0

alors erreur A706 ;
verif 2610:
application : batch , iliad ;

si
   RDENS + RDENL + RDENU > V_0CF + V_0DJ + V_0DN + 0

alors erreur A70701 ;
verif 2615:
application : batch , iliad ;

si
   RDENSQAR + RDENLQAR + RDENUQAR > V_0CH + V_0DP + 0

alors erreur A70702 ;
verif 2642:
application : iliad , batch;

si
   V_IND_TRAIT > 0
   et
   (
    RINVLOCINV + 0 > LIMLOC2
    ou
    RINVLOCREA + 0 > LIMLOC2
    ou
    INVLOCHOTR + 0 > LIMLOC2
    ou
    REPINVTOU + 0 > LIMLOC2
    ou
    INVLOGREHA + 0 > LIMLOC2
    ou
    INVLOGHOT + 0 > LIMLOC2
    ou
    INVLOCXN + 0 > LIMLOC2
    ou
    INVLOCXV + 0 > LIMLOC2
    ou
    COD7UY + 0 > LIMLOC2
    ou
    COD7UZ + 0 > LIMLOC2
   )

alors erreur A708 ;
verif 7091:
application : batch , iliad ;

si
   SOMMEA709 > 1

alors erreur A70901 ;
verif 7092:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(INVLOCHOTR) + positif(INVLOGHOT) > 1

alors erreur A70902 ;
verif 710:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(CREAIDE + 0) * positif(RVAIDE + 0) = 1

alors erreur A710 ;
verif 7111:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   INAIDE > 0
   et
   positif(RVAIDE + RVAIDAS + CREAIDE + 0) = 0

alors erreur A71101 ;
verif 7112:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(ASCAPA + 0) + positif(RVAIDAS + 0) = 1

alors erreur A71102 ;
verif 7113:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   PREMAIDE > 0
   et
   positif(RVAIDE + RVAIDAS + CREAIDE + 0) = 0

alors erreur A71103 ;
verif 712:
application : batch , iliad ;

si
   PRESCOMP2000 + 0 > PRESCOMPJUGE
   et
   positif(PRESCOMPJUGE) = 1

alors erreur A712 ;
verif non_auto_cc 2698:
application : batch , iliad ;

si
   (PRESCOMPJUGE + 0 > 0 et PRESCOMP2000 + 0 = 0)
   ou
   (PRESCOMPJUGE + 0 = 0 et PRESCOMP2000 + 0 > 0)

alors erreur A713 ;
verif 714:
application : batch , iliad ;

si
   RDPRESREPORT + 0 > 0
   et
   PRESCOMPJUGE + PRESCOMP2000 + 0 > 0

alors erreur A714 ;
verif 715:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   RDPRESREPORT + 0 > LIM_REPCOMPENS

alors erreur A715 ;
verif 716:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   ((SUBSTITRENTE < PRESCOMP2000 + 0)
    ou
    (SUBSTITRENTE > 0 et present(PRESCOMP2000) = 0))

alors erreur A716 ;
verif 7171:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(CELLIERFA) + positif(CELLIERFB) + positif(CELLIERFC) + positif(CELLIERFD) > 1

alors erreur A71701 ;
verif 7172:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   SOMMEA71701 > 1

alors erreur A71702 ;
verif 7173:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   SOMMEA71702 > 1

alors erreur A71703 ;
verif 7174:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(CELLIERHJ) + positif(CELLIERHK) + positif(CELLIERHN) + positif(CELLIERHO) > 1

alors erreur A71704 ;
verif 7175:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(CELLIERHL) + positif(CELLIERHM) > 1

alors erreur A71705 ;
verif 718:
application : batch , iliad ;

si
   CIAQCUL > 0
   et
   SOMMEA718 = 0

alors erreur A718 ;
verif 719:
application : batch , iliad ;

si
   RDMECENAT > 0
   et
   SOMMEA719 = 0

alors erreur A719 ;
verif 7301:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   REPFOR + 0 > 0
   et
   REPSINFOR1 + 0 > 0

alors erreur A73001 ;
verif 7302:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   REPFOR1 + 0 > 0
   et
   REPSINFOR2 + 0 > 0

alors erreur A73002 ;
verif 7303:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   REPFOR2 + 0 > 0
   et
   REPSINFOR3 + 0 > 0

alors erreur A73003 ;
verif 7304:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   REPFOR3 + 0 > 0
   et
   REPSINFOR4 + 0 > 0

alors erreur A73004 ;
verif 731:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   CASEPRETUD + 0 > 5

alors erreur A731 ;
verif 732:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   present(V_0SA) = 0
   et
   positif(V_BTRFRN1 + RFRN1 + 0) * positif(V_BTRFRN2 + RFRN2 + 0) = 0
   et
   positif(COD7RX + 0) = 0
   et
   positif(CIBOIBAIL + CINRJBAIL + CRENRJ + TRAMURWC + CINRJ + TRATOIVG + CIDEP15 
           + MATISOSI + TRAVITWT + MATISOSJ + VOLISO + PORENT + CHAUBOISN + POMPESP 
           + POMPESR + CHAUFSOL + POMPESQ + ENERGIEST + DIAGPERF + RESCHAL + 0) = 1
   et
   BQTRAV = 0

alors erreur A732 ;
verif 734:
application : batch , iliad ;

si
    positif(PTZDEVDUR + 0) = 1
    et
    positif(PTZDEVDURN + 0) = 1

alors erreur A734 ;
verif 735:
application : batch , iliad ;

si
   positif(PTZDEVDUR + 0) + positif(PTZDEVDURN + 0) = 1
   et
   positif(CIBOIBAIL + CINRJBAIL + CRENRJ + TRAMURWC + CINRJ + TRATOIVG + CIDEP15 + MATISOSI + TRAVITWT + MATISOSJ 
           + VOLISO + PORENT + CHAUBOISN + POMPESP + POMPESQ + POMPESR + CHAUFSOL + ENERGIEST + DIAGPERF + RESCHAL 
           + COD7SA + COD7SB + COD7SC + COD7WB + COD7RG + COD7VH + COD7RH + COD7RI + COD7WU + COD7RJ + COD7RK + COD7RL 
           + COD7RN + COD7RP + COD7RR + COD7RS + COD7RQ + COD7RT + COD7TV + COD7TW + COD7RV + COD7RW + COD7RZ + 0) = 0

alors erreur A735 ;
verif 736:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(DUFLOEK) + positif(DUFLOEL) + positif(PINELQA) + positif(PINELQB) + positif(PINELQC) + positif(PINELQD) + 0 > 2

alors erreur A736 ;
verif 737:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(COD7RX + V_0AX + V_0AY + V_0AZ + V_BTXYZ1 + V_BTXYZ2 + 0) = 1
   et
   1 - positif_ou_nul(COD7WX) = 1
   et
   positif(CIBOIBAIL + CINRJBAIL + CRENRJ + TRAMURWC + CINRJ + TRATOIVG + CIDEP15 
           + MATISOSI + TRAVITWT + MATISOSJ + VOLISO + PORENT + CHAUBOISN + POMPESP 
           + POMPESR + CHAUFSOL + POMPESQ + ENERGIEST + DIAGPERF + RESCHAL + 0) = 1
   et
   BQTRAV = 0

alors erreur A737 ;
verif 739:
application : batch , iliad ;

si
   positif(OPTPLAF15 + 0) = 1
   et
   SOMMEA739 = 0

alors erreur A739 ;
verif 7401:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   (CODHAE + CODHAJ + 0) > PLAF_INVDOM5
   et
   positif(CODHAO + CODHAT + CODHAY + CODHBG + 0) = 0

alors erreur A74001 ;
verif 7402:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   (CODHAO + CODHAT + CODHAY + CODHBG + 0) > PLAF_INVDOM6
   et
   positif(CODHAE + CODHAJ + 0) = 0

alors erreur A74002 ;
verif 7403:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   positif(CODHAE + CODHAJ + 0) = 1
   et
   positif(CODHAO + CODHAT + CODHAY + CODHBG + 0) = 1
   et
   (CODHAE + CODHAJ + CODHAO + CODHAT + CODHAY + CODHBG + 0) > PLAF_INVDOM6

alors erreur A74003 ;
verif 741:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   ((CELREPHR + 0 > PLAF_99999)
    ou
    (CELREPHS + 0 > PLAF_99999)
    ou
    (CELREPHT + 0 > PLAF_99999)
    ou
    (CELREPHU + 0 > PLAF_99999)
    ou
    (CELREPHV + 0 > PLAF_99999)
    ou
    (CELREPHW + 0 > PLAF_99999)
    ou
    (CELREPHX + 0 > PLAF_99999)
    ou
    (CELREPHZ + 0 > PLAF_99999))

alors erreur A741 ;
verif 743:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   (REPMEUBLE + 0 > PLAF_99999
    ou
    INVREPMEU + 0 > PLAF_99999
    ou
    INVREPNPRO + 0 > PLAF_99999
    ou
    INVNPROREP + 0 > PLAF_99999)

alors erreur A743 ;
verif 744:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   RISKTEC + 0 > PLAF_TEC

alors erreur A744 ;
verif 7461:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   CODHAE * positif(CODHAE + 0) > CODHAD * positif(CODHAD + 0) + 0

alors erreur A74601 ;
verif 7462:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   CODHAJ * positif(CODHAJ + 0) > CODHAI * positif(CODHAI + 0) + 0

alors erreur A74602 ;
verif 7463:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   CODHAO * positif(CODHAO + 0) > CODHAN * positif(CODHAN + 0) + 0

alors erreur A74603 ;
verif 7464:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   CODHAT * positif(CODHAT + 0) > CODHAS * positif(CODHAS + 0) + 0

alors erreur A74604 ;
verif 7465:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   CODHAY * positif(CODHAY + 0) > CODHAX * positif(CODHAX + 0) + 0

alors erreur A74605 ;
verif 7466:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   CODHBG * positif(CODHBG + 0) > CODHBF * positif(CODHBF + 0) + 0

alors erreur A74606 ;
verif 747:
application : iliad , batch ;

si
   FIPDOMCOM + 0 > 0
   et
   V_EAD + V_EAG + 0 = 0

alors erreur A747 ;
verif 748:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(CRECHOBOI + 0) = 1
   et
   positif(CIBOIBAIL + CINRJBAIL + CRENRJ + TRAMURWC + CINRJ + TRATOIVG + CIDEP15 + MATISOSI + TRAVITWT + MATISOSJ 
           + VOLISO + PORENT + CHAUBOISN + POMPESP + POMPESQ + POMPESR + CHAUFSOL + ENERGIEST + DIAGPERF + RESCHAL 
           + COD7SA + COD7SB + COD7SC + COD7WB + COD7RG + COD7VH + COD7RH + COD7RI + COD7WU + COD7RJ + COD7RK + COD7RL 
           + COD7RN + COD7RP + COD7RR + COD7RS + COD7RQ + COD7RT + COD7TV + COD7TW + COD7RV + COD7RW + COD7RZ + 0) = 0

alors erreur A748 ;
verif 7491:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   V_REGCO+0 != 2 et V_REGCO+0 != 4
   et
   positif(CRECHOBOI + 0) = 0
   et
   COD7WX + 0 > (CIBOIBAIL + CINRJBAIL + CRENRJ + TRAMURWC + CINRJ + TRATOIVG + CIDEP15 + MATISOSI + TRAVITWT + MATISOSJ
                 + VOLISO + PORENT + CHAUBOISN + POMPESP + POMPESQ + POMPESR + CHAUFSOL + ENERGIEST + DIAGPERF + RESCHAL + 0)

alors erreur A74901 ;
verif 7492:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   V_REGCO+0 != 2 et V_REGCO+0 != 4
   et
   positif(CRECHOBOI + 0) = 1
   et
   COD7WX + 0 > (CIBOIBAIL + CINRJBAIL + CRENRJ + TRAMURWC + CINRJ + TRATOIVG + CIDEP15 + MATISOSI 
                 + CHAUBOISN + POMPESP + POMPESQ + POMPESR + CHAUFSOL + ENERGIEST + DIAGPERF + RESCHAL + 0)

alors erreur A74902 ;
verif 7511:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(TRAVITWT + 0) + positif(MATISOSJ + 0) > 1

alors erreur A75101 ;
verif 7512:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(COD7WU + 0) + positif(COD7RJ + 0) > 1

alors erreur A75102 ;
verif 7513:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(TRAMURWC + 0) + positif(CINRJ + 0) > 1

alors erreur A75103 ;
verif 7514:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(COD7WB + 0) + positif(COD7RG + 0) > 1

alors erreur A75104 ;
verif 7515:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(TRATOIVG + 0) + positif(CIDEP15 + 0) > 1

alors erreur A75105 ;
verif 7516:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(COD7VH + 0) + positif(COD7RH + 0) > 1

alors erreur A75106 ;
