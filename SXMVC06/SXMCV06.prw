#Include "Protheus.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} WDPOR01
 * Função para cadastros de Representantes
 * @author Leonardo do Nascimento
 * @since 05/07/2023
 * @version 1.0
/*/
User Function WDPOR01()
	Local oBrowse := Nil
	Private aRotina	:= MenuDef()

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZZA")
	oBrowse:SetDescription("Cadastro de Representante")
	oBrowse:Activate()
Return

/* Definicao do modelo */
Static Function ModelDef()
	Local oModel := MPFormModel():New("MSXMVC01")
	/* Campos que compoem cada estrutura*/
	Local oFieldsCab := FWFormStruct(1, "ZZA") //{|cCampo| AllTrim(cCampo) $ "ZZA_COD;ZZA_DESCRI"}
	Local oGridCliente := FWFormStruct(1, "ZZB")
	Local oFieldsPortal := FWFormStruct(1, "ZZC")
	Local oFieldsArea := FWFormStruct(1, "ZZF")

	oFieldsArea:SetProperty("ZZF_CODUSU", MODEL_FIELD_OBRIGAT, .F.)

	/* Relacionamentos */
	oModel:AddFields("MdFieldZZA", Nil, oFieldsCab)
	oModel:SetPrimaryKey({ "ZZA_COD" })
	oModel:SetDescription("Cadastro de Produtos Representantes")

	oModel:AddFields("MdFieldZZF", "MdFieldZZA", oFieldsArea)
	oModel:SetRelation("MdFieldZZF", {{"ZZF_FILIAL", "FwXFilial('ZZF')"}, { "ZZF_CODREP", "ZZA_COD" } }, ZZF->(IndexKey(2)) )
	oModel:GetModel("MdFieldZZF"):SetDescription("Áreas do Representante")
	oModel:GetModel("MdFieldZZF"):SetOptional(.T.)

	oModel:AddFields("MdFieldZZC", "MdFieldZZA", oFieldsPortal)
	oModel:SetRelation("MdFieldZZC", {{"ZZC_FILIAL", "FwXFilial('ZZC')"}, { "ZZC_COD", "ZZF_CODUSU" } }, ZZC->(IndexKey(1)) )
	oModel:GetModel("MdFieldZZC"):SetDescription("Acesso Salesmove do Representante")

	oModel:AddGrid("MdGridZZB", "MdFieldZZA", oGridCliente)
	oModel:SetRelation("MdGridZZB", { { "ZZB_CODREP", "ZZA_COD" } }, ZZB->(IndexKey(1)) )
	oModel:GetModel("MdGridZZB"):SetUniqueLine( { "ZZB_CODCLI", "ZZB_LOJA" } )
	oModel:GetModel("MdGridZZB"):SetDescription("Clientes do Representante")
	oModel:GetModel("MdGridZZB"):SetOptional(.T.)

Return oModel

/* Definicao da interface visual */
Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView := FWFormView():New()
	Local oFormCab := FWFormStruct(2, "ZZA") //, {|cCampo| AllTrim(cCampo) $ "ZZA_;ZZA_"}
	Local oGridCli := FWFormStruct(2, "ZZB") //, {|cCampo| AllTrim(cCampo) $ "ZZB_CODREP"}
	Local oFormPor := FWFormStruct(2, "ZZC") //, {|cCampo| !AllTrim(cCampo) $ "ZZC_LENOTF;ZZC_"}
	Local oFormArea := FWFormStruct(2, "ZZF") //, {|cCampo| !AllTrim(cCampo) $ "ZZF_CODUSU;ZZF_CODREP"}

	oFormCab:SetNoFolder()

	/* Relacionando os modelos*/
	oView:SetModel(oModel)
	oView:AddField("FORM_ZZA", oFormCab, "MdFieldZZA")
	oView:AddGrid("GRID_ZZB" , oGridCli,"MdGridZZB")
	oView:AddField("FORM_ZZC", oFormPor, "MdFieldZZC")
	oView:AddField("FORM_ZZF", oFormArea, "MdFieldZZF")

  /* Layout da tela */
	oView:CreateVerticalBox("BOXESQ", 60)
	oView:CreateVerticalBox("BOXDIR", 40)
	oView:CreateHorizontalBox("BOX1", 15, "BOXESQ")
	oView:CreateHorizontalBox("BOX2", 15, "BOXESQ")
	oView:CreateHorizontalBox("BOX3", 70 ,"BOXESQ")

	/*Anexa elementos*/
	oView:SetOwnerView("FORM_ZZA", "BOX1")
	oView:SetOwnerView("FORM_ZZF", "BOX2")
	oView:SetOwnerView("FORM_ZZC", "BOX3")
	oView:SetOwnerView("GRID_ZZB", "BOXDIR")

	oView:EnableTitleView("FORM_ZZA","Dados do Representante")
	oView:EnableTitleView("GRID_ZZB","Clientes(SA1) do Representante")
	oView:EnableTitleView("FORM_ZZF","Área")
	oView:EnableTitleView("FORM_ZZC","Cadastro portal")

	//Removendo campos
	oGridCli:RemoveField("ZZB_CODREP")
	oFormArea:RemoveField("ZZF_CODREP")
Return oView

/* Definicao do controlador */
Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.WDPOR01" OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.WDPOR01" OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.WDPOR01" OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.WDPOR01" OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
	ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.SXMVC01" OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE "Copiar"     ACTION "VIEWDEF.SXMVC01" OPERATION 9 ACCESS 0
Return aRotina
