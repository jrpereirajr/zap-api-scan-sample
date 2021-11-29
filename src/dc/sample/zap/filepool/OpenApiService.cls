Class dc.sample.zap.filepool.OpenApiService Extends dc.sample.zap.OpenApiService
{

Property OutputFileName As %String;

Property OutputPath As %String [ InitialExpression = "/irisdev/app/zap-pool/api-specs" ];

Method %OnNew(pWebAppName As %String, pNameSpace As %String = {$Namespace}, pOutputFileName As %String) As %Status
{
    Set ..WebAppName = pWebAppName
    Set ..NameSpace = pNameSpace
    Set ..OutputFileName = pOutputFileName
    Return $$$OK
}

Method SaveOpenApiSpec() As %String
{
    Set spec = ..GetOpenApiSpecFromWebApp()
    Set file = ##class(%File).%New(..OutputPath_"/"_..OutputFileName)
    Try {
        $$$TOE(st, file.Open("WSN"))
        $$$TOE(st, file.Write(spec.%ToJSON()))
    }
    Catch(e) {
        Do file.Close()
        Throw e
    }
    Return ..OutputFileName
}

}
