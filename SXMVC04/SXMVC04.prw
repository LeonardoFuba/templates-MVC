//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} SXMVC03
 * Função para cadastros de Promoções
 * @author Leonardo do Nascimento
 * @since 31/10/2023
 * @version 1.0
/*/

User Function SXMVC04()
	Local oBrowse := Nil
  Private aRotina	:= MenuDef()

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZCA")
	oBrowse:SetDescription("Contratos")
	oBrowse:Activate()
Return Nil

Static Function ModelDef()
	Local oModel := MPFormModel():New('SXMVC04')
  /* Campos que compoem cada estrutura*/
	Local oStruTab1    := FWFormStruct(1, 'ZCA')
	Local oStruTab2 	:= FWFormStruct(1, 'ZCB')

  /* Relacionamentos */
	oModel:AddFields('MdFieldZCB', Nil, oStruTab1)
  oModel:SetPrimaryKey({ "ZCA_COD" })
	oModel:SetDescription("Contrato")

	oModel:AddFields("MdFieldZCB", "MdFieldZCA", oStruTab2)
	oModel:SetRelation("MdFieldZCB", {{"ZCB_FILIAL", "FwXFilial('ZCB')"}, { "ZCB_COD", "ZCA_COD" } }, ZCB->(IndexKey(1)) )
	oModel:GetModel("MdFieldZCB"):SetDescription("Assinatura")

Return oModel


Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView := FWFormView():New()
	Local oStruTab1 := FWFormStruct(2, "ZCB")
	Local oStruTab2 := FWFormStruct(2, "ZCA")

	// Relacionando os modelos
	oView:SetModel(oModel)
	oView:AddField('FORM_ZCA', oStruTab1, 'MdFieldZCA')
	oView:AddField('FORM_ZCB', oStruTab2, 'MdFieldZCB')

  // Layout da tela
	oView:CreateHorizontalBox("BOXSUP", 60)
	oView:CreateHorizontalBox("BOXINF", 40)

	// Anexa elementos
	oView:SetOwnerView('FORM_ZCA', 'BOXSUP')
	oView:SetOwnerView('FORM_ZCB', 'BOXINF')

	oView:EnableTitleView("FORM_ZCA","Dados do Contrat")
	oView:EnableTitleView("FORM_ZCB","Dados da Assinatura")
Return oView


//Função chamada para montar o menu do Browser
Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.SXMVC04" OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 2
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.SXMVC04" OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.SXMVC04" OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
Return aRotina
