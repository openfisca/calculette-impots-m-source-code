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
regle 8740:
application : iliad , batch ;
XFORFAIT  = somme(i=V,C,P: FEXi);
regle 8741:
application : iliad , batch ;
XACCESS  = somme(i=V,C,P: XACCESSi);
regle 8745:
application : iliad , batch ;
pour i = V,P,C:
XBAi = BAHEXi + BAEXi ;
pour i = V,P,C:
XBIPi = BIHEXi + BICEXi;
pour i = V,P,C:
XBINPi = BICNPHEXi + BICNPEXi;
pour i = V,P,C:
XBNi = BNHEXi + BNCEXi ;
pour i = V,P,C:
XBNNPi = BNCNPREXi+BNCNPREXAAi ;
regle 872:
application : iliad , batch ;
pour i=V,C,P:
XBICHDi = (BICEXi + BICNOi)  ;
pour i=V,C,P:
XBICNETi = XBICHDi - (BICDNi * (1 - positif(ART1731BIS) ))  ;
pour i=V,C,P:
XBICSi =  XBICNETi + BA1Ai ;
pour i=V,C,P:
XBICNPHDi = BICNPEXi + BICREi ;
pour i=V,C,P:
XBICNPNETi = XBICNPHDi - (min(BICDEi,BICDEi1731+0) * positif(ART1731BIS) + BICDEi * (1 - ART1731BIS));
pour i=V,C,P:
XBICNPSi =  XBICNPNETi + BI2Ai ;
pour  i = V,C,P:
XBITi = max (0 , XBICNETi + max (0,XBICNPNETi )); 
pour  i = V,C,P:
XBISi = positif(max(0,XBICNETi + max(0,XBICNPNETi)))
        * ( BI2Ai  + BI1Ai  );

pour i=V,C,P:
XBICIMPi =  XBICHDi + XBICNPHDi ;
regle 8728:
application : iliad , batch ;
pour i=V,C:
XTSBi =  somme(x=1..3:GLDxi) + TSBNi + BPCOSAi + TSASSUi + XETRANi + EXOCETi 
	 + GLDGRATi;

pour i=1,2,3,4:
XTSBi =  TSBNi ;
pour i=V,C:
XEXTSi = XTSBi + CARTSi + REMPLAi;
pour i=1,2,3,4:
XEXTSi = XTSBi + CARTSPi + REMPLAPi;
regle 8731:
application : iliad , batch ;
pour i = V,C,1,2,3,4:
XTPS10i = arr (XEXTSi * TX_DEDFORFTS /100);
pour i = V,C,1,2,3,4:
XDFNi =  min( PLAF_DEDFORFTS , XTPS10i );
regle 8729:
application : iliad , batch ;
pour i = V,C,1,2,3,4:
X10MINSi= max( min(XTSBi,DEDMINi) , XDFNi );
pour i = V,C,1,2,3,4:
XIND_10i= positif_ou_nul(X10MINSi-FRNi);
pour i = V,C,1,2,3,4:
XDFi = X10MINSi  ;
pour i = V,C,1,2,3,4:
XFPTi = XDFi * XIND_10i + FRDi * (1 - XIND_10i);
pour i = V,C,1,2,3,4:
XTSNTi =  XEXTSi - XFPTi;
regle 8734:
application : iliad , batch ;
pour i = V,C,1,2,3,4:
XTSNi = positif (-XTSNTi) * min (0 , XTSNTi)
     + positif_ou_nul (XTSNTi) * XTSNTi;
regle 8735:
application : iliad , batch ;
pour i = V,C:
XTSi = XTSNi -  somme(x=1..3: max(0,GLDxi - ABGLxi));
pour i = V,C:
XTSNNi = arr( positif(XTSNi) * 
         XTSNi  
         * (TSASSUi/XEXTSi)) * XIND_10i
	 + (1-XIND_10i) * TSASSUi;
pour i = V,C:
XETSNNi = arr( positif(XTSNi) * 
         XTSNi  
         * (XETRANi/XEXTSi)) * XIND_10i
	 + (1-XIND_10i) * XETRANi;
pour i = V,C:
XEXOCETi = arr( positif(XTSNi) * 
         XTSNi  
         * (EXOCETi/XEXTSi)) * XIND_10i
	 + (1-XIND_10i) * EXOCETi;
XEXOCET = somme(i=V,C:XEXOCETi);

regle 876:
application : iliad , batch ;
XELU = ELURASC + ELURASV ;
regle 880:
application : iliad , batch ;

PVTAUX = (BPVSJ + BPVSK + BPV18V + BPV18C + BPCOPTV + BPCOPTC + BPV40V + BPV40C + PEA + GAINPEA);
regle 875:
application : iliad , batch ;
GLN2NET = arr(GLN2 * GL2 / REV2);
GLN3NET = arr(GLN3 * GL3 / REV3);
QUOKIRE =   TEGL1 + TEGL2 + TEGL3 + RPQ4
             + somme (x=V,C,1..4 : TERPQPRRx+TERPQPRRZx+ TEGLFx+ TERPQTSx+ TERPQTSREMPx+TERPQPALIMx)
             + TERPQRF1 + TEGLRF2 + TERPQRCMDC + TERPQRCMFU + TERPQRCMCH
             + TERPQRCMTS + TERPQRCMGO + TERPQRCMTR + TERPQRVO + TERPQRVO5 + TERPQRVO6 + TERPQRVO7;
regle 8727:
application : iliad , batch ;

VARREVKIRE =  BPCAPTAXV + BPCAPTAXC
              + somme( i=V,C,P: XBAi+XBIPi+XBINPi+XBNi+XBNNPi)
              + somme (i=V,C,P: MIBEXi + MIBNPEXi + BNCPROEXi + XSPENPi)
              + somme (i=V,C,P: BNCCRi)
              + somme (i=V,C,P: BNCCRFi)
              + somme (i=V,C: XETSNNi)
              + somme (i=V,C: XEXOCETi)
              + somme (i=V,C: XTSNNi)
              + somme (i=V,C: XTSNNTYi)
              + somme (i=V,C,1,2,3,4: XHSUPTSNNi)
              + XFORFAIT + XACCESS 
              + RCMLIB + PPLIB 
              + GAINABDET
              + RCMEXCREF
              + RCM2FA
              + XELU 
              + RCMIMPAT
              + PVIMMO
              + PVMOBNR
              + PVTITRESOC
              + BTP3A
              + (1 - positif( IPVLOC )) * (1-positif(present(TAX1649)+present(RE168))) * (
                PVTAUX                                                                      )
	      ;
PVTXEFF2 = max(0,(BPVRCM + COD3SG + COD3SL + ABDETPLUS + ABIMPPV) - (DPVRCM + COD3SH + COD3SM + ABDETMOINS + ABIMPMV)) ;
PVTXEFF = (PVTAXSB + BPVRCM - PVTXEFF2) * positif(present(IPTEFN) + present(IPTEFP)) ;
REVKIRE = (1-null(IND_TDR)) *
 arr (
       max ( 0, ( 
                  (1-positif((max(0,VARIPTEFP-PVTXEFF) * positif(ART1731BIS) + max(0,IPTEFP-PVTXEFF) * (1 - ART1731BIS))
		  +((VARIPTEFN+PVTXEFF*present(IPTEFN)) * positif(ART1731BIS) + (IPTEFN+PVTXEFF*present(IPTEFN)) * (1 - ART1731BIS))+INDTEFF)) * (RI1RFR)  
                  + positif((max(0,VARIPTEFP-PVTXEFF) * positif(ART1731BIS) + max(0,IPTEFP-PVTXEFF) * (1 - ART1731BIS))
		  +((VARIPTEFN+PVTXEFF*present(IPTEFN)) * positif(ART1731BIS) + (IPTEFN+PVTXEFF*present(IPTEFN)) * (1 - ART1731BIS))+INDTEFF) 
					 * (max(0,VARIPTEFP-PVTXEFF) * positif(ART1731BIS) + max(0,IPTEFP-PVTXEFF) * (1 - ART1731BIS))
                  + positif((max(0,VARIPTEFP-PVTXEFF) * positif(ART1731BIS) + max(0,IPTEFP-PVTXEFF) * (1 - ART1731BIS))
		  +((VARIPTEFN+PVTXEFF*present(IPTEFN)) * positif(ART1731BIS) + (IPTEFN+PVTXEFF*present(IPTEFN)) * (1 - ART1731BIS))+INDTEFF) 
                  * positif(- TEFFN - DRBG - RNIDF + (APERPV + APERPC + APERPP)* (1 - positif(null(2-V_REGCO) + null(4-V_REGCO))) + QUOKIRE)*
		   ( (APERPV + APERPC + APERPP)* (1 - positif(null(2-V_REGCO) + null(4-V_REGCO)))
		   + QUOKIRE
                   ) 
                  + max(0,TEFFREVTOTRFR*INDTEFF) * (1-positif((max(0,VARIPTEFP- PVTXEFF) * positif(ART1731BIS) + max(0,IPTEFP-PVTXEFF) * (1 - ART1731BIS))))
                )
                * (1-present(IND_TDR))
                + 
                   IND_TDR
		   + (1-positif((max(0,VARIPTEFP - PVTXEFF)* positif(ART1731BIS) + max(0,IPTEFP-PVTXEFF) * (1 - ART1731BIS))
					   +((VARIPTEFN+PVTXEFF*present(IPTEFN)) * positif(ART1731BIS) + (IPTEFN+PVTXEFF*present(IPTEFN))* (1 - ART1731BIS))+INDTEFF)) * 
		     (QUOKIRE + (APERPV + APERPC + APERPP)* (1 - positif(null(2-V_REGCO) + null(4-V_REGCO))) )
		   +  VARREVKIRE
             )
       ) 
       ;

pour i=V,C,P:
BNCCREAi = BNCCRi + BNCCRFi ;
QUOKIREHR =   TGL1 + TGL2 + TGL3 + TGL4
             + somme (x=V,C,1..4 : TGLPRRx+TGLPRRZx+ TGLFx+ TGLTSx+ TGLTSREMPx+TGLPALIMx)
             + TGLRF1 + TGLRF2 + TGLRCMDC + TGLRCMFU + TGLRCMCH
             + TGLRCMTS + TGLRCMGO + TGLRCMTR + TGLRVO + TGLRVO5 + TGLRVO6 + TGLRVO7;
REVKIREHR =  ((1-null(IND_TDR)) *
 arr (
       max ( 0, ( 
                  (1-positif((max(0,VARIPTEFP-PVTXEFF)  * positif(ART1731BIS) + max(0,IPTEFP-PVTXEFF) * (1 - ART1731BIS))
		  +((VARIPTEFN+PVTXEFF*present(IPTEFN))  * positif(ART1731BIS) + (IPTEFN+ PVTXEFF*present(IPTEFN)) * (1 - ART1731BIS))+INDTEFF)) * (RI1RFRHR)  
                  + positif((max(0,VARIPTEFP-PVTXEFF)  * positif(ART1731BIS) + max(0,IPTEFP-PVTXEFF) * (1 - ART1731BIS))
		  +((VARIPTEFN+PVTXEFF*present(IPTEFN))  * positif(ART1731BIS) + (IPTEFN+ PVTXEFF*present(IPTEFN)) * (1 - ART1731BIS))+INDTEFF) 
				* (max(0,VARIPTEFP-PVTXEFF)  * positif(ART1731BIS) + max(0,IPTEFP-PVTXEFF) * (1 - ART1731BIS))
                  + positif((max(0,VARIPTEFP-PVTXEFF)  * positif(ART1731BIS) + max(0,IPTEFP-PVTXEFF) * (1 - ART1731BIS))
			  +((VARIPTEFN+PVTXEFF*present(IPTEFN))  * positif(ART1731BIS) + (IPTEFN+PVTXEFF*present(IPTEFN))  * (1 - ART1731BIS))+INDTEFF) 
                   * positif(- TEFFN - DRBG - RNIDF + (APERPV + APERPC + APERPP)* (1 - positif(null(2-V_REGCO) + null(4-V_REGCO))) + QUOKIREHR)*
		   ( (APERPV + APERPC + APERPP)* (1 - positif(null(2-V_REGCO) + null(4-V_REGCO))) 
		   + QUOKIREHR 
                   ) 
                  + max(0,TEFFREVTOTRFRHR*INDTEFF) * (1-positif((max(0,VARIPTEFP- PVTXEFF) * positif(ART1731BIS) + max(0,IPTEFP-PVTXEFF) * (1 - ART1731BIS))))
                )
                * (1-present(IND_TDR))
                + 
                   IND_TDR
		   + (1-positif((max(0,VARIPTEFP- PVTXEFF) * positif(ART1731BIS) + max(0,IPTEFP-PVTXEFF) * (1 - ART1731BIS))
		   +((VARIPTEFN+PVTXEFF*present(IPTEFN)) * positif(ART1731BIS) + (IPTEFN+PVTXEFF*present(IPTEFN)) * (1 - ART1731BIS))+INDTEFF)) * 
		     (QUOKIREHR + (APERPV + APERPC + APERPP)* (1 - positif(null(2-V_REGCO) + null(4-V_REGCO)))) 
		   +  VARREVKIRE
             )
       ) 
              ) * (1-present(COD8YM)) + COD8YM     ;
regle 410 :
application : batch, iliad;
CDEVDUR_NBJ = PPENBJ;
CKIREDUR = arr(REVKIRE * 360/CDEVDUR_NBJ);
REVKIREDUR2 = CKIREDUR ;


