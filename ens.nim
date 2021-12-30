import std/[httpclient, json, strutils]
const url = "http://api.thegraph.com/subgraphs/name/ensdomains/ens"

func gql_query(ens: string): string =
    return "query{domains(where:{name:\"" & toLower(ens) & ".eth\"}){id}}"

func owner(elems: seq[JsonNode]): string =
    if len(elems) == 0:
        return "no owner found"
    else:
        return elems[0]["id"].getStr

proc get_owner(ens: string): string =
    let
        body = %*{"query": gql_query(ens)}
        client = newHttpClient()
        response = client.request(url, httpMethod = HttpPost, body = $body)
        parsed = response.body.parseJson
        elems = parsed["data"]["domains"].getElems
    
    return owner(elems)

echo "name,owner"
for line in lines "/in/input.csv":
    echo line & "," & get_owner line