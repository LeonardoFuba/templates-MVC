//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

#DEFINE ID_FUNCAO "SXPOR13"

/*/{Protheus.doc} SXPOR13
 * Funcao para cadastros de Intervalos para aplicar regra de volumetria
 * @author Leonardo do Nascimento
 * @since 05/07/2023
 * @version 1.0
/*/

User Function SXPOR13()
	Local aArea   := GetArea()
	Local oBrowse

	//Cria um browse para a ZS4
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZSB")
	oBrowse:SetDescription("Intervalos para doses")
	oBrowse:Activate()

	RestArea(aArea)
Return Nil

Static Function ModelDef()
	//Na montagem da estrutura do Modelo de dados, o cabecalho filtrara e exibira somente 3 campos, ja¡ a grid ira carregar a estrutura inteira conforme funcao fModStruct
	Local oModel      := MPFormModel():New('SXPOR13M')
	Local oStruCab    := FWFormStruct(1, 'ZSB')
	Local oStruGrid 	:= FwFormStruct(1, 'ZS4')

	//Agora, define no modelo de dados, que tera um Cabecalho e uma Grid apontando para estruturas acima
	oModel:AddFields('FIELD1', Nil, oStruCab)
	oModel:SetPrimaryKey({"ZSB_FILIAL", "ZSB_GRUPO"})

	oModel:AddGrid('GRID1', 'FIELD1', oStruGrid,)
	oModel:SetRelation('GRID1', { {'ZS4_FILIAL', 'xFilial("ZS4")'}, {"ZS4_GRUPO",  "ZSB_GRUPO"} }, ZS4->(IndexKey(1)))

Return oModel



Static Function ViewDef()
	//Na montagem da estrutura da visualizacao de dados, vamos chamar o modelo criado anteriormente, no cabecalho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a funcao fViewStruct
	Local oView      := FWFormView():New()
	Local oModel     := ModelDef()
	Local oStruCab   := FWFormStruct(2, "ZSB")
	Local oStruGrid  := FWFormStruct(2, 'ZS4')

	//Cria o View
	oView:SetModel(oModel)
	oView:AddField('VIEW_ZSB', oStruCab, 'FIELD1')
	oView:AddGrid('VIEW_ZS4', oStruGrid, 'GRID1')

	oView:CreateHorizontalBox("BOXSUP", 10)
	oView:CreateHorizontalBox("BOXINF", 90)

	oView:SetOwnerView('VIEW_ZSB', 'BOXSUP')
	oView:SetOwnerView('VIEW_ZS4', 'BOXINF')

	oView:EnableControlBar(.T.)

	//Define o campo incremental da grid como o ZS4_ITEM
	// oView:AddIncrementField('VIEW_ZS4', 'ZS4_ID')
Return oView


//Funcao chamada para montar o menu do Browser
Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.SXPOR13" OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 2
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.SXPOR13" OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.SXPOR13" OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
Return aRotina
