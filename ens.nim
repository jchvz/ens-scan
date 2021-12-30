import std/[httpclient, json, strutils, os, logging]
const url = "http://api.thegraph.com/subgraphs/name/ensdomains/ens"

func gql_query(ens: string): string =
    return "query{domains(where:{name:\"" & toLower(ens) & ".eth\"}){id}}"

func owner(elems: seq[JsonNode]): (string, bool) =
    if len(elems) == 0:
        return ("looks available!", true)
    else:
        return (elems[0]["id"].getStr, false)

proc get_owner(ens: string): (string, bool) =
    let
        body = %*{"query": gql_query(ens)}
        client = newHttpClient()
        response = client.request(url, httpMethod = HttpPost, body = $body)
        parsed = response.body.parseJson
        elems = parsed["data"]["domains"].getElems
    
    return owner(elems)

var logger: ConsoleLogger
if "--avail" in commandLineParams():
    logger = newConsoleLogger(lvlNotice)
    logger.log(lvlWarn, "Printing ONLY available ENS names")
else:
    logger = newConsoleLogger(lvlInfo)
    logger.log(lvlWarn, "Printing ALL ENS names")

for line in lines "/in/input.csv":
    let
        (owner, avail) = get_owner line
        msg = "[" & line & "] " & owner
    
    if avail:
        logger.log(lvlNotice, msg)
    else:
        logger.log(lvlInfo, msg)