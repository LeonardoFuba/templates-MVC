#Include "Protheus.ch"
#Include "FWMVCDEF.ch"

#DEFINE cTabela "ZZ6"

/*/{Protheus.doc} ModelDef
 * Definicao do modelo de Dados
 * @author Leonardo do Nascimento
 * @since 01/08/2021
 * @version 1.0
/*/
User Function SXMVC01()
	Local oBrowse := Nil
	// Private aRotina	:= FWMVCMenu("SXMVC01")
	Private aRotina	:= MenuDef()

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(cTabela)
	oBrowse:SetDescription("Cadastro de Exemplo")
	oBrowse:Activate()
Return

/* Definicao do modelo */
Static Function ModelDef()
	Local oModel := MPFormModel():New("MSXMVC01")
	Local oFields := FWFormStruct(1, cTabela)

	// oModel:SetDescription("Cadastro de Exemplo")
	oModel:addFields("FIELDZZ6", , oFields)
	oModel:SetPrimaryKey({ "ZZ6_CODIGO" })
Return oModel

/* Definicao da interface visual */
Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView := FWFormView():New()
	Local oForm1 := FWFormStruct(2, cTabela)

	oView:SetModel(oModel)
	oView:AddField("FORMZZ6", oForm1, "FIELDZZ6")

  /* Formulario ocupando tela inteira */
	oView:CreateHorizontalBox("BOXFORMZZ6", 100)
	oView:SetOwnerView("FORMZZ6", "BOXFORMZZ6")
Return oView

/* Definicao do controlador */
Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.SXMVC01" OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 2
	ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.SXMVC01" OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.SXMVC01" OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.SXMVC01" OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
	// ADD OPTION aRotina TITLE "Imprimir"   ACTION "VIEWDEF.SXMVC01"  OPERATION 8 ACCESS 0
	// ADD OPTION aRotina TITLE "Copiar"     ACTION "VIEWDEF.SXMVC01"  OPERATION 9 ACCESS 0
Return aRotina
