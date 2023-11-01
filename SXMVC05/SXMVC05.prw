//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} SXPOR13
 * Função para cadastros de Intervalos para aplicar regra de volumetria
 * @author Leonardo do Nascimento
 * @since 31/10/2023
 * @version 1.0
/*/

User Function SXMVC05()
	Local oBrowse

	//Cria um browse para a ZS4
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZT1")
	oBrowse:SetDescription("Exmplo 2 grids")
	oBrowse:Activate()
Return Nil

Static Function ModelDef()
	Local oModel      := MPFormModel():New('MSXMVC05')
  /* Campos que compoem cada estrutura*/
	Local oStruCab    := FWFormStruct(1, 'ZT1')
	Local oStruGrid1 	:= FWFormStruct(1, 'ZT2')
	Local oStruGrid2	:= FWFormStruct(1, 'ZT3')

  /* Relacionamentos */
	oModel:AddFields('MdFieldZT1', Nil, oStruCab)
  oModel:SetPrimaryKey({ "ZT1_COD" })
	oModel:SetDescription("Cabeçalho de teste")

	oModel:AddGrid('MdGridZT2', 'MdFieldZT1', oStruGrid1)
  Model:SetRelation("MdGridZT2", {{'ZT2_FILIAL', 'xFilial("ZT2")'}, { "ZT2_COD", "ZT1_COD" } }, ZT2->(IndexKey(1)) )
	oModel:GetModel("MdGridZT2"):SetDescription("Descrição do grid1")
	oModel:GetModel("MdGridZT2"):SetOptional(.T.)

	oModel:AddGrid('MdGridZT3', 'MdGridZT2', oStruGrid2)
  oModel:SetRelation("MdGridZT3", {{'ZT3_FILIAL', 'xFilial("ZT3")'}, { "ZT3_COD", "ZT2_COD" } }, ZT3->(IndexKey(1)) )
	oModel:GetModel("MdGridZT3"):SetDescription("CDescrição do grid2")
	oModel:GetModel("MdGridZT3"):SetOptional(.T.)

Return oModel


Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView := FWFormView():New()

	Local oStruCab := FWFormStruct(2, "ZT1")
	Local oStruGrid1 := FWFormStruct(2, "ZT2")
	Local oStruGrid2 := FWFormStruct(2, "ZT3")

	// Relacionando os modelos
	oView:SetModel(oModel)
	oView:AddField('FORM_ZT1', oStruCab, 'MdFieldZT1')
	oView:AddGrid('GRID_ZT2', oStruGrid1, 'MdGridZT2')
	oView:AddGrid('GRID_ZT3', oStruGrid2, 'MdGridZT3')

  // Layout da tela
  oView:CreateVerticalBox("BOXESQ", 30)
	oView:CreateVerticalBox("BOXDIR", 70)
	oView:CreateHorizontalBox("BOX1", 50, "BOXDIR")
	oView:CreateHorizontalBox("BOX2", 50, "BOXDIR")

	// Anexa elementos
	oView:SetOwnerView('VIEW_ZT1', 'BOXESQ')
	oView:SetOwnerView('GRID_ZT2', 'BOX1')
	oView:SetOwnerView('GRID_ZT3', 'BOX2')

Return oView


//Função chamada para montar o menu do Browser
Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.SXMVC05" OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 2
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.SXMVC05" OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.SXMVC05" OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
Return aRotina
