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
verif 1391:
application : iliad , batch ;

si
   ((V_IND_TRAIT = 4 )
     et
    (
     CARPENBAV < 2 ou CARPENBAV > 45
     ou
     CARPENBAC < 2 ou CARPENBAC > 45
     ou
     CARPENBAP1 < 2 ou CARPENBAP1 > 45
     ou
     CARPENBAP2 < 2 ou CARPENBAP2 > 45
     ou
     CARPENBAP3 < 2 ou CARPENBAP3 > 45
     ou
     CARPENBAP4 < 2 ou CARPENBAP4 > 45
     ou
     PENSALNBV < 2 ou PENSALNBV > 45
     ou
     PENSALNBC < 2 ou PENSALNBC > 45
     ou
     PENSALNBP1 < 2 ou PENSALNBP1 > 45
     ou
     PENSALNBP2 < 2 ou PENSALNBP2 > 45
     ou
     PENSALNBP3 < 2 ou PENSALNBP3 > 45
     ou
     PENSALNBP4 < 2 ou PENSALNBP4 > 45
     ou
     RENTAXNB < 2 ou RENTAXNB > 45
     ou
     RENTAXNB5 < 2 ou RENTAXNB5 > 45
     ou
     RENTAXNB6 < 2 ou RENTAXNB6 > 45
     ou
     RENTAXNB7 < 2 ou RENTAXNB7 > 45
     ou
     CODNAZ < 2 ou CODNAZ > 45
     ou
     CODNBZ < 2 ou CODNBZ > 45
     ou
     CODNCZ < 2 ou CODNCZ > 45
     ou
     CODNDZ < 2 ou CODNDZ > 45
     ou
     CODNEZ < 2 ou CODNEZ > 45
     ou
     CODNFZ < 2 ou CODNFZ > 45
    )
   )
   ou
   ((V_IND_TRAIT = 5 )
     et
    (
     CARPENBAV = 1 ou CARPENBAV > 45
     ou
     CARPENBAC = 1 ou CARPENBAC > 45
     ou
     CARPENBAP1 = 1 ou CARPENBAP1 > 45
     ou
     CARPENBAP2 = 1 ou CARPENBAP2 > 45
     ou
     CARPENBAP3 = 1 ou CARPENBAP3 > 45
     ou
     CARPENBAP4 = 1 ou CARPENBAP4 > 45
     ou
     PENSALNBV = 1 ou PENSALNBV > 45
     ou
     PENSALNBC = 1 ou PENSALNBC > 45
     ou
     PENSALNBP1 = 1 ou PENSALNBP1 > 45
     ou
     PENSALNBP2 = 1 ou PENSALNBP2 > 45
     ou
     PENSALNBP3 = 1 ou PENSALNBP3 > 45
     ou
     PENSALNBP4 = 1 ou PENSALNBP4 > 45
     ou
     RENTAXNB = 1 ou RENTAXNB > 45
     ou
     RENTAXNB5 = 1 ou RENTAXNB5 > 45
     ou
     RENTAXNB6 = 1 ou RENTAXNB6 > 45
     ou
     RENTAXNB7 = 1 ou RENTAXNB7 > 45
     ou
     CODNAZ = 1 ou CODNAZ > 45
     ou
     CODNBZ = 1 ou CODNBZ > 45
     ou
     CODNCZ = 1 ou CODNCZ > 45
     ou
     CODNDZ = 1 ou CODNDZ > 45
     ou
     CODNEZ = 1 ou CODNEZ > 45
     ou
     CODNFZ = 1 ou CODNFZ > 45
    )
   )
alors erreur A13901 ;
verif 1392:
application : iliad , batch ;

si
  (V_IND_TRAIT = 4
    et
    (
     (positif(CARPEV) + present(CARPENBAV) = 1)
     ou
     (positif(CARPEC) + present(CARPENBAC) = 1)
     ou
     (positif(CARPEP1) + present(CARPENBAP1) = 1)
     ou
     (positif(CARPEP2) + present(CARPENBAP2) = 1)
     ou
     (positif(CARPEP3) + present(CARPENBAP3) = 1)
     ou
     (positif(CARPEP4) + present(CARPENBAP4) = 1)
     ou
     (positif(PENSALV) + present(PENSALNBV) = 1)
     ou
     (positif(PENSALC) + present(PENSALNBC) = 1)
     ou
     (positif(PENSALP1) + present(PENSALNBP1) = 1)
     ou
     (positif(PENSALP2) + present(PENSALNBP2) = 1)
     ou
     (positif(PENSALP3) + present(PENSALNBP3) = 1)
     ou
     (positif(PENSALP4) + present(PENSALNBP4) = 1)
     ou
     (positif(RENTAX) + present(RENTAXNB) = 1)
     ou
     (positif(RENTAX5) + present(RENTAXNB5) = 1)
     ou
     (positif(RENTAX6) + present(RENTAXNB6) = 1)
     ou
     (positif(RENTAX7) + present(RENTAXNB7) = 1)
     ou
     (positif(CODRAZ) + present(CODNAZ) = 1)
     ou
     (positif(CODRBZ) + present(CODNBZ) = 1)
     ou
     (positif(CODRCZ) + present(CODNCZ) = 1)
     ou
     (positif(CODRDZ) + present(CODNDZ) = 1)
     ou
     (positif(CODREZ) + present(CODNEZ) = 1)
     ou
     (positif(CODRFZ) + present(CODNFZ) = 1)
    )
  )
  ou
  (V_IND_TRAIT = 5
    et
    (
     (positif(CARPEV) + positif(CARPENBAV) = 1)
     ou
     (positif(CARPEC) + positif(CARPENBAC) = 1)
     ou
     (positif(CARPEP1) + positif(CARPENBAP1) = 1)
     ou
     (positif(CARPEP2) + positif(CARPENBAP2) = 1)
     ou
     (positif(CARPEP3) + positif(CARPENBAP3) = 1)
     ou
     (positif(CARPEP4) + positif(CARPENBAP4) = 1)
     ou
     (positif(PENSALV) + positif(PENSALNBV) = 1)
     ou
     (positif(PENSALC) + positif(PENSALNBC) = 1)
     ou
     (positif(PENSALP1) + positif(PENSALNBP1) = 1)
     ou
     (positif(PENSALP2) + positif(PENSALNBP2) = 1)
     ou
     (positif(PENSALP3) + positif(PENSALNBP3) = 1)
     ou
     (positif(PENSALP4) + positif(PENSALNBP4) = 1)
     ou
     (positif(RENTAX) + positif(RENTAXNB) = 1)
     ou
     (positif(RENTAX5) + positif(RENTAXNB5) = 1)
     ou
     (positif(RENTAX6) + positif(RENTAXNB6) = 1)
     ou
     (positif(RENTAX7) + positif(RENTAXNB7) = 1)
     ou
     (positif(CODRAZ) + positif(CODNAZ) = 1)
     ou
     (positif(CODRBZ) + positif(CODNBZ) = 1)
     ou
     (positif(CODRCZ) + positif(CODNCZ) = 1)
     ou
     (positif(CODRDZ) + positif(CODNDZ) = 1)
     ou
     (positif(CODREZ) + positif(CODNEZ) = 1)
     ou
     (positif(CODRFZ) + positif(CODNFZ) = 1)
    )
  )
alors erreur A13902 ;
verif 14010:
application : iliad , batch ;

si
   ((V_IND_TRAIT = 4 )
     et
    (
     CARTSNBAV < 2 ou CARTSNBAV > 45
     ou
     CARTSNBAC < 2 ou CARTSNBAC > 45
     ou
     CARTSNBAP1 < 2 ou CARTSNBAP1 > 45
     ou
     CARTSNBAP2 < 2 ou CARTSNBAP2 > 45
     ou
     CARTSNBAP3 < 2 ou CARTSNBAP3 > 45
     ou
     CARTSNBAP4 < 2 ou CARTSNBAP4 > 45
     ou
     REMPLANBV < 2 ou REMPLANBV > 45
     ou
     REMPLANBC < 2 ou REMPLANBC > 45
     ou
     REMPLANBP1 < 2 ou REMPLANBP1 > 45
     ou
     REMPLANBP2 < 2 ou REMPLANBP2 > 45
     ou
     REMPLANBP3 < 2 ou REMPLANBP3 > 45
     ou
     REMPLANBP4 < 2 ou REMPLANBP4 > 45
    )
   )
   ou
   ((V_IND_TRAIT = 5 )
     et
    (
     CARTSNBAV = 1 ou CARTSNBAV > 45
     ou
     CARTSNBAC = 1 ou CARTSNBAC > 45
     ou
     CARTSNBAP1 = 1 ou CARTSNBAP1 > 45
     ou
     CARTSNBAP2 = 1 ou CARTSNBAP2 > 45
     ou
     CARTSNBAP3 = 1 ou CARTSNBAP3 > 45
     ou
     CARTSNBAP4 = 1 ou CARTSNBAP4 > 45
     ou
     REMPLANBV = 1 ou REMPLANBV > 45
     ou
     REMPLANBC = 1 ou REMPLANBC > 45
     ou
     REMPLANBP1 = 1 ou REMPLANBP1 > 45
     ou
     REMPLANBP2 = 1 ou REMPLANBP2 > 45
     ou
     REMPLANBP3 = 1 ou REMPLANBP3 > 45
     ou
     REMPLANBP4 = 1 ou REMPLANBP4 > 45
    )
   )
alors erreur A14001 ;
verif 1402:
application : iliad , batch ;

si
  (V_IND_TRAIT = 4
    et
    (
     (positif(CARTSV) + present(CARTSNBAV) = 1)
     ou
     (positif(CARTSC) + present(CARTSNBAC) = 1)
     ou
     (positif(CARTSP1) + present(CARTSNBAP1) = 1)
     ou
     (positif(CARTSP2) + present(CARTSNBAP2) = 1)
     ou
     (positif(CARTSP3) + present(CARTSNBAP3) = 1)
     ou
     (positif(CARTSP4) + present(CARTSNBAP4) = 1)
     ou
     (positif(REMPLAV) + present(REMPLANBV) = 1)
     ou
     (positif(REMPLAC) + present(REMPLANBC) = 1)
     ou
     (positif(REMPLAP1) + present(REMPLANBP1) = 1)
     ou
     (positif(REMPLAP2) + present(REMPLANBP2) = 1)
     ou
     (positif(REMPLAP3) + present(REMPLANBP3) = 1)
     ou
     (positif(REMPLAP4) + present(REMPLANBP4) = 1)
    )
  )
  ou
  (V_IND_TRAIT = 5
    et
    (
     (positif(CARTSV) + positif(CARTSNBAV) = 1)
     ou
     (positif(CARTSC) + positif(CARTSNBAC) = 1)
     ou
     (positif(CARTSP1) + positif(CARTSNBAP1) = 1)
     ou
     (positif(CARTSP2) + positif(CARTSNBAP2) = 1)
     ou
     (positif(CARTSP3) + positif(CARTSNBAP3) = 1)
     ou
     (positif(CARTSP4) + positif(CARTSNBAP4) = 1)
     ou
     (positif(REMPLAV) + positif(REMPLANBV) = 1)
     ou
     (positif(REMPLAC) + positif(REMPLANBC) = 1)
     ou
     (positif(REMPLAP1) + positif(REMPLANBP1) = 1)
     ou
     (positif(REMPLAP2) + positif(REMPLANBP2) = 1)
     ou
     (positif(REMPLAP3) + positif(REMPLANBP3) = 1)
     ou
     (positif(REMPLAP4) + positif(REMPLANBP4) = 1)
    )
  )
alors erreur A14002 ;
verif 14110:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   (COTFV + 0 > 25
    ou
    COTFC + 0 > 25
    ou
    COTF1 + 0 > 25
    ou
    COTF2 + 0 > 25
    ou
    COTF3 + 0 > 25
    ou
    COTF4 + 0 > 25)

alors erreur A14101 ;
verif 1412:
application : iliad , batch ;

si
   (V_IND_TRAIT = 4
    et
    (
     (positif(PEBFV) + present(COTFV) = 1)
     ou
     (positif(PEBFC) + present(COTFC) = 1)
     ou
     (positif(PEBF1) + present(COTF1) = 1)
     ou
     (positif(PEBF2) + present(COTF2) = 1)
     ou
     (positif(PEBF3) + present(COTF3) = 1)
     ou
     (positif(PEBF4) + present(COTF4) = 1)
     ou
     (positif(COTFV) + present(PEBFV) = 1)
     ou
     (positif(COTFC) + present(PEBFC) = 1)
     ou
     (positif(COTF1) + present(PEBF1) = 1)
     ou
     (positif(COTF2) + present(PEBF2) = 1)
     ou
     (positif(COTF3) + present(PEBF3) = 1)
     ou
     (positif(COTF4) + present(PEBF4) = 1)
    )
   )
   ou
   (V_IND_TRAIT = 5
    et
    (
     (positif(PEBFV) + positif(COTFV) = 1)
     ou
     (positif(PEBFC) + positif(COTFC) = 1)
     ou
     (positif(PEBF1) + positif(COTF1) = 1)
     ou
     (positif(PEBF2) + positif(COTF2) = 1)
     ou
     (positif(PEBF3) + positif(COTF3) = 1)
     ou
     (positif(PEBF4) + positif(COTF4) = 1)
     ou
     (positif(COTFV) + positif(PEBFV) = 1)
     ou
     (positif(COTFC) + positif(PEBFC) = 1)
     ou
     (positif(COTF1) + positif(PEBF1) = 1)
     ou
     (positif(COTF2) + positif(PEBF2) = 1)
     ou
     (positif(COTF3) + positif(PEBF3) = 1)
     ou
     (positif(COTF4) + positif(PEBF4) = 1)
    )
   )

alors erreur A14102 ;
verif 143:
application : iliad , batch ;

si
    (
 ( FRNV + COD1AE > 0 et (present(TSHALLOV) + present(ALLOV) + present(SALEXTV)) = 0 )
     ou
 ( FRNC + COD1BE > 0 et (present(TSHALLOC) + present(ALLOC) + present(SALEXTC)) = 0 )
     ou
 ( FRN1 + COD1CE > 0 et (present(TSHALLO1) + present(ALLO1) + present(SALEXT1)) = 0 )
     ou
 ( FRN2 + COD1DE > 0 et (present(TSHALLO2) + present(ALLO2) + present(SALEXT2)) = 0 )
     ou
 ( FRN3 + COD1EE > 0 et (present(TSHALLO3) + present(ALLO3) + present(SALEXT3)) = 0 )
     ou
 ( FRN4 + COD1FE > 0 et (present(TSHALLO4) + present(ALLO4) + present(SALEXT4)) = 0 )
    )
alors erreur A143 ;
verif 1441:
application : iliad , batch ;

si
   TSHALLOV + 0 < GSALV + 0
   et
   GSALV + 0 > 0

alors erreur A14401 ;
verif 1442:
application : iliad , batch ;

si
   TSHALLOC + 0 < GSALC + 0
   et
   GSALC + 0 > 0

alors erreur A14402 ;
verif non_auto_cc 146:
application : iliad , batch ;

si (
     ( DETSV=1 et
       positif(present(TSHALLOV) + present(ALLOV) + present(CARTSV) + present(CARTSNBAV) + present(REMPLAV) + present(REMPLANBV)) = 0 )
 ou
     ( DETSC=1 et
       positif(present(TSHALLOC) + present(ALLOC) + present(CARTSC) + present(CARTSNBAC) + present(REMPLAC) + present(REMPLANBC))=0 )
 ou
     ( DETS1=1 et
       positif(present(TSHALLO1) + present(ALLO1) + present(CARTSP1) + present(CARTSNBAP1) + present(REMPLAP1) + present(REMPLANBP1))=0 )
 ou
     ( DETS2=1 et
       positif(present(TSHALLO2) + present(ALLO2) + present(CARTSP2) + present(CARTSNBAP2) + present(REMPLAP2) + present(REMPLANBP2))=0 )
 ou
     ( DETS3=1 et
       positif(present(TSHALLO3) + present(ALLO3) + present(CARTSP3) + present(CARTSNBAP3) + present(REMPLAP3) + present(REMPLANBP3))=0 )
 ou
     ( DETS4=1 et
       positif(present(TSHALLO4) + present(ALLO4) + present(CARTSP4) + present(CARTSNBAP4) + present(REMPLAP4) + present(REMPLANBP4))=0 )
        )
alors erreur A146 ;
verif 153:
application : iliad , batch ;

si
   (
       (positif(PPETPV + 0) = 1 et (positif(PPENHV + 0) = 1 ou positif(PPEXTV + 0) = 1))
    ou (positif(PPETPC + 0) = 1 et (positif(PPENHC + 0) = 1 ou positif(PPEXTC + 0) = 1))
    ou (positif(PPETPP1 + 0) = 1 et (positif(PPENHP1 + 0) = 1 ou positif(PPEXT1 + 0) = 1))
    ou (positif(PPETPP2 + 0) = 1 et (positif(PPENHP2 + 0) = 1 ou positif(PPEXT2 + 0) = 1))
    ou (positif(PPETPP3 + 0) = 1 et (positif(PPENHP3 + 0) = 1 ou positif(PPEXT3 + 0) = 1))
    ou (positif(PPETPP4 + 0) = 1 et (positif(PPENHP4 + 0) = 1 ou positif(PPEXT4 + 0) = 1))
   )

alors erreur A153 ;
verif 154:
application : iliad , batch ;

si
      (positif(COD1AD + 0) = 1 et present(SALEXTV) = 0)
   ou (positif(COD1BD + 0) = 1 et present(SALEXTC) = 0)
   ou (positif(COD1CD + 0) = 1 et present(SALEXT1) = 0)
   ou (positif(COD1DD + 0) = 1 et present(SALEXT2) = 0)
   ou (positif(COD1ED + 0) = 1 et present(SALEXT3) = 0)
   ou (positif(COD1FD + 0) = 1 et present(SALEXT4) = 0)

alors erreur A154 ;
verif non_auto_cc 2181:
application : iliad , batch ;

si
   RCMAVFT > PLAF_AF
   et
   positif(RCMABD + REVACT + REVACTNB + RCMHAD + DISQUO + DISQUONB + RCMHAB
                           + INTERE + INTERENB + RCMTNC + REVPEA + COD2FA + 0) = 0

alors erreur A21801 ;
verif non_auto_cc 2182:
application : iliad , batch ;

si
   DIREPARGNE > PLAF_AF
   et
   PPLIB + RCMLIB + RCMHAD + RCMHAB + DISQUO + DISQUONB + INTERE + INTERENB + COD2FA + BPVRCM + 0 = 0

alors erreur A21802 ;
verif 2201:
application : batch ;

si
   APPLI_COLBERT = 0
   et
   V_NOTRAIT + 0 = 10
   et
   ((RCMAVFT > PLAF_AF2
     et
     RCMABD + RCMHAD + RCMHAB + REVACT + DISQUO + INTERE + RCMTNC + REVPEA + COD2FA > 0
     et
     RCMAVFT > arr((RCMABD + RCMHAD + RCMHAB + REVACT + DISQUO + INTERE + RCMTNC + REVPEA + COD2FA) * 40/100))
    ou
    (DIREPARGNE > PLAF_AF2
     et
     PPLIB + RCMLIB + RCMHAD + RCMHAB + DISQUO + INTERE + COD2FA + BPVRCM > 0
     et
     DIREPARGNE > arr((PPLIB + RCMLIB + RCMHAD + RCMHAB + DISQUO + INTERE + COD2FA + BPVRCM) * 60/100 )))

alors erreur A220 ;
verif 2202:
application : iliad ;

si
   APPLI_OCEANS = 0
   et
   ((V_IND_TRAIT + 0 = 5 et V_NOTRAIT + 0 > 14) ou V_NOTRAIT + 0 = 14)
   et
   ((RCMAVFT > PLAF_AF2
     et
     RCMABD + RCMHAD + RCMHAB + REVACT + DISQUO + INTERE + RCMTNC + REVPEA + COD2FA > 0
     et
     RCMAVFT > arr((RCMABD + RCMHAD + RCMHAB + REVACT + DISQUO + INTERE + RCMTNC + REVPEA + COD2FA) * 40/ 100))
    ou
    (DIREPARGNE > PLAF_AF2
     et
     PPLIB + RCMLIB + RCMHAD + RCMHAB + DISQUO + INTERE + COD2FA + BPVRCM > 0
     et
     DIREPARGNE > arr((PPLIB + RCMLIB + RCMHAD + RCMHAB + DISQUO + INTERE + COD2FA + BPVRCM) * 60/100 )))

alors erreur A220 ;
verif 221:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(COD2LA) + positif(COD2LB) > 1

alors erreur A221 ;
verif 2231:
application : iliad , batch ;

si
  ((V_IND_TRAIT = 4 )
   et
   (
    REVACTNB < 2 ou REVACTNB > 20
    ou
    REVPEANB < 2 ou REVPEANB > 20
    ou
    PROVIENB < 2 ou PROVIENB > 20
    ou
    DISQUONB < 2 ou DISQUONB > 20
    ou
    RESTUCNB < 2 ou RESTUCNB > 20
    ou
    INTERENB < 2 ou INTERENB > 20
   )
  )
  ou
  ((V_IND_TRAIT = 5 )
   et
   (
    REVACTNB = 1 ou REVACTNB > 20
    ou
    REVPEANB = 1 ou REVPEANB > 20
    ou
    PROVIENB = 1 ou PROVIENB > 20
    ou
    DISQUONB = 1 ou DISQUONB > 20
    ou
    RESTUCNB = 1 ou RESTUCNB > 20
    ou
    INTERENB = 1 ou INTERENB > 20
   )
  )
alors erreur A22301 ;
verif 2232:
application : iliad , batch ;

si
   (V_IND_TRAIT = 4
    et
    (
     positif(REVACT) + present(REVACTNB) = 1
     ou
     positif(REVPEA) + present(REVPEANB) = 1
     ou
     positif(PROVIE) + present(PROVIENB) = 1
     ou
     positif(DISQUO) + present(DISQUONB) = 1
     ou
     positif(RESTUC) + present(RESTUCNB) = 1
     ou
     positif(INTERE) + present(INTERENB) = 1
    )
   )
   ou
   (V_IND_TRAIT = 5
    et
    (
     positif(REVACT) + positif(REVACTNB) = 1
     ou
     positif(REVPEA) + positif(REVPEANB) = 1
     ou
     positif(PROVIE) + positif(PROVIENB) = 1
     ou
     positif(DISQUO) + positif(DISQUONB) = 1
     ou
     positif(RESTUC) + positif(RESTUCNB) = 1
     ou
     positif(INTERE) + positif(INTERENB) = 1
    )
   )
alors erreur A22302 ;
verif 224:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   COD2CK + 0 > 80
   et
   positif(RCMABD + REVACT + RCMHAD + DISQUO + RCMHAB + INTERE + RCMTNC + REVPEA + COD2FA + 0) = 0

alors erreur A224 ;
verif 225:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   COD2FA + 0 > 2000

alors erreur A225 ;
verif 226:
application : iliad , batch ;

si
   V_IND_TRAIT > 0
   et
   positif(COD2FA + 0) + positif(RCMHAB + 0) > 1

alors erreur A226 ;
