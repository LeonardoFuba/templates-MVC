//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} SXPOR13
 * Função para cadastros de Intervalos para aplicar regra de volumetria
 * @author Leonardo do Nascimento
 * @since 05/07/2023
 * @version 1.0
/*/

User Function SXPOR13()
	Local aArea   := GetArea()
	Local oBrowse

	//Cria um browse para a ZS4
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZS4")
	oBrowse:SetDescription("Intervalos para doses")
	oBrowse:Activate()

	RestArea(aArea)
Return Nil

Static Function ModelDef()
	//Na montagem da estrutura do Modelo de dados, o cabeçalho filtrará e exibirá somente 3 campos, já a grid irá carregar a estrutura inteira conforme função fModStruct
	Local oModel      := NIL
	Local oStruCab    := FWFormStruct(1, 'ZS4', {|cCampo| AllTrim(cCampo) $ "ZS4_GRUPO;ZS4_DESCRI"})
	Local oStruGrid 	:= FWFormStruct(1, 'ZS4')

	//Monta o modelo de dados, e na Pós Validação, informa a função fValidGrid
	oModel := MPFormModel():New('SXPOR13M', /*bPreValidacao*/, {|oModel| .T.}, /*bCommit*/, /*bCancel*/ )

	//Agora, define no modelo de dados, que terá um Cabeçalho e uma Grid apontando para estruturas acima
	oModel:AddFields('MdFieldZS4', NIL, oStruCab)
	oModel:AddGrid('MdGridZS4', 'MdFieldZS4', oStruGrid, , )

	//Monta o relacionamento entre Grid e Cabeçalho, as expressões da Esquerda representam o campo da Grid e da direita do Cabeçalho
	oModel:SetRelation('MdGridZS4', {;
		{'ZS4_FILIAL', 'xFilial("ZS4")'},;
		{"ZS4_GRUPO",  "ZS4_GRUPO"},;
		{"ZS4_DESCRI",  "ZS4_DESCRI"};
		}, ZS4->(IndexKey(1)))

	//Definindo outras informações do Modelo e da Grid
	oModel:GetModel("MdGridZS4"):SetMaxLine(9999)
	oModel:SetDescription("Campos e configurações")
	oModel:SetPrimaryKey({"ZS4_FILIAL", "ZS4_GRUPO"})

Return oModel


Static Function ViewDef()
	//Na montagem da estrutura da visualização de dados, vamos chamar o modelo criado anteriormente, no cabeçalho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a função fViewStruct
	Local oModel    := FWLoadModel('SXPOR13')
	Local oView     := FWFormView():New()

  // Lista de campos para compor a tela
	Local oStruCab  := FWFormStruct(2, "ZS4", {|cCampo| AllTRim(cCampo) $ "ZS4_GRUPO;ZS4_DESCRI"})
	Local oStruGrid := FWFormStruct(2, "ZS4", {|cCampo| !(Alltrim(cCampo) $ "ZS4_GRUPO;ZS4_DESCRI")})

	//Define que no cabeçalho não terá separação de abas (SXA)
	oStruCab:SetNoFolder()

	// Relacionando os modelos
	oView:SetModel(oModel)
	oView:AddField('VIEW_ZS4', oStruCab, 'MdFieldZS4')
	oView:AddGrid('GRID_ZS4', oStruGrid, 'MdGridZS4')

  // Layout da tela
	oView:CreateHorizontalBox("MAIN", 10)
	oView:CreateHorizontalBox("GRID", 90)

	// Anexa elementos
	oView:SetOwnerView('VIEW_ZS4', 'MAIN')
	oView:SetOwnerView('GRID_ZS4', 'GRID')

	//Define o campo incremental da grid como o ZS4_ITEM
	// oView:AddIncrementField('GRID_ZS4', 'ZS4_ITEM')

  //Removendo campos

Return oView


//Função chamada para montar o menu do Browser
Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.SXPOR13" OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 2
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.SXPOR13" OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.SXPOR13" OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
Return aRotina
