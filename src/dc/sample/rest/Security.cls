/// Class to deploy roles and users
Class dc.sample.rest.Security
{

/// Create users
ClassMethod CreateUsers() As %Status
{
    Set sc = $$$OK
    // 
    &sql(CREATE USER Bill IDENTIFY BY ChangeMe)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)

    &sql(CREATE USER John IDENTIFY BY ChangeMe)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)

    Return sc
}

/// Create Roles
ClassMethod CreateRoles() As %Status
{
    Set sc = $$$OK
    &sql(CREATE ROLE Writer)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)

    &sql(GRANT UPDATE,INSERT ON dc_sample_rest.Person TO writer)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)


    &sql(CREATE ROLE Reader)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)

    &sql(GRANT SELECT ON dc_sample_rest.Person TO Reader)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)

    Return sc
}

/// Grant
ClassMethod GrantRoles() As %Status
{
    Set sc = $$$OK
    // do something

    &sql(GRANT Reader To Bill)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)

    &sql(GRANT Reader To UnknownUser)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)


    &sql(GRANT Writer To John)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)


    Return sc
}

}
