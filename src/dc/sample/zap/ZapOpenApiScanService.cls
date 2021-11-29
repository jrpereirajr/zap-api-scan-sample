Class dc.sample.zap.ZapOpenApiScanService Extends %RegisteredObject [ Abstract ]
{

Method Run(pWebAppName As %String, pNameSpace As %String = {$Namespace}) As %DynamicObject [ Abstract ]
{
}

Method Print(pWebAppName As %String, pNameSpace As %String = {$Namespace}) [ Abstract ]
{
}

Method GetAllWebApps(pNameSpace As %String = {$Namespace}) As %DynamicArray
{
    Set webapps = []
    Set currNS = $Namespace
    Try {
        ZNspace "%SYS"
        Set sql = "select * from Security.Applications where NameSpace = ? and DispatchClass is not null"
        Set rs = ##class(%SQL.Statement).%ExecDirect(, sql, pNameSpace)
        ZNspace currNS
        Throw:(rs.%Message '= "") ##class(%Exception.SQL).CreateFromSQLCODE(rs.%SQLCODE, rs.%Message)
        While (rs.%Next()) {
            Set webapp = rs.ID
            Do webapps.%Push(webapp)
        }
    }
    Catch(e) {
        ZNspace currNS
        Throw e
    }
    Return webapps
}

Method RunAllWebApps(pNameSpace As %String = {$Namespace}) As %DynamicArray
{
    Set results = []
    Set webapps = ..GetAllWebApps(pNameSpace)
    Set iter = webapps.%GetIterator()
    While (iter.%GetNext(.key, .webapp)) {
        Do results.%Push(..Run(webapp, pNameSpace))
        Hang 1
    }
    Return results
}

Method PrintAllWebApps(pNameSpace As %String = {$Namespace})
{
    Set webapps = ..GetAllWebApps(pNameSpace)
    Set iter = webapps.%GetIterator()
    While (iter.%GetNext(.key, .webapp)) {
        Do ..Print(webapp, pNameSpace)
        Hang 1
    }
}

}
