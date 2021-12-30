import std/[httpclient, json, strutils, times]
const url = "http://api.thegraph.com/subgraphs/name/ensdomains/ens"

func gql_query(ens: string): string =
    return "query{domains(where:{name:\"" & toLower(ens) & ".eth\"}){id}}"

func owner(elems: seq[JsonNode]): (string, bool) =
    if len(elems) == 0:
        return ("no owner found", true)
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

var csv = open(now().format("yyyy-MM-dd hh:mm:ss tt") & ".csv", fmWrite)

for line in lines "/in/input.csv":
    let (owner, avail) = get_owner line
    echo "[" & line & "] " & owner
    if avail: csv.writeLine(line)