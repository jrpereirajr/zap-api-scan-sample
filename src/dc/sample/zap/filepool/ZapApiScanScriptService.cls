Class dc.sample.zap.filepool.ZapApiScanScriptService Extends %RegisteredObject
{

Property ScriptService As dc.sample.zap.filepool.ScriptService [ Private ];

Property OpenApiSpec As %String;

Method %OnNew(pOpenApiSpec As %String) As %Status
{
    Set ..OpenApiSpec = pOpenApiSpec
    Set outFile = $Replace($Replace($Now(), ".", ""), ",", "")_".txt"
    Set ..ScriptService = ##class(dc.sample.zap.filepool.ScriptService).%New(outFile)
    Return $$$OK
}

Method Execute()
{
    Set content = ..CreateZapApiScan()
    Do ..ScriptService.ExecuteScript(content)
}

Method CreateZapApiScan() As %String
{
    Set filename = ..GetFileNameFromOpenApiSpec()
    Set content = 
        "zap-api-scan.py "_
            "-t api-specs/"_..OpenApiSpec_" "_
            "-f openapi "_
            "-w report-md/"_filename_".md "_
            "-r report-html/"_filename_".html "
    Return content
}

Method GetFileNameFromOpenApiSpec() As %String
{
    Return $Piece(..OpenApiSpec, ".spec.json", 1)
}

Method WaitForZapApiScanResults(pTimeout As %Integer = 60) As %DynamicObject
{
    Set startTime = $Piece($Now(), ",", 2)
    While 1 {
        Quit:(..IsZapScanSuccessfulyFinished())

        Throw:(..IsZapScanFailed()) ##class(%Exception.General).%New(
            "Error in ZAP scan", , , ..ScriptService.GetScriptResults()
        )

        Set now = $Piece($Now(), ",", 2)
        Throw:(now - startTime > pTimeout) ##class(%Exception.General).%New(
            "Won't be able to get a successful response from ZAP in "_pTimeout_" seconds. Giving up...", , , ..ScriptService.GetScriptResults()
        )

        Hang 1
    }
    
    Set filePath = ..ScriptService.ZapPoolPath
    Set filename = ..GetFileNameFromOpenApiSpec()
    Return {
        "plain": (..ScriptService.GetScriptResults()),
        "md": (filePath_"/report-md/"_filename_".md"),
        "html": (filePath_"/report-html/"_filename_".html")
    }
}

Method IsZapScanSuccessfulyFinished() As %Boolean
{
    Set matchOKRegExp = "FAIL-NEW:.*FAIL-INPROG:.*WARN-NEW:.*WARN-INPROG:.*INFO:.*IGNORE:.*PASS:.*"
    Set zapResp = ..ScriptService.GetScriptResults()
    Return:(zapResp = "") 0
    Set lastLine = $Listget($Listfromstring(zapResp, ##class(dc.sample.zap.filepool.ScriptService).#LineTerminator), * - 2)
    Return $Match(lastLine, matchOKRegExp)
}

Method IsZapScanFailed() As %Boolean
{
    Set matchOKRegExp = ".*java\.lang\.Thread\.run\(Thread\.java.*"
    Set zapResp = ..ScriptService.GetScriptResults()
    Return:(zapResp = "") 0
    Set lastLine = $Listget($Listfromstring(zapResp, ##class(dc.sample.zap.filepool.ScriptService).#LineTerminator), * - 2)
    Return $Match(lastLine, matchOKRegExp)
}

}
