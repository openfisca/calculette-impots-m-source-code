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
verif 320:
application : iliad , batch ;

si
   DPVRCM > 0
   et
   BPVRCM + PEA + GAINPEA > 0

alors erreur A320 ;
verif 321:
application : iliad , batch ;

si

   positif(ABDETPLUS + 0) + positif(ABDETMOINS + 0) = 2

alors erreur A321;
verif 323:
application : iliad , batch ;

si
   positif(ABIMPPV + 0) = 1
   et
   positif(ABIMPMV + 0) = 1

alors erreur A323 ;
verif 325:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(PVSURSI + 0) + positif(COD3WM + 0) = 1

alors erreur A325 ;
verif 326:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(PVIMPOS + 0) + positif(ABPVNOSURSIS + 0) = 1

alors erreur A326 ;
verif 3271:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(CODRVG + 0) + positif(CODNVG + 0) = 1

alors erreur A32701 ;
verif 3272:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(CODNVG + 0) = 1
   et
   null(4 - CODNVG) = 0

alors erreur A32702 ;
verif 3281:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(CODRWA + 0) + positif(CODNWA + 0) = 1

alors erreur A32801 ;
verif 3282:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(CODNWA + 0) = 1
   et
   null(4 - CODNWA) = 0

alors erreur A32802 ;
verif 3291:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(CODRWB + 0) + positif(CODNWB + 0) = 1

alors erreur A32901 ;
verif 3292:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(CODNWB + 0) = 1
   et
   null(4 - CODNWB) = 0

alors erreur A32902 ;
verif 420:
application : batch , iliad ;

si
   RFMIC > 0
   et
   (RFORDI > 0 ou RFDORD > 0 ou RFDHIS > 0 ou FONCI > 0 ou REAMOR > 0 et FONCINB > 0 ou REAMORNB > 0)

alors erreur A420 ;
verif 421:
application : batch , iliad;

si 
   V_IND_TRAIT > 0
   et
   RFMIC > LIM_MICFON
  
alors erreur A421 ;
verif 422:
application : batch , iliad ;

si
   LOYIMP > 0 et ( present(RFORDI) = 0
                et
                   present(FONCI) = 0
                et
                   present(FONCINB) = 0
                et
                   present(REAMOR) = 0
                et
                   present(REAMORNB) = 0
                et
                   present(RFDORD) = 0
                et
                   present(RFDHIS) = 0
                et
                   present(RFMIC) = 0)

alors erreur A422 ;
verif 423:
application : batch , iliad ;

si
   RFROBOR > 0
   et
   RFDANT > 0
   et
   present(RFORDI) = 0
   et
   present(RFDORD) = 0
   et
   present(RFDHIS) = 0
   
alors erreur A423 ;
verif 424:
application : batch , iliad ;

si
   RFROBOR > 0
   et
   (FONCI > 0
    ou
    REAMOR > 0)

alors erreur A424 ;
verif 4251:
application : iliad , batch ;

si
   (V_IND_TRAIT = 4
    et
    (FONCINB < 2 ou FONCINB > 30))
   ou
   (V_IND_TRAIT = 5
    et
    (FONCINB = 1 ou FONCINB > 30))

alors erreur A42501 ;
verif 4252:
application : iliad , batch ;

si
   (V_IND_TRAIT = 4
    et
    positif(FONCI) + present(FONCINB) = 1)
   ou
   (V_IND_TRAIT = 5
    et
    positif(FONCI) + positif(FONCINB) = 1)

alors erreur A42502 ;
verif 4261:
application : iliad , batch ;

si
   (V_IND_TRAIT = 4
    et
    (REAMORNB < 2 ou REAMORNB > 14))
   ou
   (V_IND_TRAIT = 5
    et
    (REAMORNB = 1 ou REAMORNB > 14))

alors erreur A42601 ;
verif 4262:
application : iliad , batch ;

si
   (V_IND_TRAIT = 4
    et
    positif(REAMOR) + present(REAMORNB) = 1)
   ou
   (V_IND_TRAIT = 5
    et
    positif(REAMOR) + positif(REAMORNB) = 1)

alors erreur A42602 ;
verif 534:
application : batch , iliad ;

si
   APPLI_COLBERT + APPLI_OCEANS = 0
   et
   positif_ou_nul(NAPT) = 0
   et
   (V_BTNATIMP+0) dans (1,11,71,81)
   et
   (positif(V_FORVA + 0) = 1
    ou
    positif(V_FORCA + 0) = 1
    ou
    positif(V_FORPA + 0) = 1)

alors erreur A534 ;
verif 538: 
application : iliad , batch ;

si
   (RCSV > 0 et SOMMEA538VB = 0)
   ou
   (RCSC > 0 et SOMMEA538CB = 0)
   ou
   (RCSP > 0 et SOMMEA538PB = 0)

alors erreur A538 ;
verif 542:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   (
    (PPEACV+0 > 0 et PPENJV+0 > 0)
    ou
    (PPEACC+0 > 0 et PPENJC+0 > 0)
    ou
    (PPEACP+0 > 0 et PPENJP+0 > 0)
   )

alors erreur A542 ;
verif 600:
application : iliad , batch ;

si
   APPLI_OCEANS = 0
   et
   positif(PERPIMPATRIE+0) != 1
   et
   V_REGCO+0 != 2 et V_REGCO+0 != 4
   et
   V_CNR+0 != 1
   et
   ((positif(PERP_COTV+0) > 0 et
     present(PERPPLAFCV)*present(PERPPLAFNUV1)*present(PERPPLAFNUV2)*present(PERPPLAFNUV3) = 0)
    ou
    (positif(PERP_COTC+0) > 0 et
     present(PERPPLAFCC)*present(PERPPLAFNUC1)*present(PERPPLAFNUC2)*present(PERPPLAFNUC3) = 0)
    ou
    (positif(PERP_COTP+0) > 0 et
     present(PERPPLAFCP)*present(PERPPLAFNUP1)*present(PERPPLAFNUP2)*present(PERPPLAFNUP3) = 0))

alors erreur A600 ;
verif 601:
application : iliad , batch ;

si
   APPLI_OCEANS = 0
   et
   V_REGCO+0 != 2 et V_REGCO+0 != 4
   et
   positif(PERPIMPATRIE+0) != 1
   et
   (PERPPLAFCV > LIM_PERPMAXBT
    ou
    PERPPLAFCC > LIM_PERPMAXBT)

alors erreur A601 ;
verif 602:
application : iliad , batch ;

si
   APPLI_OCEANS = 0
   et
   V_REGCO+0 != 2 et V_REGCO+0 != 4
   et
   ((positif(RACCOTV+0) > 0 et positif(PERP_COTV+0) = 0)
    ou
    (positif(RACCOTC+0) > 0 et positif(PERP_COTC+0) = 0)
    ou
    (positif(RACCOTP+0) > 0 et positif(PERP_COTP+0) = 0))

alors erreur A602 ;
verif 603:
application : iliad , batch ;

si
   APPLI_OCEANS = 0
   et
   positif(PERPIMPATRIE + 0) != 1
   et
   positif(V_CALCULIR + 0) = 0
   et
   V_REGCO+0 != 2 et V_REGCO+0 != 4
   et
  (
  (positif_ou_nul(PLAF_PERPV) = 1 et
            (present(PERPPLAFCV) = 0 et present(PERPPLAFNUV1) = 0
             et present(PERPPLAFNUV2) = 0 et present(PERPPLAFNUV3) = 0 ))
  ou
  (positif_ou_nul(PLAF_PERPC) = 1 et
            (present(PERPPLAFCC) = 0 et present(PERPPLAFNUC1) = 0
             et present(PERPPLAFNUC2) = 0 et present(PERPPLAFNUC3) = 0 ))
  ou
  (positif_ou_nul(PLAF_PERPP) = 1 et
            (present(PERPPLAFCP) = 0 et present(PERPPLAFNUP1) = 0
             et present(PERPPLAFNUP2) = 0 et present(PERPPLAFNUP3) = 0 ))
  ou
  (positif_ou_nul(PLAF_PERPV) = 1
                 et (PERPPLAFCV+PERPPLAFNUV1+PERPPLAFNUV2+PERPPLAFNUV3 =
                      V_BTPERPV+V_BTPERPNUV1+V_BTPERPNUV2+V_BTPERPNUV3) )
  ou
  (positif_ou_nul(PLAF_PERPC) = 1
                 et (PERPPLAFCC+PERPPLAFNUC1+PERPPLAFNUC2+PERPPLAFNUC3 =
                      V_BTPERPC+V_BTPERPNUC1+V_BTPERPNUC2+V_BTPERPNUC3) )
  ou
  (positif_ou_nul(PLAF_PERPP) = 1
                 et (PERPPLAFCP+PERPPLAFNUP1+PERPPLAFNUP2+PERPPLAFNUP3 =
                      V_BTPERPP+V_BTPERPNUP1+V_BTPERPNUP2+V_BTPERPNUP3) )
  )
alors erreur A603 ;
verif 604:
application : iliad , batch ;

si
   APPLI_OCEANS = 0
   et
   (positif(PERPMUTU) = 1 et (V_0AM + V_0AO = 1) et ((V_REGCO+0) dans (1,3,5,6,7))
    et positif(PERPIMPATRIE+0) = 0
    et (present(PERPPLAFCV) = 0 ou present(PERPPLAFNUV1) = 0
        ou present(PERPPLAFNUV2) = 0 ou present(PERPPLAFNUV3) = 0
        ou present(PERPPLAFCC) = 0 ou present(PERPPLAFNUC1) = 0
        ou present(PERPPLAFNUC2) = 0 ou present(PERPPLAFNUC3) =0))
alors erreur A604 ;
verif 6051:
application : iliad , batch ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT > 0
   et
   PERPV + 0 < EXOCETV + 0
   et
   positif(EXOCETV + 0) = 1

alors erreur A60501 ;
verif 6052:
application : iliad , batch ;

si
   APPLI_OCEANS = 0
   et
   V_IND_TRAIT > 0
   et
   PERPC + 0 < EXOCETC + 0
   et
   positif(EXOCETC + 0) = 1

alors erreur A60502 ;
