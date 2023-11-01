//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} SXMVC03
 * Função para cadastros de Promoções
 * @author Leonardo do Nascimento
 * @since 31/10/2023
 * @version 1.0
/*/

User Function SXMVC03()
	Local oBrowse := Nil
  Private aRotina	:= MenuDef()

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZB1")
	oBrowse:SetDescription("Promoções")
	oBrowse:Activate()
Return Nil

Static Function ModelDef()
	Local oModel := MPFormModel():New('MSXMVC03')

  /* Campos que compoem cada estrutura*/
	Local oStruCab    := FWFormStruct(1, 'ZB1')
	Local oStruGrid 	:= FWFormStruct(1, 'ZB2')

  /* Relacionamentos */
	oModel:AddFields('MdFieldZB1', NIL, oStruCab)
  oModel:SetPrimaryKey({ "ZB1_COD" })
	oModel:SetDescription("Cadastro de Produtos em promoção")

  oModel:AddGrid("MdGridZB2", "MdFieldZB1", oStruGrid)
	oModel:SetRelation("MdGridZB2", {{'ZB2_FILIAL', 'xFilial("ZB2")'}, { "ZB2_PRODUT", "ZB1_COD" } }, ZB2->(IndexKey(1)) )
	oModel:GetModel("MdGridZB2"):SetUniqueLine( { "ZB2_PRODUT" } )
	oModel:GetModel("MdGridZB2"):SetDescription("Produtos da promoção")
	oModel:GetModel("MdGridZB2"):SetOptional(.T.)
	oModel:GetModel("MdGridZS4"):SetMaxLine(9999)

Return oModel


Static Function ViewDef()
	Local oModel    := ModelDef()
	Local oView     := FWFormView():New()
	Local oStruCab  := FWFormStruct(2, "ZB1")
	Local oStruGrid := FWFormStruct(2, "ZB2")

	oStruCab:SetNoFolder()

	// Relacionando os modelos
	oView:SetModel(oModel)
	oView:AddField('VIEW_ZB1', oStruCab, 'MdFieldZB1')
	oView:AddGrid('GRID_ZB2', oStruGrid, 'MdGridZB2')

  // Layout da tela
	oView:CreateHorizontalBox("BOXSUP", 10)
	oView:CreateHorizontalBox("BOXINF", 90)

	// Anexa elementos
	oView:SetOwnerView('VIEW_ZB1', 'BOXSUP')
	oView:SetOwnerView('GRID_ZB2', 'BOXINF')

	//Define o campo incremental da grid como o ZB2_ITEM
	oView:AddIncrementField('GRID_ZB2', 'ZB2_ITEM')

  //Removendo campos
  oStruGrid:RemoveField("ZB2_FILIAL")

Return oView


//Função chamada para montar o menu do Browser
Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.SXMVC03" OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 2
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.SXMVC03" OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.SXMVC03" OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
Return aRotina
