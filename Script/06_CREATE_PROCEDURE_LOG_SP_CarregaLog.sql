USE [LOGPROCESSAMENTO]
GO

/****** Object:  StoredProcedure [dbo].[STP_SIU_CarregaLog]    Script Date: 08/01/2023 23:29:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM SYS.procedures WHERE NAME = 'SP_CarregaLog')
DROP PROCEDURE [dbo].[SP_CarregaLog]
GO

CREATE PROCEDURE [dbo].[SP_CarregaLog]
	@Grupo char(3) --STG / ODS / DW / MIS
	,@IdPacote varchar(50) = ''
	,@NomePacote varchar(70) = ''
	,@IdTarefa varchar(50) = ''
	,@NomeTarefa varchar(70) = ''
	,@Descricao varchar(200) = ''
	,@QtdLinhasInseridas bigint = 0
	,@QtdLinhasAtualizadas bigint = 0
	,@TipoExecucao char(1) --I-iniciado / F-finalizado / E-erro
as
begin
	SET NOCOUNT ON;
	
	declare @IdCarga bigint = 0
	declare @IdCargaDetalhe bigint = 0
		    
	declare @IdPacote_c varchar(50)
	declare @IdTarefa_c varchar(50)
	declare @CodRef bigint
	declare @DataAtual datetime = GETDATE()
	
	
	-- FORMATA VALORES DAS VARIAVEIS INFORMADAS
	set @IdPacote_c = REPLACE(REPLACE(@IdPacote, '{', ''), '}', '')
	set @IdTarefa_c = REPLACE(REPLACE(@IdTarefa, '{', ''), '}', '')
	set @CodRef  = CONVERT(VARCHAR(8), @DataAtual, 112) + REPLACE(CONVERT(VARCHAR(5), @DataAtual, 114), ':', '')
			
	-- BUSCA O MAIOR ID RELACIONADO AO PACOTE INFORMADO (UTILIZADO APENAS NA INSERÇÃO E ATUALIZAÇÃO DO DETALHE DO LOG CARGA).
	select @IdCarga = MAX(IdCarga)
	from dbo.TB_Carga cg
	where cg.IdPacote = @IdPacote_c
	
	-- BUSCA O MAIOR ID RELACIONADO A TAREFA INFORMADA PARA O PACOTE EM EXECUÇÃO (
	select 
		@IdCargaDetalhe = MAX(CD1.IdCargaDetalhe)
	from [dbo].[TB_CargaDetalhe] CD1
	where CD1.IdTarefa = @IdTarefa_c
	and CD1.IdCarga = @IdCarga	
		    
	If (@TipoExecucao = 'I')
	begin
		-- VERIFICA SE AS INFORMAÇÕES SÃO NO NIVEL DE PACOTE OU TAREFA
		IF (@IdPacote = @IdTarefa) --PACOTE
		BEGIN 
			INSERT INTO [dbo].[TB_Carga]
			(
			   [AbrGrupo],[CodRef],[IdPacote],[NomPacote],[DthInicio],[TpoExecucao],[DthFim]
			)
			VALUES
			(
				@Grupo,@CodRef,@IdPacote_c,@NomePacote,@DataAtual,@TipoExecucao,null
			)
		END
		ELSE --TAREFA
		BEGIN
			INSERT INTO [dbo].[TB_CargaDetalhe]
			(
				[IdCarga],[IdTarefa],[NomTarefa],[Descricao],[QtdLinhasInseridas],[QtdLinhasAtualizadas],[TpoExecucao],[DthInicio],[DthFim]
			)
			VALUES
			(
			   @IdCarga,@IdTarefa_c,@NomeTarefa,@Descricao,@QtdLinhasInseridas,@QtdLinhasAtualizadas,@TipoExecucao,@DataAtual,null
			)
		END
	end
	else
	begin
		-- VERIFICA SE AS INFORMAÇÕES SÃO NO NIVEL DE PACOTE OU TAREFA
		IF (@IdPacote = @IdTarefa) --PACOTE
		BEGIN 
			UPDATE [dbo].[TB_Carga]
			   SET 
				  [TpoExecucao] = case when [TpoExecucao] = 'E' then [TpoExecucao] else @TipoExecucao end
				  ,[DthFim] = @DataAtual
			 WHERE IdCarga = (
							select MAX(IdCarga) from dbo.TB_Carga cg where cg.IdPacote = @IdPacote_c
							)
		END
		ELSE --TAREFA
		BEGIN
			UPDATE [dbo].[TB_CargaDetalhe]
				SET 
				  [Descricao] = case when isnull(@Descricao, '') != '' then @Descricao else [Descricao] end
				  ,[QtdLinhasInseridas] = case when @QtdLinhasInseridas > 0 then @QtdLinhasInseridas else [QtdLinhasInseridas] end
				  ,[QtdLinhasAtualizadas] = case when @QtdLinhasAtualizadas > 0 then @QtdLinhasAtualizadas else [QtdLinhasAtualizadas] end
				  ,[TpoExecucao] = case when [TpoExecucao] = 'E' then [TpoExecucao] else @TipoExecucao end
				  ,[DthFim] = @DataAtual
			WHERE IdCargaDetalhe = @IdCargaDetalhe
		END
	end

end