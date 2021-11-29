Class dc.sample.zap.filepool.ZapOpenApiScanService Extends dc.sample.zap.ZapOpenApiScanService
{

Method Run(pWebAppName As %String, pNameSpace As %String = {$Namespace}) As %DynamicObject
{
    Set specFile = $Replace($Replace($Now(), ".", ""), ",", "")_".spec.json"
    Set openApiService = ##class(dc.sample.zap.filepool.OpenApiService).%New(pWebAppName, pNameSpace, specFile)
    Set openapiFile = openApiService.SaveOpenApiSpec()

    Set zapApiScanScriptService = ##class(dc.sample.zap.filepool.ZapApiScanScriptService).%New(openapiFile)
    Do zapApiScanScriptService.Execute()
    Set results = zapApiScanScriptService.WaitForZapApiScanResults()
    Return results
}

Method Print(pWebAppName As %String, pNameSpace As %String = {$Namespace})
{
    Set results = ..Run(pWebAppName, pNameSpace)
    Write "-------------------------------------------", !
    Write "ZAP API Scan for: "_pWebAppName, !
    Write "-------------------------------------------", !
    Write results.plain, !
    Write "-------------------------------------------", !
    Write "Markdown: "_results.md, !
    Write "HTML: "_results.html, !
}

}
