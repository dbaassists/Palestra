USE [LOGPROCESSAMENTO]
GO

/****** Object:  StoredProcedure [SCH_LOG].[STP_SIU_CarregaLogErro]    Script Date: 08/01/2023 23:29:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM SYS.procedures WHERE NAME = 'SP_CarregaLogErro')
DROP PROCEDURE [dbo].[SP_CarregaLogErro]
GO

CREATE PROCEDURE  [dbo].[SP_CarregaLogErro]
	@IdPacote varchar(50)
	,@IdTarefa varchar(50)
	,@NomeTarefa varchar(60)
	,@NumeroErro int = 0
	,@DescricaoErro varchar(8000) = ''
	,@LinhaRegistro varchar(max) = ''
as
begin
	SET NOCOUNT ON;
	
	declare @IdCarga bigint = 0
	declare @IdCargaDetalhe bigint = 0
	declare @DataHoraErro datetime = getdate()
	
	declare @IdPacote_c varchar(50)
	declare @IdTarefa_c varchar(50)
	
	-- FORMATA VALORES DAS VARIAVEIS INFORMADAS
	set @IdPacote_c = REPLACE(REPLACE(@IdPacote, '{', ''), '}', '')
	set @IdTarefa_c = REPLACE(REPLACE(@IdTarefa, '{', ''), '}', '')
	
	
	select @IdCarga = MAX(IdCarga)
	from dbo.TB_Carga cg
	where cg.IdPacote = @IdPacote_c
	
	select 
		@IdCargaDetalhe = MAX(CD1.IdCargaDetalhe)
	from [dbo].[TB_CargaDetalhe] CD1
	where CD1.IdTarefa = @IdTarefa_c
	and CD1.IdCarga = @IdCarga
		
	--Insere o erro na tabela de log de erros
	INSERT INTO [dbo].[TB_CargaErro]
           ([IdCargaDetalhe]
           ,[NomTarefa]
           ,[NumErro]
           ,[DscErro]
           ,[LinhaRegistro]
           ,[DthErro])
     VALUES
           (@IdCargaDetalhe
           ,@NomeTarefa
           ,@NumeroErro
           ,@DescricaoErro
           ,@LinhaRegistro
           ,@DataHoraErro)
          
    --Atualiza a situação da etapa que ocorreu o erro para "E" na tabela de carga
    update a set 
		a.TpoExecucao = 'E'
		,a.DthFim = @DataHoraErro
	from dbo.TB_CargaDetalhe a
	where a.IdCargaDetalhe = @IdCargaDetalhe     
               
    --Atualiza a situação da etapa que ocorreu o erro para "E" na tabela de carga detalhe
    update a set 
		a.TpoExecucao = 'E'
		,a.DthFim = @DataHoraErro
	from dbo.TB_Carga a
	where a.IdCarga = @IdCarga

end
