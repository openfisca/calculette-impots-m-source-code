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
verif 2500:
application : iliad , batch ;
si
   APPLI_OCEANS = 0
   et
   FRNV > (TSHALLOV + ALLOV) * 0.10
   et
   RDSYVO > 0
   et
   PRBRV + CARPEV + PENINV + CODRAZ + PALIV + PENSALV + 0 = 0

alors erreur I00101 ;
verif 2501:
application : iliad , batch ;
si
   APPLI_OCEANS = 0
   et
   FRNC > (TSHALLOC + ALLOC) * 0.10
   et
   RDSYCJ > 0
   et
   PRBRC + CARPEC + PENINC + CODRBZ + PALIC + PENSALC + 0 = 0

alors erreur I00102 ;
verif 2502:
application : iliad, batch ;
si
   APPLI_OCEANS = 0
   et
(
  (
   (
    ( FRN1 > (TSHALLO1 + ALLO1) *0.10)
          et (PRBR1 + CARPEP1 + PENIN1 + CODRCZ + PALI1 + PENSALP1 + 0 = 0)
   )
   ou
   (
     ( FRN2 > (TSHALLO2 + ALLO2) *0.10)
          et (PRBR2 + CARPEP2 + PENIN2 + CODRDZ + PALI2 + PENSALP2 + 0 = 0)
   )
   ou
   (
     ( FRN3 > (TSHALLO3 + ALLO3) *0.10)
          et (PRBR3 + CARPEP3 + PENIN3 + CODREZ + PALI3 + PENSALP3 + 0 = 0)
   )
   ou
   (
     ( FRN4 > (TSHALLO4 + ALLO4) *0.10)
          et (PRBR4 + CARPEP4 + PENIN4 + CODRFZ + PALI4 + PENSALP4 + 0 = 0)
   )
  ) et RDSYPP > 0
)
alors erreur I00103 ;
verif 2566:
application : batch , iliad ;

si
   APPLI_COLBERT + APPLI_BATCH + APPLI_ILIAD = 1
   et
   CHRFAC > 0
   et
   CHNFAC + 0 = 0
   et
   positif(NATIMP) = 1
   et
   V_CNR = 0

alors erreur I008 ;
verif 2565:
application : batch , iliad ;

si
   APPLI_COLBERT + APPLI_BATCH + APPLI_ILIAD = 1
   et
   RDCOM > 0
   et
   NBACT + 0  = 0
   et
   positif(NATIMP) = 1

alors erreur I009 ;
verif 3301:
application : iliad, batch ;

si
   APPLI_OCEANS = 0
   et
  (
        V_0AV  = 1
        et
       (
       (
        positif(XETRANC) + positif(EXOCETC) + positif(FRNC)
        + positif(PENINC) + positif(CODRBZ)
        + positif(TSHALLOC) + positif(CODDBJ) + positif(CODEBJ) + positif(ALLOC)
        + positif(SALEXTC) + positif(COD1BD) + positif(COD1BE) + positif(PPEXTC) + positif(COD1BH)
        + positif(PRBC) + somme(i=2..4:positif(iPRBC)) + positif(PEBFC)
        + positif(CARTSC) + positif(REMPLAC) + positif(CARPEC) + positif(PENSALC)
        + somme (i=1..3: positif (GLDiC)) + somme (i=A: positif(BiFC) + somme(j=A: positif(Bi1jC)))
        + somme (i=H,C:
                        somme(j= A,N: somme(k=R,D: positif(BjikEC))) +
                        somme(j=N: positif(BIiDjC)) + positif(BIiNOC)
          )
        + positif(BICREC) + positif(BI2AC) + positif(BICDEC)
        + positif(TSASSUC)
        + positif(PPETPC) + positif(PPENHC)
        + positif(GSALC) + positif(PCAPTAXC)

 + positif( FEXC ) + positif( BAFC ) + positif( BAFORESTC ) + positif( BAFPVC ) + positif( BAF1AC )
 + positif( BAEXC ) + positif( BACREC ) + positif( 4BACREC ) + positif( BA1AC )
 + positif(BACDEC)
 + positif( BAHEXC ) + positif( BAHREC ) + positif( 4BAHREC )
 + positif( BAHDEC ) + positif( BAPERPC ) + positif( BANOCGAC )
 + positif( AUTOBICVC ) + positif( AUTOBICPC ) + positif( MIBEXC ) + positif( MIBVENC )
 + positif( MIBPRESC ) + positif( MIBPVC ) + positif( MIB1AC ) + positif( MIBDEC )
 + positif( BICEXC ) + positif( BICNOC ) + positif( LOCPROCGAC )
 + positif( BI1AC ) + positif(BICDNC )
 + positif( LOCDEFPROCGAC )
 + positif( BIHEXC ) + positif( BIHNOC ) + positif( LOCPROC )
 + positif( BIHDNC ) + positif( BIPERPC )
 + positif( LOCDEFPROC )
 + positif( MIBMEUC ) + positif( MIBGITEC ) + positif( MIBNPEXC ) + positif( MIBNPVENC )
 + positif( MIBNPPRESC ) + positif( MIBNPPVC ) + positif( MIBNP1AC ) + positif( MIBNPDEC )
 + positif( BICNPEXC ) + positif( BICREC ) + positif( LOCNPCGAC )
 + positif( BI2AC ) + positif( LOCDEFNPCGAC)
 + positif( BICNPHEXC ) + positif( BICHREC ) + positif( LOCNPC )
 + positif( BICHDEC)
 + positif(LOCDEFNPC)
 + positif( AUTOBNCC ) + positif( BNCPROEXC ) + positif( BNCPROC )
 + positif( BNCPROPVC ) + positif( BNCPRO1AC ) + positif( BNCPRODEC )
 + positif( BNCEXC ) + positif( BNCREC ) + positif( BN1AC )
 + positif( BNCDEC )
 + positif( BNHEXC ) + positif( BNHREC ) + positif( BNHDEC )
 + positif ( BNCCRC ) + positif ( CESSASSC ) + positif( XHONOAAC ) + positif( XHONOC )
 + positif( BNCNPC ) + positif( BNCNPPVC ) + positif( BNCNP1AC ) + positif( BNCNPDEC )
 + positif( BNCNPREXAAC ) + positif( BNCAABC ) + positif( BNCNPREXC ) + positif( ANOVEP )
 + positif( INVENTC ) + positif( PVINCE ) + positif( BNCAADC)
 + positif( DNOCEPC ) + positif( BNCCRFC )
 + positif( RCSC ) + positif( BANOCGAC ) + positif( PVSOCC ) + positif( PPEACC ) + positif( PPENJC )

 + positif( PERPC ) + positif( PERP_COTC ) + positif( RACCOTC ) + positif( PLAF_PERPC )
 + positif ( PERPPLAFCC ) + positif ( PERPPLAFNUC1 ) + positif ( PERPPLAFNUC2 ) + positif ( PERPPLAFNUC3 )
 + positif ( RDSYCJ )
 + positif( ELURASC )
     )
        > 0
     )
   )
alors erreur I010 ;
verif 3210:
application : iliad , batch ;

si
   APPLI_OCEANS = 0
   et
   (V_0AM + V_0AO + 0 = 1) et V_0AS = 1 et V_0AP+0 = 0 et V_0AF+0 = 0
   et
   V_ANREV - V_0DA < 75
   et
   V_ANREV - V_0DB < 75

alors erreur I011 ;
verif 3221:
application : batch , iliad ;

si
   APPLI_OCEANS = 0
   et
   (V_0AM + V_0AO + 0 = 0 )
   et
   V_0AZ + 0 = 0
   et
   V_0AP + 0 = 0
   et
   V_0AW = 1
   et
   V_ANREV - V_0DA < 75
  
alors erreur I012 ;
verif 3214:
application : batch , iliad ;

si 
   APPLI_OCEANS + APPLI_COLBERT = 0 
   et
    (
       V_BT0CF >0
          et V_0CH >0
              et positif(V_0CF+0) != 1
                   et V_BT0CF + 0 = somme(i=0..5:positif(V_BT0Fi+0))
                     et V_BT0CH + 0 = somme(i=0..5:positif(V_BT0Hi+0))
                       et V_0CF + 0 = somme(i=0..5:positif(V_0Fi+0))
                         et V_0CH + 0 = somme(i=0..5:positif(V_0Hi+0))
                           et ((     V_0CH < V_BT0CF   )
                                ou
                               (     V_0CH = V_BT0CF
                                  et somme(i=0..5:V_0Hi+0) != somme(i=0..5:V_BT0Fi+0)         )
                                ou
                               (     V_0CH = V_BT0CF
                                  et somme(i=0..5:V_0Hi+0) = somme(i=0..5:V_BT0Fi+0)
                                  et somme(i=0..5: (1/V_0Hi)) != somme(i=0..5: (1/V_BT0Fi))   )
                               ou
                               (     V_0CH > V_BT0CF
        et somme(i=0..5:positif(somme(j=0..5:null(V_0Hj - V_BT0Fi)))*V_BT0Fi) != somme(i=0..5:V_BT0Fi)
                               )
                               ou
                               (     V_0CH > V_BT0CF
        et somme(i=0..5:positif(somme(j=0..5:null(V_0Hj - V_BT0Fi)))*V_BT0Fi) = somme(i=0..5:V_BT0Fi)
        et somme(i=0..5:positif(somme(j=0..5:null(V_0Hi - V_BT0Fj)))*V_0Hi) < somme(i=0..5:V_BT0Fi)
                               )
                              )
    )
   et
   V_IND_TRAIT = 4

alors erreur I014 ;
verif 3216:
application : batch , iliad ;
si
   V_IND_TRAIT = 4
   et
   V_REGCO != 2
   et
   V_REGCO != 4
   et
   (
    DEFRCM + 0 > V_BTDFRCM1 + PLAF_PRECONS * (1 - positif(V_BTDFRCM1))
    ou
    DEFRCM2 + 0 > V_BTDFRCM2 + PLAF_PRECONS * (1 - positif(V_BTDFRCM2))
    ou
    DEFRCM3 + 0 > V_BTDFRCM3 + PLAF_PRECONS * (1 - positif(V_BTDFRCM3))
    ou
    DEFRCM4 + 0 > V_BTDFRCM4 + PLAF_PRECONS * (1 - positif(V_BTDFRCM4))
    ou
    DEFRCM5 + 0 > V_BTDFRCM5 + PLAF_PRECONS * (1 - positif(V_BTDFRCM5))
    ou
    DEFRCM6 + 0 > V_BTDFRCM6 + PLAF_PRECONS * (1 - positif(V_BTDFRCM6)))

alors erreur I015 ;
verif 3217:
application : batch , iliad ;

si
   V_IND_TRAIT > 0
   et
   V_REGCO != 2
   et
   V_REGCO != 4
   et
   positif(PVSURSI + PVIMPOS + CODRWA + CODRWB + 0) = 1

alors erreur I016 ;
