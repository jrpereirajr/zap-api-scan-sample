Class dc.sample.zap.OpenApiService Extends %RegisteredObject
{

Property WebAppName As %String;

Property NameSpace As %String;

Method %OnNew(pWebAppName As %String, pNameSpace As %String = {$Namespace}) As %Status
{
    Set ..WebAppName = pWebAppName
    Set ..NameSpace = pNameSpace
    Return $$$OK
}

Method GetOpenApiSpecFromWebApp() As %DynamicObject
{
    $$$TOE(st, ##class(%REST.API).GetWebRESTApplication(..NameSpace, ..WebAppName, .spec))
    Do spec.info.%Remove("x-ISC_Namespace")
    Set spec.host = "host.docker.internal:"_..GetInstanceWebPort()
    Set spec.schemes = ["http"]
    Return spec
}

Method GetInstanceWebPort() As %String [ Private ]
{
    // todo: check how to get this info from IRIS API
    Return "52773"
}

}
