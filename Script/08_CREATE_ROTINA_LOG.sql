-- CONFIGURAÇÕES DO PACKAGE

---------------------------------------------------------------

-- OnPreExecute -

EXECUTE [dbo].[SP_CarregaLog] 
   ? -- User::Grupo
   ? -- System::PackageID
  ,? -- System::PackageName
  ,? -- System::SourceID
  ,? -- System::SourceName
  ,? -- System::SourceDescription
  ,0
  ,0
  ,'I'

-- OnPostExecute

EXECUTE [dbo].[SP_CarregaLog] 
   ? -- User::Grupo
   ? -- System::PackageID
  ,? -- System::PackageName
  ,? -- System::SourceID
  ,? -- System::SourceName
  ,? -- System::SourceDescription
  ,0
  ,0
  ,'F'

-- OnError

EXECUTE [dbo].[SP_CarregaLogErro] 
   ? -- System::PackageID
  ,? -- System::SourceID
  ,? -- System::SourceName
  ,? -- System::ErrorCode
  ,? -- System::ErrorDescription
  ,''

---------------------------------------------------------------

-- CONFIGURAÇÕES DO DFT

---------------------------------------------------------------

-- OnPostExecute

EXECUTE [dbo].[SP_CarregaLog] 
   ? -- User::Grupo
   ? -- System::PackageID
  ,? -- System::PackageName
  ,? -- System::SourceID
  ,? -- System::SourceName
  ,? -- System::SourceDescription
  ,? -- User::QtdLinhasInseridas
  ,? -- User::QtdLinhasAtualizadas
  ,'F'


