/// Description
Class dc.sample.zap.filepool.ScriptService Extends %RegisteredObject
{

Parameter LineTerminator = {$Char(13,10)};

Property ZapPoolPath As %String [ InitialExpression = "/irisdev/app/zap-pool" ];

Property OutputFileName As %String;

Method %OnNew(pOutputFileName As %String) As %Status
{
    Set ..OutputFileName = ..ZapPoolPath_"/out/"_pOutputFileName
    Return $$$OK
}

Method SendScriptToPool(pScriptContent As %String)
{
    Set content = 
        pScriptContent_
        "> "_..OutputFileName_" "_
        "2>&1 &"
    Do $ZF(-1, "echo """_content_""" >> "_..ZapPoolPath_"/in/script.sh")
}

Method RemoveFile(pFileName As %String)
{
    Do $ZF(-1, "rm -f "_pFileName)
}

Method ExecuteScript(pScriptContent As %String)
{
    Do ..RemoveFile(..OutputFileName)
    Do ..SendScriptToPool(pScriptContent)
}

Method GetScriptResults() As %String
{
    Set content = ""
    If ('##class(%File).Exists(..OutputFileName)) {
        Return ""
    }
    Set file = ##class(%File).%New(..OutputFileName)
    Try {
        $$$TOE(st, file.Open("R"))
        While 'file.AtEnd {
            Set line = file.ReadLine()
            Set content = content_line_..#LineTerminator
        }
    }
    Catch(e) {
        Do file.Close()
        Throw e
    }
    Return content
}

}
