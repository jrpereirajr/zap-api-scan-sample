/// Description
Class dc.sample.zap.ZapOpenApiScanDispatcher Extends %CSP.REST [ System = 3 ]
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

Parameter HandleCorsRequest = 1;

Parameter Version = "1.0.0";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />
<Route Url="/webapp/:webapp" Method="GET" Call="ScanWebApp" Cors="true"/>
</Routes>
}

ClassMethod ScanWebApp(pWebApp As %String) As %Status
{
    Set pWebApp = $ZCVT(pWebApp, "I", "URL")
    Set service = ##class(dc.sample.zap.filepool.ZapOpenApiScanService).%New()
    Write service.Run(pWebApp).%ToJSON()
    Return $$$OK
}

ClassMethod SwaggerSpec() As %Status
{
  Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/zap-api-scan"
  Set swagger.info.title = "ZAP API Scan demo"
  Set swagger.info.version = "1"
  Set swagger.host = "localhost:52773"
  Write swagger.%ToJSON()
  Return $$$OK
}

}
