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
verif 1301:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT > 0
   et
   (BAFV > PLAF_FORFBA
    ou
    BAFC > PLAF_FORFBA
    ou
    BAFP > PLAF_FORFBA)

alors erreur IM02 ;
verif 2205:
application : batch , iliad ;

si
   APPLI_COLBERT + APPLI_OCEANS + APPLI_ILIAD = 1
   et
   V_IND_TRAIT > 0
   et
   CREFAM + 0 > 500000

alors erreur IM03 ;
verif 2504:
application : batch , iliad ;

si
   APPLI_COLBERT + APPLI_ILIAD + APPLI_OCEANS = 1
   et
   V_IND_TRAIT > 0
   et
   CREPROSP > LIM_PROSP

alors erreur IM08 ;
verif 2009:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   present (V_BTCO2044P) = 1
   et
   present (CO2044P)   = 0
   et
   V_IND_TRAIT = 4

alors erreur IM09 ;
verif 3110:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   present(V_CALCULIR) = 0
   et
   V_0CF+0 != somme (i = 0..7: positif(V_0Fi+0))

alors erreur IM1101 ;
verif 3111:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   present(V_CALCULIR) = 0
   et
   V_0CG != somme (i = 0, 1, 2, 3: positif(V_0Gi+0))

alors erreur IM1102 ;
verif 3118:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   present(V_CALCULIR) = 0
   et
   V_0CH != somme (i = 0,1,2,3,4,5: positif(V_0Hi+0))

alors erreur IM1103 ;
verif 3116:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   present(V_CALCULIR) = 0
   et
   V_0CI != somme (i = 0, 1, 2, 3: positif(V_0Ii+0))

alors erreur IM1104 ;
verif 3112:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   present(V_CALCULIR) = 0
   et
   V_0CR != somme (i = 0, 1, 2, 3: positif(V_0Ri+0))

alors erreur IM1105 ;
verif 3113:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   present(V_CALCULIR) = 0
   et
   V_0DJ != somme (i = 0, 1, 2, 3: positif(V_0Ji+0))

alors erreur IM1106 ;
verif 3114:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   present(V_CALCULIR) = 0
   et
   V_0DN != somme (i = 0, 1, 2, 3: positif(V_0Ni+0))

alors erreur IM1107 ;
verif 3117:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   present(V_CALCULIR) = 0
   et
   V_0DP !=  positif(V_0P0+0)

alors erreur IM1108 ;
verif 3215:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   positif(null(V_NOTRAIT - 23) + null(V_NOTRAIT - 33) + null(V_NOTRAIT - 43) + null(V_NOTRAIT - 53) + null(V_NOTRAIT - 63)) = 0
   et
   IREST >= LIM_RESTIT

alors erreur IM14 ;
verif 1108:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT + 0 = 4
   et
   V_NOTRAIT + 0 < 14
   et
   ((RCMAVFT > PLAF_AF
     et
     RCMABD + REVACT + RCMHAD + DISQUO + RCMHAB + INTERE + RCMTNC + REVPEA + COD2FA > 0
     et
     RCMAVFT > arr(40 * (RCMABD + REVACT + RCMHAD + DISQUO + RCMHAB + INTERE + RCMTNC + REVPEA + COD2FA) / 100))
    ou
    (DIREPARGNE > PLAF_AF
     et
     PPLIB + RCMLIB + RCMHAD + DISQUO + RCMHAB + INTERE + COD2FA + BPVRCM > 0
     et
     DIREPARGNE > arr(60 * (PPLIB + RCMLIB + RCMHAD + DISQUO + RCMHAB + INTERE + COD2FA + BPVRCM) / 100)))

alors erreur IM1501 ;
verif 1109:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   V_NOTRAIT + 0 >= 14
   et
   ((RCMAVFT > PLAF_AF
     et
     RCMAVFT <= PLAF_AF2
     et
     RCMABD + REVACT + RCMHAD + DISQUO + RCMHAB + INTERE + RCMTNC + REVPEA + COD2FA > 0
     et
     RCMAVFT > arr(40 * (RCMABD + REVACT + RCMHAD + DISQUO + RCMHAB + INTERE + RCMTNC + REVPEA + COD2FA) / 100))
    ou
    (DIREPARGNE > PLAF_AF
     et
     DIREPARGNE <= PLAF_AF2
     et
     PPLIB + RCMLIB + RCMHAD + DISQUO + RCMHAB + INTERE + COD2FA + BPVRCM > 0
     et
     DIREPARGNE > arr(60 * (PPLIB + RCMLIB + RCMHAD + DISQUO + RCMHAB + INTERE + COD2FA + BPVRCM) / 100)))

alors erreur IM1502 ;
verif 5060:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   V_ZDC+0 = 0
   et
   V_BTMUL+0 = 0
   et
   V_0AX+0 = 0 et V_0AY+0 = 0 et V_0AZ+0 = 0 et V_0AO+0 = 0
   et
   V_BTRNI > LIM_BTRNI
   et
   RNI > V_BTRNI * 9
   et
   RNI < 100000
   et
   V_IND_TRAIT = 4

alors erreur IM1601 ;
verif 5061:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   V_ZDC+0 = 0
   et
   V_BTMUL+0 = 0
   et
   V_0AX+0 = 0 et V_0AY+0 = 0 et V_0AZ+0 = 0 et V_0AO+0 = 0
   et
   V_BTRNI > LIM_BTRNI
   et
   RNI > V_BTRNI * 5
   et
   RNI >= 100000
   et
   V_IND_TRAIT = 4

alors erreur IM1602 ;
verif 5101:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   V_BTIMP > LIM_BTIMP
   et
   IINET >= V_BTIMP * 2
   et
   V_ZDC+0 = 0
   et
   V_IND_TRAIT = 4

alors erreur IM17 ;
verif 5102:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   V_BTIMP > LIM_BTIMP
   et
   IINET <= V_BTIMP / 2
   et
   V_ZDC+0 = 0
   et
   V_IND_TRAIT = 4

alors erreur IM18 ;
verif 3620:
application : iliad ;
si
   APPLI_OCEANS = 0
   et
   (V_IND_TRAIT = 4
    et V_BT0CF + 0 = somme(i=0..5:positif(V_BT0Fi+0))
    et V_BT0CH + 0 = somme(i=0..5:positif(V_BT0Hi+0))
    et V_0CF + 0 = somme(i=0..5:positif(V_0Fi+0))
    et V_0CH + 0 = somme(i=0..5:positif(V_0Hi+0))
    et
     (
       V_BT0CH + V_BT0CF + 0 > V_0CH + V_0CF
       ou
       (V_BT0CF = 1 et V_0CF =1 et V_0CH + 0 = 0 et pour un i dans 0,1: V_0Fi = V_ANREV )
       ou
       (V_BT0CF = 1 et V_0CH =1 et V_0CF + 0 = 0 et pour un i dans 0,1: V_0Hi = V_ANREV )
       ou
       (V_BT0CH = 1 et V_0CH =1 et V_0CF + 0 = 0 et pour un i dans 0,1: V_0Hi = V_ANREV )
       ou
       (V_BT0CH = 1 et V_0CF =1 et V_0CH + 0 = 0 et pour un i dans 0,1: V_0Fi = V_ANREV )
     )
   )
alors erreur IM19 ;
verif 5100:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   V_NOTRAIT + 0 != 14
   et
   V_BTANC + 0 = 1
   et
   ((V_BTNI1+0 )non dans (50,92))
   et
   V_BTIMP + 0 <= 0
   et
   IINET > LIM_BTIMP * 2
   et
   V_ZDC + 0 = 0
   et 
   V_IND_TRAIT = 4

alors erreur IM20 ;
verif 20091:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT > 0
   et
   positif(ANNUL2042) = 1

alors erreur IM40 ;
verif 4380:
application : iliad ;
si
                    (FLAGDERNIE+0 = 1) et  ((DEFRI = 1)  et (PREM8_11=1) et (((VARR30+0=0)et (VARR32+0=0)) ou ((DEFRIGLOB=0) et (RIDEFRI=0))))
alors erreur IM42 ;

verif 4382:
application : iliad ;
si
                    (FLAGDERNIE+0 = 1) et  ((DEFRI = 1)  et (PREM8_11=0) et (VARR10+0=0) et (ANO1731=0))
alors erreur IM42 ;
