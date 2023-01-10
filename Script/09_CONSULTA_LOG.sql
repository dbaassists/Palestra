select cast(DthInicio as date) Data, * from 
(
select *, DATEDIFF(MINUTE,DthInicio, isnull(DthFim,getdate())) tempo from sgblog.SCH_LOG.TB_Carga with(NOLOCK)
where 1=1
--AND DthInicio >= '2017-05-04 01:40:00.000'
--(DthFim >= '2017-02-07 00:00:00.000') --  and DthFim <= '2017-02-08 17:59:00.000')
--and TpoExecucao = 'e'
--and idCarga in ( 65971, 65985, 65989 )
--and NomPacote like ('PKG-Carregar_Dados_Contato-SFE%' ) -- 'PKG-Carregar_Dados_Conta_Basicos-SFE' , 'PKG-Carregar_ODS_Dados_Mestre05-SD-N2')
--and NomPacote not in ('PKG-Carregar_DW_Dimensoes_Comercial02','PKG-Carregar_ODS_Dados_Transacionais03-IMPS-N5')
--and AbrGrupo  IN ( 'sfe')
--and AbrGrupo  not in ( 'SFE' , 'POR', 'LOG', 'LEG', 'LUM') --, 'STG','DW' ) --'SFE', 'POR', 'LOG', 'leg' , 'SGI') --'ODS' , 'DW')
--and NomPacote in ('PKG-Carregar_Dados_Site_Super', 'PKG-Carregar_Dados_Lumis_Cidade', 'PKG-Carregar_Dados_ANP')
--and NomPacote in (  'PKG-Carregar_ODS_Dados_Transacionais02-FI-N4' )
--AND NomPacote like ( '%PKG-Carregar_STG_Dados_Mestre01-PM%' )
--AND NomPacote like ( '%PKG-Carregar_STG_Dados_Mestre02-SD%' )
--AND NomPacote like ( '%SITE%' )
--AND NomPacote like ( '%expurgo%' )
) a
where 1=1
--and (nompacote in ( 'SHV_Carga_CCC_SGI'))
--and nompacote like '%capex%'
--and NomPacote IN ( 'PKG-Carregar_ODS_Dados_Transacionais02-FI-N4')
and YEAR(dthinicio)		>= 2022
--and month(dthinicio)	>= 11
--and DAY(dthinicio)	>= 21
--and TpoExecucao		<> 'i'
--and AbrGrupo  IN ( 'ods')
--and IdCarga			> 36774
--and DthFim is null
order by DthInicio desc
go


select		A.IdCarga 
			, b.IdCargaDetalhe
			, A.NomPacote
			, B.NomTarefa
			, convert(VARCHAR(10), b.DthInicio,103)	 data		
			, QtdLinhasInseridas
			, datediff(MINUTE, b.DthInicio, isnull(b.DthFim,GETDATE())) Duracao			
			, QtdLinhasAtualizadas
			, B.DthInicio
			, B.DthFim
--			, b.IdCargaDetalhe
--			, a.TpoExecucao
--			, case when b.DthFim is null then 'Em Execução' Else 'Finalizado' end Status
--			, b.DthInicio
--			, isnull(b.DthFim,GETDATE()) DthFimS
--			, b.IdCargaDetalhe			


from SGBLOG.SCH_LOG.TB_Carga A WITH(NOLOCK)
INNER JOIN SGBLOG.SCH_LOG.TB_CargaDetalhe B WITH(NOLOCK)
ON A.IdCarga = B.IdCarga

where A.DthInicio > '2016-06-14 19:00:00.000'
--and A.TpoExecucao = 'F'
--AND A.IdCarga IN ( 537919 )
--AND  NomTarefa = 'DFT- Carregar Dados TB_FLEET'
 and NomTarefa = 'DFT-Carga Frota'
-- 123558,124839 )
-- AND A.AbrGrupo = 'ODS'
-- and NomTarefa like 'DFT - Carrega TMP_Carteira_SGI%' 
order by b.IdCargaDetalhe desc